import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'Logistics_DashBoard.dart';
import 'Logistics_Pending_Trips.dart';
import 'globals.dart' as globals;
import 'package:geolocator/geolocator.dart';



List<Step> steps = [];
String base64Image = "";

TextEditingController sampleController = TextEditingController();
TextEditingController contaiNErController = TextEditingController();
TextEditingController tRFController = TextEditingController();
TextEditingController remarksController = TextEditingController();

var routeMapID = "";
var userID = "";
var routeShitID = "";
int stepAreaCNT = 0;

class RouteStepperArea extends StatefulWidget {
  RouteStepperArea(rOUteMapID, rOUTeShiftID, uSErID, sTEPAreaCNT) {
    routeMapID = "";
    routeShitID = "";
    userID = "";
    stepAreaCNT = 0;
    routeMapID = rOUteMapID;
    routeShitID = rOUTeShiftID;
    userID = uSErID;
    stepAreaCNT = sTEPAreaCNT;
  }
  @override
  State<RouteStepperArea> createState() => _RouteStepperAreaState();
}

class _RouteStepperAreaState extends State<RouteStepperArea> {
  int currentStep = 0;

  // late int _CurrentIntValue = 0;

  areaRouteMapLocationrefr() {
    setState(() {});
  }

  File? file;
  List<File?> files = [];
  @override
  Widget build(BuildContext context) {
    if (int.parse(stepAreaCNT.toString()) > 0) {
      currentStep = int.parse(stepAreaCNT.toString());
    }
    //else {
    //   currentStep = 0;
    // }
    finishRouteAreaTrip() async {
      Map data = {
        "IP_REMARKS": "",
        "IP_USER_ID": userID.toString(),
        "IP_TRIP_ID": routeShitID.toString(),
        "connection": globals.Logistic_App_Connection_String
      };
      // ignore: avoid_print
      print(data.toString());

      final response = await http.post(
          Uri.parse(
              globals.Global_Logistic_Api_URL + "/Logistics/FinishedTrip"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (jsonDecode(response.body)["Data"][0]["CNT"] > 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LogisticDashboard()));
          submitLocationSampleSuccess();
        }
      } else {
        throw ("Failed to LOads From Api");
      }
    }

    continueTripRoutes(routeId, shiftId, userId) async {
      Uri jobsListAPIUrl;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "user_id": globals.Logistic_global_User_Id,
        "session_id": globals.pendingTripShiftId,
        "connection": globals.Logistic_App_Connection_String
        //"Server_Flag":""
      };
      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/Routes');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = jsonDecode(response.body);

        stepAreaCNT = jsonDecode(response.body)["Data"][0]["STEP_CNT"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RouteStepperArea(routeId, shiftId, userId, stepAreaCNT)));

        // continued('S');
        // currentStep = stepAreaCNT;

        // ignore: avoid_print
        print(jsonresponse.containsKey('Data'));
      } else {}
    }
