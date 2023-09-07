import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigationWidget.dart';
import 'logistics_completed_trips.dart';
import 'logistics_completed_submitted_rejected_trips.dart';
import 'Logistics_Login.dart';
import 'Logistics_Pending_Trips.dart';
import 'Logistics_Submitted_Trips.dart';

import 'globals.dart' as globals;

class LogisticDashboard extends StatefulWidget {
  const LogisticDashboard({super.key});


  @override
  State<LogisticDashboard> createState() => _LogisticDashboardState();
}

class _LogisticDashboardState extends State<LogisticDashboard> {
  @override
  Widget build(BuildContext context) {
   

    DateTime now = DateTime.now();
    String CurrentDate = DateFormat('dd-MMM-yyyy').format(now);

    Future<List<logisticsDashBoardModels>> _fetchDashBoard() async {
      var jobsListAPIUrl;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_FROM_DT": CurrentDate,
        "IP_TO_DT": CurrentDate,
        "connection": globals.Logistic_App_Connection_String
        //"Server_Flag":""
      };
      dsetName = 'Data';
      jobsListAPIUrl = Uri.parse(
          globals.Global_Logistic_Api_URL + '/Logistics/Userwisetrips');
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
            .map((smbtrans) => logisticsDashBoardModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget LogisticDashBoardData = Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: FutureBuilder<List<logisticsDashBoardModels>>(
          future: _fetchDashBoard(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return DashboardDataDetailsList(data, context);
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff123456),
        title: Row(
          children: [
            SizedBox(
                height: 40,
                width: 90,
                child: Image(image: NetworkImage(globals.All_Client_Logo))),
            const Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text("Dashboard",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        bottomOpacity: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 229, 228, 233),
          Color.fromARGB(255, 229, 229, 231),
          Color.fromARGB(255, 246, 246, 247)
        ])),
        child: LogisticDashBoardData,
      ),
      bottomNavigationBar: const LogisticBottomBar(),
    );
  }
}

class logisticsDashBoardModels {
  final Pending_Trips;
  final Completed_Trips;
  final Submitted_Trips;
  final Rejected_Trips;
  final User_Wise_Complete_Trips;
  final User_Wise_Submission;
  final Total_Completed_Trips;
  final Total_Completed_Samples;
  logisticsDashBoardModels({
    required this.Pending_Trips,
    required this.Completed_Trips,
    required this.Submitted_Trips,
    required this.Rejected_Trips,
    required this.User_Wise_Complete_Trips,
    required this.User_Wise_Submission,
    required this.Total_Completed_Trips,
    required this.Total_Completed_Samples,
  });
  factory logisticsDashBoardModels.fromJson(Map<String, dynamic> json) {
    print(json);
    // if (json["TOTAL_COLLECTED_SAMPLES"].toString() == null) {
    //   json["TOTAL_COLLECTED_SAMPLES"] == 0;
    // }
    return logisticsDashBoardModels(
      Pending_Trips: json["PENDING_TRIPS"].toString(),
      Completed_Trips: json["COMPLETED_TRIPS"].toString(),
      Submitted_Trips: json["SUBMITTED_TRIPS"].toString(),
      Rejected_Trips: json["REJECTED_TRIPS"].toString(),
      User_Wise_Complete_Trips: json["USER_WISE_COMPLETE_TRIPS"].toString(),
      User_Wise_Submission: json["USER_WISE_SUBMISSION"].toString(),
      Total_Completed_Trips: json["TOTAL_TRIPS"].toString(),
      Total_Completed_Samples: json["TOTAL_COLLECTED_SAMPLES"].toString(),
    );
  }
}

Widget DashboardDataDetailsList(data, BuildContext context) {
  int i = 0;
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildDashboardData(data[index], context);
      });
}

DateTime now = DateTime.now();
String DateFormatt = DateFormat('dd-MMM-yyyy').format(now);

Widget _buildDashboardData(data, BuildContext context) {
  return GestureDetector(
      child: Column(children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(234, 189, 206, 198),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Row(children: [
              const Icon(Icons.account_box_sharp),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(globals.Login_User_Name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              )
            ]),
          )),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(234, 189, 206, 198),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 4, 5, 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            child: const Center(
                                child: Text("Totals",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))),
                          ),
                        )
                      ]),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 10, 20, 8),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.directions_bike,
                                    color: Color.fromARGB(230, 69, 196, 86),
                                    size: 18),
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text('Completed',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: Text(data.User_Wise_Complete_Trips,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                        child: VerticalDivider(
                            // indent: 20,
                            // endIndent: 30,
                            // thickness: 3,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 10, 20, 8),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.bloodtype_outlined,
                                    color: Color.fromARGB(255, 211, 24, 24),
                                    size: 18),
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text('Submitted',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(data.User_Wise_Submission,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(234, 189, 206, 198),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 4, 5, 5),
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
                      child: Center(
                          child: Text(DateFormatt,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500))),
                    ),
                  )
                ]),
              ),
              InkWell(
                onTap: () {
                  (data.Completed_Trips != "0")
                      ? submitCompletedTripsfailed()
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PendingTrips()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 9, 13, 3),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: Icon(
                          Icons.directions_bike,
                          color: Color.fromARGB(255, 243, 137, 38),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Pending Trips',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15)),
                      ),
                      const Spacer(),
                      Text(data.Pending_Trips,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Color.fromARGB(255, 216, 214, 214),
                indent: 5,
                endIndent: 5,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompletedTrips()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 13, 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Icon(
                          Icons.verified_user,
                          color: Colors.blue[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Completed Trips',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15)),
                      ),
                      const Spacer(),
                      Text(data.Completed_Trips,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Color.fromARGB(255, 216, 214, 214),
                indent: 5,
                endIndent: 5,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubmittedTrips()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 13, 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Icon(
                          Icons.save_as_sharp,
                          color: Colors.green[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Submitted Trips',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15)),
                      ),
                      const Spacer(),
                      Text(data.Submitted_Trips,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Color.fromARGB(255, 216, 214, 214),
                indent: 5,
                endIndent: 5,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RejectedTrips()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 13, 9),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: Icon(
                          Icons.highlight_remove_outlined,
                          color: Colors.red,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Rejected Trips',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15)),
                      ),
                      const Spacer(),
                      Text(data.Rejected_Trips,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ],
                  ),
                ),
              )
            ],
          )),
    )
  ]));
}

submitCompletedTripsfailed() {
  return Fluttertoast.showToast(
      msg: "Please submit the completed trips",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFFDB291C),
      textColor: Colors.white,
      fontSize: 16.0);
}
