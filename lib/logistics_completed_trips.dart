// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'Logistics_DashBoard.dart';
import 'Logistics_Pending_Trips.dart';
import 'globals.dart' as globals;

var CMP_ROUTE_MAP_ID = "";
var CMP_ROUTE_SHIFT_ID = "";
var CMP_ROUTE_NAME = "";
TextEditingController SubmitRemarksController = TextEditingController();
TextEditingController RecievedByController = TextEditingController();
TextEditingController RecievedSamplesController = TextEditingController();
String base64Image = "";

class CompletedTripsSubmit extends StatefulWidget {
  CompletedTripsSubmit(CmpRouteMapID, CmpRouteShiftID, CmpRouteName) {
    CMP_ROUTE_MAP_ID = "";
    CMP_ROUTE_SHIFT_ID = "";
    CMP_ROUTE_NAME = "";
    CMP_ROUTE_MAP_ID = CmpRouteMapID;
    CMP_ROUTE_SHIFT_ID = CmpRouteShiftID;
    CMP_ROUTE_NAME = CmpRouteName;
  }

  @override
  State<CompletedTripsSubmit> createState() => _CompletedTripsSubmitState();
}

class _CompletedTripsSubmitState extends State<CompletedTripsSubmit> {
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<File?> files = [];
  @override
  Widget build(BuildContext context) {
    Future<List<CompletedTripsModels>> _fetchCompletedTrips() async {
      var jobsListAPIUrl;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_ROUTE_ID": CMP_ROUTE_MAP_ID,
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_SESSION_ID": "1",
        "IP_FLAG": "C",
        "IP_TRIP_SHIFT_ID": CMP_ROUTE_SHIFT_ID,
        "connection": globals.Logistic_App_Connection_String
        //"Server_Flag":""
      };
      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/Routeareas');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = jsonDecode(response.body);
        print(jsonresponse.containsKey('Data'));
        listresponse = jsonresponse[dsetName];
        globals.CompleteddataLastIndex = jsonDecode(response.body)["Data"];

        return listresponse
            .map((smbtrans) => CompletedTripsModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget CompletedTripsData = Container(
      child: FutureBuilder<List<CompletedTripsModels>>(
          future: _fetchCompletedTrips(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return CompletedTripsDetailsList(data, context);
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );
    submitREMARKSBASE64image(tRipID, userID, bASE64Image) async {
      Map data = {
        "Trip_id": tRipID,
        "Base64String": bASE64Image,
        "session_id": userID,
        "connection": globals.Logistic_App_Connection_String
      };
      final jobsListAPIUrl = Uri.parse(
          '${globals.Global_Logistic_Api_URL}/Logistics/UpdateSubmitImageBytes');

      var bodys = json.encode(data);

      var response = await http.post(jobsListAPIUrl,
          headers: {"Content-Type": "application/json"}, body: bodys);
      print("${response.statusCode}");
      print("${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne["Data"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const LogisticDashboard())));
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    submitCenterLocationData(BuildContext context, base64image) async {
      Map data = {
        "IP_SAMPLES": globals.SubmitTotalSamples.toString(),
        "IP_LOCATION_ID": globals.SubmitLocationID.toString(),
        "IP_REMARKS": SubmitRemarksController.text.toString(),
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_TRIP_ID": CMP_ROUTE_SHIFT_ID.toString(),
        "IP_RECEIVED_SAMPLES": RecievedSamplesController.text.toString(),
        "IP_RECEIVER_NAME": RecievedByController.text.toString(),
        "IP_SHIFT_FROM": "",
        "IP_SHIFT_TO": "",
        "connection": globals.Logistic_App_Connection_String
      };

      final response = await http.post(
          Uri.parse(
              globals.Global_Logistic_Api_URL + '/Logistics/Submitsamples'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        print(resposne["Data"]);
        submitREMARKSBASE64image(
            CMP_ROUTE_SHIFT_ID, globals.Logistic_global_User_Id, base64image);

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const LogisticDashboard()));
        // SubmitLocationSampleSuccess();
        globals.SubmitTotalSamples = 0;
        globals.SubmitLocationID = "";
        SubmitRemarksController.text = "";
        RecievedByController.text = "";
        RecievedSamplesController.text = "";
      } else {
        SubmitLocationSamplefailed();
      }
    }

    final submitboTTOMBAR = InkWell(
      onTap: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    //  title: const Text('Ordered Sucessfully'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 218, 218))),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 43,
                                      width: 45,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                            image: AssetImage(
                                                "assets/MapTrackImg.png"),
                                            fit: BoxFit.cover,
                                          ))),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 8, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(CMP_ROUTE_NAME,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 0, 2),
                                          child: Row(
                                            children: [
                                              const Text("Samples Collected : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                child: SizedBox(
                                                  height: 25,
                                                  width: 35,
                                                  child: Card(
                                                    elevation: 3.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    color: Colors.green[400],
                                                    child: Center(
                                                      child: Text(
                                                          globals.SubmitTotalSamples
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 0, 4),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 165,
                                                child: Text(
                                                    "To be Submitted : " +
                                                        globals
                                                            .Submit_Location_Name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ])),

                          //     // SizedBox(
                          //     //     width: 130,
                          //     //     height: 50,
                          //     //     child: DropdownButtonHideUnderline(
                          //     //       child: DropdownButton(
                          //     //         isDense: true,
                          //     //         isExpanded: true,
                          //     //         value: _selectedItem,
                          //     //         hint: Text('Select Location'),
                          //     //         onChanged: (value) {
                          //     //           setState(() {
                          //     //             _selectedItem = value;
                          //     //             globals.SubmitLocationID =
                          //     //                 _selectedItem;
                          //     //           });
                          //     //         },
                          //     //         items: data.map((ldata) {
                          //     //           return new DropdownMenuItem(
                          //     //             child: new Text(
                          //     //               ldata['LOCATION_NAME'].toString(),
                          //     //               style: TextStyle(
                          //     //                   fontSize: 14,
                          //     //                   color: Colors.black54),
                          //     //             ),
                          //     //             value:
                          //     //                 ldata['LOCATION_ID'].toString(),
                          //     //           );
                          //     //         }).toList(),
                          //     //       ),
                          //     //     ))
                          //   ],
                          // ),
                          // // ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: Row(children: [
                              const Text("Received Tubes & Containers : ",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                  width: 40,
                                  child: TextFormField(
                                    controller: RecievedSamplesController,
                                    decoration: const InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ))
                            ]),
                          ),
                          Row(children: [
                            const Text("Received By : ",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                                width: 140,
                                child: TextFormField(
                                  controller: RecievedByController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ))
                          ]),
                          Row(
                            children: [
                              Row(children: [
                                const Text("Remarks : ",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: SubmitRemarksController,
                                      decoration: const InputDecoration(
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ))
                              ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Capture : ",
                                  style: TextStyle(fontSize: 14)),
                              InkWell(
                                onTap: () async {
                                  XFile? photo = await _picker.pickImage(
                                      source: ImageSource.camera,
                                      maxHeight: 480,
                                      maxWidth: 640,
                                      imageQuality: 100,
                                      preferredCameraDevice: CameraDevice.rear);

                                  if (photo == null) {
                                  } else {
                                    setState(() {
                                      file = File(photo.path);
                                      files.add(File(photo.path));
                                      final bytes =
                                          File(photo.path).readAsBytesSync();
                                      base64Image = base64Encode(bytes);
                                    });
                                  }
                                },
                                child: Card(
                                    color: const Color(0xff123456),
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      child: Icon(
                                        Icons.flip_camera_ios_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: SizedBox(
                                          height: 37,
                                          width: 80,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 76, 127, 168))),
                                            color: const Color.fromARGB(
                                                255, 213, 218, 223),
                                            child: const Center(
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // if (globals.SubmitLocationID == "") {
                                        //   Fluttertoast.showToast(
                                        //       msg: "Please Select the Location",
                                        //       toastLength: Toast.LENGTH_SHORT,
                                        //       gravity: ToastGravity.CENTER,
                                        //       timeInSecForIosWeb: 1,
                                        //       backgroundColor: Color.fromARGB(
                                        //           255, 238, 26, 11),
                                        //       textColor: Colors.white,
                                        //       fontSize: 16.0);
                                        // } else
                                        if (RecievedSamplesController.text
                                                .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Enetr the Samples",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (RecievedByController.text
                                                .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Enetr the Reciever",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (SubmitRemarksController.text
                                                .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Enetr the Remarks",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (base64Image == "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Upload the TRF Form",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          submitCenterLocationData(
                                              context, base64Image);
                                        }
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: 60,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 222, 227, 231))),
                                          color: const Color(0xff123456),
                                          child: const Center(
                                            child: Text("Ok",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]))
                        ]));
              });
            });
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
              Color.fromARGB(255, 229, 228, 233),
              Color.fromARGB(255, 229, 229, 231),
              // Color.fromARGB(255, 233, 233, 235)
            ])),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
          child: SizedBox(
              height: 50,
              child: Card(
                  color: const Color(0xff123456),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )))),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff123456),
        title: Text(CMP_ROUTE_NAME,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        bottomOpacity: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CompletedTripsData),
      bottomNavigationBar: submitboTTOMBAR,
    );
  }
}

