import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'BottomNavigationWidget.dart';
import 'Logistics_DashBoard.dart';

import 'package:http/http.dart' as http;
import 'Logistics_Login.dart';
import 'globals.dart' as globals;
import 'Logistics_Trip_Routes_Area.dart';

class PendingTrips extends StatefulWidget {

  @override
  State<PendingTrips> createState() => _PendingTripsState();
}

class _PendingTripsState extends State<PendingTrips> {
  @override
  Widget build(BuildContext context) {
    Future<List<logisticsTripRoutesModels>> _fetchTripRoutes() async {
      var jobsListAPIUrl;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "user_id": globals.Logistic_global_User_Id,
        "session_id": "0",
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
        print(jsonresponse.containsKey('Data'));
        listresponse = jsonresponse[dsetName];
        return listresponse
            .map((smbtrans) => logisticsTripRoutesModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget LogisticTripRoutes = Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: FutureBuilder<List<logisticsTripRoutesModels>>(
          future: _fetchTripRoutes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return TripRoutesDetailsList(data, context);
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    String formattedTimeForDisable = DateFormat('hh:mm a').format(now);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff123456),
        title: Row(
          children: [
            const Text('My Trips',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const Spacer(),
            Text(formattedDate,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18))
          ],
        ),
        elevation: 0.0,
      ),
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: LogisticTripRoutes),
      bottomNavigationBar: const LogisticBottomBar(),
    );
  }
}

class logisticsTripRoutesModels {
  final Trip_Shift_ID;
  final User_ID;
  final Shift_From;
  final Shift_To;
  final Trip_Sch_Date;
  final Route_map_ID;
  final Shift_From_Dt;
  final Shift_To_DT;
  final Route_Name;
  final Step_Area_Count;
  final Trip_Active_Status;

  logisticsTripRoutesModels(
      {required this.Trip_Shift_ID,
      required this.User_ID,
      required this.Shift_From,
      required this.Shift_To,
      required this.Trip_Sch_Date,
      required this.Route_map_ID,
      required this.Shift_From_Dt,
      required this.Shift_To_DT,
      required this.Route_Name,
      required this.Step_Area_Count,
      required this.Trip_Active_Status});

  factory logisticsTripRoutesModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return logisticsTripRoutesModels(
      Trip_Shift_ID: json['TRIP_SHIFT_ID'].toString(),
      User_ID: json['user_id'].toString(),
      Shift_From: json['SHIFT_FROM'].toString(),
      Shift_To: json['SHIFT_TO'].toString(),
      Trip_Sch_Date: json['trip_sch_date'].toString(),
      Route_map_ID: json['ROUTE_MAP_ID'].toString(),
      Shift_From_Dt: json['SHIFT_FROM_DT'].toString(),
      Shift_To_DT: json['SHIFT_TO_DT'].toString(),
      Route_Name: json['ROUTE_NAME'].toString(),
      Step_Area_Count: json['STEP_CNT'].toString(),
      Trip_Active_Status: json['IS_ACTIVE'].toString(),
    );
  }
}

Widget TripRoutesDetailsList(data, BuildContext context) {
  int i = 0;
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildTripRoutes(data[index], context, index + 1);
      });
}