String latitude = '';
String longitude = '';
   Future<void> getLocation() async {
    
  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case when the user denies permission again
      return;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Handle the case when the user denies permission permanently
    return;
  }
  
  // Proceed to retrieve the location
  print("Fetching location...");

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
   print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

  setState(() {
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  });
  print("Location updated: Latitude: $latitude, Longitude: $longitude");
}


    startReachedCompletedArea(String aREaID, String sTAUsFlag) async {
      globals.StartTimeAreaLocation = '';
      globals.ReachedTimeAreaLocation = '';
      globals.Total_SampleColectedByArea = '';
      globals.CompletedAreaID = "";
      // SampleController.text = "";
      // TRFController.text = "";
      // RemarksController.text = "";
      // globals.CompletedTimeAreaLocation = '';
      String totalSamples = "0";
      String TotalContainers = "0";
      String tRF = "";
      String rEMaRks = "";
      String tRFIMGPATH = "";
      String lONGITUDE = "";
      String lATTITUDE = "";

      if (sTAUsFlag == "C") {
        totalSamples = sampleController.text;
        TotalContainers = contaiNErController.text;
        tRF = tRFController.text;
        rEMaRks = remarksController.text;
        tRFIMGPATH = globals.TRFImgPath;
        lONGITUDE = longitude;
        lATTITUDE = latitude;
      } else {
        totalSamples = "0";
        TotalContainers = "0";
        tRF = "";
        rEMaRks = "";
        tRFIMGPATH = "";
        lATTITUDE = "";
        lONGITUDE = "";
      }
      Map data = {
        "IP_TRIP_SHIFT_ID": routeShitID,
        "IP_ROUTE_MAP_ID": routeMapID,
        "IP_USER_ID": userID,
        "IP_AREA_ID": aREaID,
        "IP_SESSION_ID": "3",
        "IP_FLAG": sTAUsFlag,
        "IP_TOTAL_SAMPLES": totalSamples,
        "IP_TOTAL_CONTAINERS": TotalContainers,
        "IP_TRF_NO": tRF,
        "IP_REMARKS": rEMaRks,
        "IMG_PATH": tRFIMGPATH,
        "IP_LATTITUDE": lATTITUDE,
        "IP_LONGITUDE": lONGITUDE,
        "IP-ADDRESS": "",
        "connection": globals.Logistic_App_Connection_String
      };
      // ignore: avoid_print
      print(data.toString());

      final response = await http.post(
          Uri.parse(
              globals.Global_Logistic_Api_URL + "/Logistics/TripTracking"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        sampleController.text = "";
        contaiNErController.text = "";
        tRFController.text = "";
        remarksController.text = "";
        globals.TRFImgPath = "";
        if (sTAUsFlag != "S") {
          globals.ReachedTimeAreaLocation =
              jsonDecode(response.body)["Data"][0]["REACHED_DT"].toString();
          globals.CompletedTimeAreaLocartion =
              jsonDecode(response.body)["Data"][0]["COMPLETED_DT"].toString();
        }
        globals.StartTimeAreaLocation =
            jsonDecode(response.body)["Data"][0]["START_DT"].toString();
        globals.CompletedAreaID =
            jsonDecode(response.body)["Data"][0]["AREA_ID"].toString();
        globals.Total_SampleColectedByArea =
            jsonDecode(response.body)["Data"][0]["TOTAL_SAMPLES"].toString();

        areaRouteMapLocationrefr();
        if (sTAUsFlag == "S") {
          //  RouteStepperArea(routeMapID, rOUTeShiftID, uSErID, sTEPAreaCNT)

          continueTripRoutes(
              routeMapID.toString(), routeShitID, userID.toString());
          globals.ShowReachedCompletedStartedData =
              jsonDecode(response.body)["Data"][0];
        }
        if (sTAUsFlag == "C") {
          Navigator.pop(context);
        }
      } else {}
    }

    steps = [];
    for (int i = 0;
        i <= globals.Logistic_Global_Route_Area["Data"].length - 1;
        i++) {
      steps.add(Step(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  globals.Logistic_Global_Route_Area["Data"][i]["AREA_NAME"],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                (i == 0 && currentStep == 0)
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(3, 4, 0, 0),
                        child: SizedBox(
                          height: 38,
                          width: 80,
                          child: Card(
                              color: const Color.fromARGB(255, 46, 56, 196),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: InkWell(
                                onTap: () {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16.0))),
                                              title: const Text(
                                                  'Do you want to Continue ?',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              content: Row(children: [
                                                InkWell(
                                                    onTap: () {
                                                      //print("Hussain print");
                                                      startReachedCompletedArea(
                                                          globals
                                                              .Logistic_Global_Route_Area[
                                                                  "Data"][i]
                                                                  ["AREA_ID"]
                                                              .toString(),
                                                          "S");
                                                      DateTime now =
                                                          DateTime.now();
                                                      String formattedTime =
                                                          DateFormat('hh:mm a')
                                                              .format(now);
                                                      globals.StartAreaTime =
                                                          formattedTime;
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Yes",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blue))),
                                                const Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No",
                                                        style: TextStyle(
                                                            color: Colors.red)))
                                              ]));
                                        });
                                      });
                                },
                                child: const Center(
                                  child: Text('Start To 2',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                              )),
                        ))
                    : (currentStep > 0 && i == 0)
                        ? Row(
                            children: [
                              // (currentStep == 0)
                              //     ?
                              Text(globals.StartAreaTime),
                              // : Text(""),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 4, 0, 0),
                                  child: SizedBox(
                                    height: 38,
                                    width: 80,
                                    child: Card(
                                        color: Colors.grey,
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: const Center(
                                          child: Text('Started',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        )),
                                  )),
                            ],
                          )
                        : const Text("")
              ],
            ),
          ],
        ),
        content: (i != 0)
            ? Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 5, 0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 7, 0),
                              child: Icon(Icons.timer, size: 18),
                            ),
                            (globals.ReachedTimeAreaLocation != "null" &&
                                    globals.ReachedTimeAreaLocation != '')
                                ? Text(globals.ReachedTimeAreaLocation)
                                : const Text("Not Reached"),
                            const Spacer(),
                            (globals.ReachedTimeAreaLocation != "null" &&
                                    globals.ReachedTimeAreaLocation != '')
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 4, 0, 0),
                                    child: SizedBox(
                                      height: 38,
                                      width: 80,
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 223, 221, 219),
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: InkWell(
                                            onTap: () {},
                                            child: const Center(
                                              child: Text('Reached',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          )),
                                    ))
                                : Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 4, 0, 0),
                                    child: SizedBox(
                                      height: 38,
                                      width: 80,
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 248, 151, 40),
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                      return AlertDialog(
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16.0))),
                                                          title: const Text(
                                                              'Do you want to Continue ?',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          content: Row(
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      startReachedCompletedArea(
                                                                          globals
                                                                              .Logistic_Global_Route_Area["Data"][i]["AREA_ID"]
                                                                              .toString(),
                                                                          "R");
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue))),
                                                                const Spacer(),
                                                                InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        "No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red)))
                                                              ]));
                                                    });
                                                  });
                                            },
                                            child: const Center(
                                              child: Text('Reached',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          )),
                                    ))
                          ],
                        ),
                      ),
                      (globals.ReachedTimeAreaLocation != "null" &&
                              globals.ReachedTimeAreaLocation != '')
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 5, 0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 0, 7, 0),
                                    child: Icon(Icons.timer, size: 18),
                                  ),
                                  (globals.CompletedTimeAreaLocartion !=
                                              "null" &&
                                          globals.CompletedTimeAreaLocartion !=
                                              '')
                                      ? Text(globals.CompletedTimeAreaLocartion)
                                      : const Text("Not Completed"),
                                  const Spacer(),
                                  (globals.CompletedTimeAreaLocartion !=
                                              "null" &&
                                          globals.CompletedTimeAreaLocartion !=
                                              '')
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 4, 0, 0),
                                          child: SizedBox(
                                            height: 38,
                                            width: 87,
                                            child: Card(
                                                color: const Color.fromARGB(
                                                    255, 223, 221, 219),
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: const Center(
                                                    child: Text('Comlpleted',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                )),
                                          ))
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 4, 0, 0),
                                          child: SizedBox(
                                            height: 38,
                                            width: 80,
                                            child: Card(
                                                color: const Color.fromARGB(
                                                    255, 96, 201, 122),
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: InkWell(
                                                  onTap: ()  {
                                                     //getLocation();
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        isDismissible: false,
                                                        enableDrag: false,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          50.0)),
                                                        ),
                                                        builder: (_) =>
                                                            SingleChildScrollView(
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom),
                                                                child: Card(
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius
                                                                                .vertical(
                                                                      bottom: Radius
                                                                          .circular(
                                                                              10.0),
                                                                      top: Radius
                                                                          .circular(
                                                                              50.0),
                                                                    )),
                                                                    child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                10,
                                                                                2,
                                                                                10,
                                                                                0),
                                                                            child: Card(
                                                                                color: const Color(0xFF164675),
                                                                                elevation: 1.0,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color.fromARGB(255, 219, 218, 218))),
                                                                                child: Column(children: [
                                                                                  Row(children: [
                                                                                    SizedBox(
                                                                                      height: 50,
                                                                                      width: 50,
                                                                                      child: Card(
                                                                                        color: const Color(0xFF164675),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                                        ),
                                                                                        elevation: 5,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 2),
                                                                                          child: Container(
                                                                                              decoration: const BoxDecoration(
                                                                                                  image: DecorationImage(
                                                                                            image: AssetImage("assets/MapTrackImg.png"),
                                                                                            fit: BoxFit.cover,
                                                                                          ))),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Column(crossAxisAlignment: CrossAxisAlignment.center, children: const [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(left: 20),
                                                                                        child: Text("Credential Collections", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                                                                                      ),
                                                                                    ])
                                                                                  ])
                                                                                ])),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 20.0),
                                                                            child:
                                                                                Row(children: [
                                                                              Text("Tubes : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                              SizedBox(
                                                                                width: 80,
                                                                                child: TextFormField(autofocus: true, keyboardType: TextInputType.number, controller: sampleController, decoration: const InputDecoration(hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none)),
                                                                              ),
                                                                              Text("Containers : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                              SizedBox(
                                                                                width: 40,
                                                                                child: TextFormField(autofocus: true, keyboardType: TextInputType.number, controller: contaiNErController, decoration: const InputDecoration(hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none)),
                                                                              ),
                                                                            ]),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 24.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text("TRF : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                SizedBox(
                                                                                    width: 80,
                                                                                    child: TextFormField(
                                                                                      autofocus: true,
                                                                                      keyboardType: TextInputType.number,
                                                                                      controller: tRFController,
                                                                                      decoration: const InputDecoration(hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
                                                                                    )),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 12.0),
                                                                                  child: Text("Remarks : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                ),
                                                                                SizedBox(
                                                                                    width: 120,
                                                                                    child: TextFormField(
                                                                                      autofocus: true,
                                                                                      controller: remarksController,
                                                                                      decoration: const InputDecoration(hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
                                                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      globals.TRFImgPath = "";
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 100,
                                                                                      //  margin: EdgeInsets.symmetric(horizontal: 60),
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                                                                      child: Card(
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color.fromARGB(255, 219, 218, 218))),
                                                                                        color: const Color.fromARGB(159, 186, 199, 236),
                                                                                        child: const Center(
                                                                                          child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                InkWell(
                                                                                  onTap: ()  {
                                                                                 //    getLocation();
                                                                                    if (sampleController.text == "") {
                                                                                      Fluttertoast.showToast(msg: "Please Enter the Samples", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: const Color.fromARGB(255, 238, 26, 11), textColor: Colors.white, fontSize: 16.0);
                                                                                    } else if (tRFController.text == "") {
                                                                                      Fluttertoast.showToast(msg: "Please Enter the TRF", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: const Color.fromARGB(255, 238, 26, 11), textColor: Colors.white, fontSize: 16.0);
                                                                                    } else if (contaiNErController.text == "") {
                                                                                      Fluttertoast.showToast(msg: "Please Enter the Containers", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: const Color.fromARGB(255, 238, 26, 11), textColor: Colors.white, fontSize: 16.0);
                                                                                    }
                                                                                    // else if (RemarksController.text.toString() == "") {
                                                                                    //   Fluttertoast.showToast(msg: "Please Enetr the Remarks", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Color.fromARGB(255, 238, 26, 11), textColor: Colors.white, fontSize: 16.0);
                                                                                    // }
                                                                                    else {
                                                                                      startReachedCompletedArea(globals.Logistic_Global_Route_Area["Data"][i]["AREA_ID"].toString(), "C");
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 40,
                                                                                    width: 100,
                                                                                    //  margin: EdgeInsets.symmetric(horizontal: 60),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                                                                    child: Card(
                                                                                      color: const Color(0xFF164675),
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color.fromARGB(255, 219, 218, 218))),
                                                                                      child: const Center(
                                                                                        child: Text("Ok", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ]))
                                                                        ])),
                                                              ),
                                                            ));
                                                            getLocation();
                                                  },
                                                  child: const Center(
                                                    child: Text('Complete',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                )),
                                          ))
                                ],
                              ),
                            )
                          : Container(),
                      (globals.ReachedTimeAreaLocation != "null" &&
                              globals.ReachedTimeAreaLocation != '' &&
                              globals.CompletedTimeAreaLocartion != "null" &&
                              globals.CompletedTimeAreaLocartion != "" &&
                              currentStep !=
                                  globals.Logistic_Global_Route_Area["Data"]
                                          .length -
                                      1)
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 5, 0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 0, 7, 0),
                                    child: Icon(Icons.timer, size: 18),
                                  ),
                                  (globals.StartTimeAreaLocation != "null" &&
                                          globals.StartTimeAreaLocation != '')
                                      ? Text(globals.StartTimeAreaLocation)
                                      : const Text("Not Started"),
                                  const Spacer(),
                                  (globals.StartTimeAreaLocation != "null" &&
                                          globals.StartTimeAreaLocation != '' &&
                                          globals.StartTimeAreaLocation !=
                                              "null" &&
                                          globals.StartTimeAreaLocation != '')
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 4, 0, 0),
                                          child: SizedBox(
                                            height: 38,
                                            width: 80,
                                            child: Card(
                                                color: const Color.fromARGB(
                                                    255, 223, 221, 219),
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: const Center(
                                                    child: Text('Started',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                )),
                                          ))
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 4, 0, 0),
                                          child: SizedBox(
                                            height: 38,
                                            width: 80,
                                            child: Card(
                                                color: const Color.fromARGB(
                                                    232, 51, 106, 224),
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return AlertDialog(
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            16.0))),
                                                                title: const Text(
                                                                    'Do you want to Continue ?',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500)),
                                                                content: Row(
                                                                    children: [
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            startReachedCompletedArea(globals.Logistic_Global_Route_Area["Data"][i]["AREA_ID"].toString(),
                                                                                "S");
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text(
                                                                              "Yes",
                                                                              style: TextStyle(color: Colors.blue))),
                                                                      const Spacer(),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text(
                                                                              "No",
                                                                              style: TextStyle(color: Colors.red)))
                                                                    ]));
                                                          });
                                                        });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                        'Start To ' +
                                                            (currentStep + 2)
                                                                .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                )),
                                          ))
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ))
            : Row(),
        isActive: currentStep >= steps.length,
        state: currentStep >= steps.length
            ? StepState.complete
            : StepState.disabled,
      ));
    }

    cancelRouteAreaTrip() async {
      Map data = {
        "IP_TRIP_ID": routeShitID.toString(),
        "IP_SESSION_ID": "1",
        "connection": globals.Logistic_App_Connection_String
      };
      // ignore: avoid_print
      print(data.toString());

      final response = await http.post(
          Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/GET_TRIP'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (jsonDecode(response.body)["Data"][0]["TRIP_REJECT_DT"] != null) {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      title: const Text('Do you want to Continue ?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      content: Row(children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PendingTrips()));
                            },
                            child: const Text("Yes",
                                style: TextStyle(color: Colors.blue))),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No",
                                style: TextStyle(color: Colors.red)))
                      ]));
                });
              });
        } else {
          return Fluttertoast.showToast(
              msg: "Please complete the Trip",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 238, 26, 11),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        throw ("Failed to LOads From Api");
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  cancelRouteAreaTrip();
                },
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 18)),
            backgroundColor: const Color(0xff123456),
            elevation: 0,
            title: const Text('Trips Routes',
                style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stepper(
              steps: steps,
              currentStep: currentStep,
              type: StepperType.vertical,
              controlsBuilder: (BuildContext context, details) {
                return Column(children: []);
              },
              //  onStepTapped: tapped,
              // onStepCancel: cancel,
              // onStepContinue: continued,
            ),
          ),
          bottomNavigationBar: (globals
                              .Logistic_Global_Route_Area["Data"].length -
                          1 ==
                      currentStep &&
                  globals.ReachedTimeAreaLocation != "null" &&
                  globals.ReachedTimeAreaLocation != "" &&
                  globals.CompletedTimeAreaLocartion != "null")
              ? InkWell(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                                //  title: const Text('Ordered Sucessfully'),
                                title: const Text('Do you want to Finish ?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                content: Row(children: [
                                  InkWell(
                                      onTap: () {
                                        finishRouteAreaTrip();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes",
                                          style:
                                              TextStyle(color: Colors.blue))),
                                  const Spacer(),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No",
                                          style: TextStyle(color: Colors.red)))
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: SizedBox(
                          height: 50,
                          child: Card(
                              color: const Color(0xff123456),
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                  child: Text(
                                'Finish',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )))),
                    ),
                  ),
                )
              : const Text("")),
    );
  }

  // tapped(step) {
  //   setState(() => currentStep = step);
  //   print(step);
  // }

  continued(flag) {
    if (globals.Logistic_Global_Route_Area["Data"].length - 1 != currentStep) {
      if (flag == "S") {
        setState(() {
          currentStep < steps.length - 1 ? currentStep += 1 : currentStep = 0;
          flag = "";
        });
      }
      stepAreaCNT = 0;
    }
  }

// cancel() {
//   currentStep > 0 ? currentStep -= 1 : currentStep = 0;
// }
}

submitLocationSampleSuccess() {
  return Fluttertoast.showToast(
      msg: "Saved Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 72, 201, 105),
      textColor: Colors.white,
      fontSize: 16.0);
}

submitLocationSamplefailed() {
  return Fluttertoast.showToast(
      msg: "Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