class CompletedTripsModels {
  final Comp_Area_ID;
  final Comp_AREA_Name;
  final Comp_Total_Samples;
  final Comp_total_Containers;
  final Comp_Start_DT;
  final Comp_Accept_DT;
  final Comp_Reached_DT;
  final Comp_Reject_DT;
  final Comp_Longitude;
  final Comp_Latitude;
  final Comp_Trip_Shift_ID;
  final Comp_Remarks;
  final Comp_TRF_NO;
  final Comp_Completed_DT;

  CompletedTripsModels(
      {required this.Comp_Area_ID,
      required this.Comp_AREA_Name,
      required this.Comp_Total_Samples,
      required this.Comp_total_Containers,
      required this.Comp_Start_DT,
      required this.Comp_Accept_DT,
      required this.Comp_Reached_DT,
      required this.Comp_Reject_DT,
      required this.Comp_Longitude,
      required this.Comp_Latitude,
      required this.Comp_Trip_Shift_ID,
      required this.Comp_Remarks,
      required this.Comp_TRF_NO,
      required this.Comp_Completed_DT});
  factory CompletedTripsModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return CompletedTripsModels(
        Comp_Area_ID: json["AREA_ID"].toString(),
        Comp_AREA_Name: json["AREA_NAME"].toString(),
        Comp_Total_Samples: json["TOTAL_SAMPLES"].toString(),
        Comp_total_Containers: json["CONTAINERS"].toString(),
        Comp_Start_DT: json["START_DT"].toString(),
        Comp_Accept_DT: json["ACCEPT_DT"].toString(),
        Comp_Reached_DT: json["REACHED_DT"].toString(),
        Comp_Reject_DT: json["REJECT_DT"].toString(),
        Comp_Longitude: json["LONGITUDE"].toString(),
        Comp_Latitude: json["LATTITUDE"].toString(),
        Comp_Trip_Shift_ID: json["TRIP_SHIFT_ID"].toString(),
        Comp_Remarks: json["REMARKS"].toString(),
        Comp_TRF_NO: json["TRF_NO"].toString(),
        Comp_Completed_DT: json["COMPLETED_DT"].toString());
  }
}