Widget _buildTripRoutes(data, BuildContext context, index) {
  _TripRouteArea(RouteMapID, TripShiftID, UserID, StepAreaCount) async {
    globals.Logistic_Global_Route_Area = null;
    var jobsListAPIUrl;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "IP_ROUTE_ID": RouteMapID,
      "IP_USER_ID": globals.Logistic_global_User_Id,

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
      globals.Logistic_Global_Route_Area = jsonDecode(response.body);
      var RouteAreaID = jsonDecode(response.body)["Data"][0]["AREA_ID"];
      globals.pendingTripShiftId = TripShiftID;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RouteStepperArea(
                  RouteMapID, TripShiftID, UserID, StepAreaCount)));
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  RouteAreaAcceptReject(
      RouteMapID, TripShiftID, UserID, String Flg, int StepAreaCount) async {
    var jobsListAPIUrl;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "IP_TRIP_SHIFT_ID": TripShiftID,
      "IP_USER_ID": globals.Logistic_global_User_Id,
      "IP_FLAG": Flg,
      "connection": globals.Logistic_App_Connection_String
      //"Server_Flag":""
    };
    dsetName = 'Data';
    jobsListAPIUrl =
        Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/Accepttrip');
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
      if (Flg == "AC") {
        _TripRouteArea(RouteMapID, TripShiftID, UserID, StepAreaCount);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  PendingTrips()));
      }
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  return GestureDetector(
      child: (int.parse(data.Step_Area_Count.toString()) > 0)
          ? InkWell(
              onTap: () {
                globals.LocationSubmitShiftFromTimeStart = data.Shift_From_Dt;
                globals.LocationSubmitShiftTotimeEnd = data.Shift_To_DT;
                globals.Logistic_Global_Route_Area = null;
                _TripRouteArea(data.Route_map_ID, data.Trip_Shift_ID,
                    data.User_ID, int.parse(data.Step_Area_Count.toString()));
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 1),
                  child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 219, 218, 218))),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                      image:
                                          AssetImage("assets/MapTrackImg.png"),
                                      fit: BoxFit.cover,
                                    ))),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 5,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 2),
                                    child: Row(
                                      children: [
                                        Text(data.Route_Name,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 2),
                                    child: Row(
                                      children: [
                                        Text("Start : " + data.Shift_From,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                width: MediaQuery.of(context).size.width * 0.07,
                                color: Colors.green[300],
                                child: const RotatedBox(
                                  quarterTurns: -1,
                                  child: Center(
                                    child: Text("Continue",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]))),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 1),
              child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 219, 218, 218))),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                  image: AssetImage("assets/MapTrackImg.png"),
                                  fit: BoxFit.cover,
                                ))),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 2),
                                child: Row(
                                  children: [
                                    Text(data.Route_Name,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                                child: Row(
                                  children: [
                                    Text("Start : " + data.Shift_From,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          (data.Trip_Active_Status == "N")
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  color: Colors.orange[300],
                                  child: const RotatedBox(
                                    quarterTurns: -1,
                                    child: Center(
                                      child: Text("Expired",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                )
                              : const Text("")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(9, 3, 0, 8),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              (data.Trip_Active_Status == "N")
                                  ? null
                                  : showDialog<String>(
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
                                                  'Do you want to Accept ?',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              content: Row(children: [
                                                InkWell(
                                                    onTap: () {
                                                      globals.LocationSubmitShiftFromTimeStart =
                                                          data.Shift_From_Dt;
                                                      globals.LocationSubmitShiftTotimeEnd =
                                                          data.Shift_To_DT;
                                                      globals.Logistic_Global_Route_Area =
                                                          null;
                                                      RouteAreaAcceptReject(
                                                          data.Route_map_ID,
                                                          data.Trip_Shift_ID,
                                                          data.User_ID,
                                                          "AC",
                                                          int.parse(
                                                              data.Step_Area_Count
                                                                  .toString()));
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
                            child: SizedBox(
                                height: 35,
                                width: 130,
                                child: Card(
                                  // color: Color.fromARGB(255, 126, 144, 153),
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 218, 209, 209))),
                                  child: Center(
                                      child: Row(
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        child: Icon(Icons.thumb_up_alt_outlined,
                                            color: Colors.blue, size: 15),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  )),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              (data.Trip_Active_Status == "N")
                                  ? null
                                  : showDialog<String>(
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
                                                  'Do you want to Reject ?',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              content: Row(children: [
                                                InkWell(
                                                    onTap: () {
                                                      RouteAreaAcceptReject(
                                                          data.Route_map_ID,
                                                          data.Trip_Shift_ID,
                                                          data.User_ID,
                                                          "RE",
                                                          int.parse(
                                                              data.Step_Area_Count
                                                                  .toString()));
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: SizedBox(
                                  height: 35,
                                  width: 130,
                                  child: Card(
                                    // color: Color.fromARGB(255, 126, 144, 153),
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 218, 209, 209))),
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 5, 0),
                                          child: Icon(
                                              Icons.thumb_down_alt_outlined,
                                              size: 15,
                                              color: Colors.red),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Reject",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]))));
}
//'TRIP ' + index.toString()

class NoContent extends StatelessWidget {
  const NoContent();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Color.fromARGB(255, 119, 115, 115),
              size: 50,
            ),
            Text('No Data Found'),
          ],
        ),
      ),
    );
  }
}