Widget CompletedTripsDetailsList(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildCompletedTrips(data[index], context, index);
      });
}

Widget _buildCompletedTrips(data, BuildContext context, int index) {
  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Color.fromARGB(68, 160, 144, 144))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                      height: 35,
                      width: 300,
                      child: Card(
                          color: Colors.grey[200],
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Color.fromARGB(68, 160, 144, 144))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 3, 0, 3),
                            child: Row(children: [
                              const Icon(
                                Icons.location_pin,
                                size: 22,
                                color: Color.fromARGB(255, 24, 167, 114),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(data.Comp_AREA_Name,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                            ]),
                          )))
                ]),
              ),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Reached :",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Reached_DT,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500))
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Completed : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Completed_DT,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500))
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != globals.CompleteddataLastIndex.length - 1)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text(
                            "Start : ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            data.Comp_Start_DT,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? const Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 1,
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Collected Tubes : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Total_Samples,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
                  (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Containers : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_total_Containers,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Remarks : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Remarks,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 8),
                      child: Row(
                        children: [
                          const Text("TRF NO : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_TRF_NO,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    ),
  );
}

SubmitLocationSampleSuccess() {
  return Fluttertoast.showToast(
      msg: "Saved Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 72, 201, 105),
      textColor: Colors.white,
      fontSize: 16.0);
}

SubmitLocationSamplefailed() {
  return Fluttertoast.showToast(
      msg: "Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
