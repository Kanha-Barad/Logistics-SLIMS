import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Logistics_Completed_Trips.dart';
import 'Logistics_Submitted_Trips.dart';
import 'globals.dart' as globals;

import 'Logistics_Pending_Trips.dart';

DateTime now = DateTime.now();
String CurrentDate = DateFormat('dd-MMM-yyyy').format(now);

class CompletedTrips extends StatefulWidget {
  const CompletedTrips({Key? key}) : super(key: key);

  @override
  State<CompletedTrips> createState() => _CompletedTripsState();
}

class _CompletedTripsState extends State<CompletedTrips> {
  @override
  Widget build(BuildContext context) {
    Future<List<CompletedTripsDataModels>> _fetchCompletedDataTrips() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_FROM_DT": CurrentDate,
        "IP_TO_DT": CurrentDate,
        "IP_FLAG": "C",
        "connection": globals.Logistic_App_Connection_String
        //"Server_Flag":""
      };
      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/StatusWiseTrips');
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
            .map((smbtrans) => CompletedTripsDataModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget LogisticCompletedData = Container(
      /// margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: FutureBuilder<List<CompletedTripsDataModels>>(
          future: _fetchCompletedDataTrips(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return CompletedDetailsList(data, context, "C");
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(
                child: const CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff123456),
          title: Row(
            children: [
              Text('Completed Trips',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              // Spacer(),
              // Text(formattedDate,
              //     style: const TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18))
            ],
          ),
          elevation: 0.0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: LogisticCompletedData));
  }
}

class SubmittedTrips extends StatefulWidget {
  const SubmittedTrips({Key? key}) : super(key: key);

  @override
  State<SubmittedTrips> createState() => _SubmittedTripsState();
}

class _SubmittedTripsState extends State<SubmittedTrips> {
  @override
  Widget build(BuildContext context) {
    Future<List<SubmittedTripsDataModels>> _fetchSubmittedTrips() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_FROM_DT": CurrentDate,
        "IP_TO_DT": CurrentDate,
        "IP_FLAG": "SU",
        "connection": globals.Logistic_App_Connection_String
        //"Server_Flag":""
      };
      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/StatusWiseTrips');
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
            .map((smbtrans) => SubmittedTripsDataModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget LogisticSubmittedData = Container(
      child: FutureBuilder<List<SubmittedTripsDataModels>>(
          future: _fetchSubmittedTrips(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return SubmittedDetailsList(data, context, "SU");
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(
                child: const CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff123456),
          title: Row(
            children: [
              Text('Submitted Trips',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          elevation: 0.0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: LogisticSubmittedData));
  }
}

class RejectedTrips extends StatefulWidget {
  const RejectedTrips({Key? key}) : super(key: key);

  @override
  State<RejectedTrips> createState() => _RejectedTripsState();
}

class _RejectedTripsState extends State<RejectedTrips> {
  @override
  Widget build(BuildContext context) {
    Future<List<RejectedTripsDataModels>> _fetchRejectedTrips() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_FROM_DT": CurrentDate,
        "IP_TO_DT": CurrentDate,
        "IP_FLAG": "RJ",
        "connection": globals.Logistic_App_Connection_String
        //"Server_Flag":""
      };
      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.Global_Logistic_Api_URL + '/Logistics/StatusWiseTrips');
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
            .map((smbtrans) => RejectedTripsDataModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget LogisticRejectedData = Container(
      // margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: FutureBuilder<List<RejectedTripsDataModels>>(
          future: _fetchRejectedTrips(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return RejectedDetailsList(data, context, "RJ");
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(
                child: const CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff123456),
          title: Row(
            children: [
              Text('Rejected Trips',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          elevation: 0.0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: LogisticRejectedData));
  }
}

class CompletedTripsDataModels {
  final Cmp_Trip_Shift_ID;
  final Cmp_USER_ID;
  final Cmp_Shift_From;
  final Cmp_Shift_From_DT;
  final Cmp_Shift_To;
  final Cmp_Shift_To_DT;
  final Cmp_Trip_SCH_DT;
  final Cmp_Route_Map_ID;
  final Cmp_Route_NAme;
  final Cmp_Trip_Reject_DT;
  final Cmp_Total_Samples;
  final Cmp_Locatiom_ID;
  final Cmp_Location_Name;
  final Cmp_Trip_Estimate_Time;
  final Cmp_Trip_Start_Time;
  final Cmp_Trip_Completed_Time;
  CompletedTripsDataModels(
      {required this.Cmp_Trip_Shift_ID,
      required this.Cmp_USER_ID,
      required this.Cmp_Shift_From,
      required this.Cmp_Shift_From_DT,
      required this.Cmp_Shift_To,
      required this.Cmp_Shift_To_DT,
      required this.Cmp_Trip_SCH_DT,
      required this.Cmp_Route_Map_ID,
      required this.Cmp_Route_NAme,
      required this.Cmp_Trip_Reject_DT,
      required this.Cmp_Total_Samples,
      required this.Cmp_Locatiom_ID,
      required this.Cmp_Location_Name,
      required this.Cmp_Trip_Estimate_Time,
      required this.Cmp_Trip_Start_Time,
      required this.Cmp_Trip_Completed_Time});
  factory CompletedTripsDataModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return CompletedTripsDataModels(
      Cmp_Trip_Shift_ID: json["TRIP_SHIFT_ID"].toString(),
      Cmp_USER_ID: json["user_id"].toString(),
      Cmp_Shift_From: json["SHIFT_FROM"].toString(),
      Cmp_Shift_From_DT: json["SHIFT_FROM_DT"].toString(),
      Cmp_Shift_To: json["SHIFT_TO"].toString(),
      Cmp_Shift_To_DT: json["SHIFT_TO_DT"].toString(),
      Cmp_Trip_SCH_DT: json["trip_sch_date"].toString(),
      Cmp_Route_Map_ID: json["ROUTE_MAP_ID"].toString(),
      Cmp_Route_NAme: json["ROUTE_NAME"].toString(),
      Cmp_Trip_Reject_DT: json["TRIP_REJECT_DT"].toString(),
      Cmp_Total_Samples: json["TOTAL"].toString(),
      Cmp_Locatiom_ID: json["LOCATION_ID"].toString(),
      Cmp_Location_Name: json["LOCATION_NAME"].toString(),
      Cmp_Trip_Estimate_Time: json["DURATION"].toString(),
      Cmp_Trip_Start_Time: json["START_DT"].toString(),
      Cmp_Trip_Completed_Time: json["COMPLETED_DT"].toString(),
    );
  }
}

class SubmittedTripsDataModels {
  final Sub_Trip_Shift_ID;
  final Sub_USER_ID;
  final Sub_Shift_From;
  final Sub_Shift_From_DT;
  final Sub_Shift_To;
  final Sub_Shift_To_DT;
  final Sub_Trip_SCH_DT;
  final Sub_Route_Map_ID;
  final Sub_Route_NAme;
  final Sub_Trip_Reject_DT;
  final Sub_Total_Samples;
  final Sub_Submitted_Center;
  final Sub_Received_BY;
  final Sub_Received_Samples;
  final Sub_Trip_Estimate_Time;
  final Sub_Trip_Start_Time;
  final Sub_Trip_Completed_Time;
  SubmittedTripsDataModels(
      {required this.Sub_Trip_Shift_ID,
      required this.Sub_USER_ID,
      required this.Sub_Shift_From,
      required this.Sub_Shift_From_DT,
      required this.Sub_Shift_To,
      required this.Sub_Shift_To_DT,
      required this.Sub_Trip_SCH_DT,
      required this.Sub_Route_Map_ID,
      required this.Sub_Route_NAme,
      required this.Sub_Trip_Reject_DT,
      required this.Sub_Total_Samples,
      required this.Sub_Submitted_Center,
      required this.Sub_Received_BY,
      required this.Sub_Received_Samples,
      required this.Sub_Trip_Estimate_Time,
      required this.Sub_Trip_Start_Time,
      required this.Sub_Trip_Completed_Time});
  factory SubmittedTripsDataModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return SubmittedTripsDataModels(
      Sub_Trip_Shift_ID: json["TRIP_SHIFT_ID"].toString(),
      Sub_USER_ID: json["user_id"].toString(),
      Sub_Shift_From: json["SHIFT_FROM"].toString(),
      Sub_Shift_From_DT: json["SHIFT_FROM_DT"].toString(),
      Sub_Shift_To: json["SHIFT_TO"].toString(),
      Sub_Shift_To_DT: json["SHIFT_TO_DT"].toString(),
      Sub_Trip_SCH_DT: json["trip_sch_date"].toString(),
      Sub_Route_Map_ID: json["ROUTE_MAP_ID"].toString(),
      Sub_Route_NAme: json["ROUTE_NAME"].toString(),
      Sub_Trip_Reject_DT: json["TRIP_REJECT_DT"].toString(),
      Sub_Total_Samples: json["TOTAL"].toString(),
      Sub_Submitted_Center: json["SUBMITTED_CENTER"].toString(),
      Sub_Received_BY: json["EMPLOYEE"].toString(),
      Sub_Received_Samples: json["RECEIVED_SAMPLES"].toString(),
      Sub_Trip_Estimate_Time: json["DURATION"].toString(),
      Sub_Trip_Start_Time: json["START_DT"].toString(),
      Sub_Trip_Completed_Time: json["COMPLETED_DT"].toString(),
    );
  }
}

class RejectedTripsDataModels {
  final Rej_Trip_Shift_ID;
  final Rej_USER_ID;
  final Rej_Shift_From;
  final Rej_Shift_From_DT;
  final Rej_Shift_To;
  final Rej_Shift_To_DT;
  final Rej_Trip_SCH_DT;
  final Rej_Route_Map_ID;
  final Rej_Route_NAme;
  final Rej_Trip_Reject_DT;
  RejectedTripsDataModels(
      {required this.Rej_Trip_Shift_ID,
      required this.Rej_USER_ID,
      required this.Rej_Shift_From,
      required this.Rej_Shift_From_DT,
      required this.Rej_Shift_To,
      required this.Rej_Shift_To_DT,
      required this.Rej_Trip_SCH_DT,
      required this.Rej_Route_Map_ID,
      required this.Rej_Route_NAme,
      required this.Rej_Trip_Reject_DT});
  factory RejectedTripsDataModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return RejectedTripsDataModels(
        Rej_Trip_Shift_ID: json["TRIP_SHIFT_ID"].toString(),
        Rej_USER_ID: json["user_id"].toString(),
        Rej_Shift_From: json["SHIFT_FROM"].toString(),
        Rej_Shift_From_DT: json["SHIFT_FROM_DT"].toString(),
        Rej_Shift_To: json["SHIFT_TO"].toString(),
        Rej_Shift_To_DT: json["SHIFT_TO_DT"].toString(),
        Rej_Trip_SCH_DT: json["trip_sch_date"].toString(),
        Rej_Route_Map_ID: json["ROUTE_MAP_ID"].toString(),
        Rej_Route_NAme: json["ROUTE_NAME"].toString(),
        Rej_Trip_Reject_DT: json["TRIP_REJECT_DT"].toString());
  }
}

Widget CompletedDetailsList(data, BuildContext context, String TripStatus) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildCompletedData(data[index], context, TripStatus);
      });
}

Widget _buildCompletedData(data, BuildContext context, String flg) {
  /*----------------------Completed Trip------------------------*/
  var estimateTimeForCompletetrip = int.parse(data.Cmp_Trip_Estimate_Time);
  var EstimateTimeForCompleteTrip =
      Duration(minutes: (estimateTimeForCompletetrip).toInt());

  DateTime CompletedCompTripTime = DateTime.parse(data.Cmp_Trip_Completed_Time);
  DateTime StartedCompTripTime = DateTime.parse(data.Cmp_Trip_Start_Time);
  final Duration ActualCompleteTripTime =
      StartedCompTripTime.difference(CompletedCompTripTime);

  var head = "";
  var subHead = "";
  var Title = "";

  if (flg == "C") {
    head = data.Cmp_Route_NAme.toString();
    subHead = data.Cmp_Shift_From_DT.toString();
    Title = int.parse(data.Cmp_Total_Samples).toString();
  }

  return (flg == "C")
      ? InkWell(
          onTap: () {
            globals.SubmitTotalSamples = int.parse(data.Cmp_Total_Samples);
            globals.SubmitLocationID = data.Cmp_Locatiom_ID;
            globals.Submit_Location_Name = data.Cmp_Location_Name;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompletedTripsSubmit(
                        data.Cmp_Route_Map_ID,
                        data.Cmp_Trip_Shift_ID,
                        data.Cmp_Route_NAme)));
          },
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
              child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: Color.fromARGB(255, 219, 218, 218))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Container(
                                      decoration: BoxDecoration(
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
                                      Text(head,
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
                                      Text("Start : " + subHead,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 80),
                                        child: SizedBox(
                                          height: 30,
                                          width: 40,
                                          child: Card(
                                            elevation: 3.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            color: Colors.green[400],
                                            child: Center(
                                              child: Text(Title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 0, 2),
                                  child: Row(
                                    children: [
                                      Text(
                                          "To be Submitted : " +
                                              data.Cmp_Location_Name,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 8, 5, 4),
                          child: Row(
                            children: [
                              Text(
                                  "Estimated Time : " +
                                      EstimateTimeForCompleteTrip.toString()
                                          .substring(0, 4) +
                                      " Hrs",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13)),
                              Spacer(),
                              Text(
                                  "Actual Time : " +
                                      ActualCompleteTripTime.toString()
                                          .substring(0, 4) +
                                      " Hrs",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
        )
      : SizedBox();
}

Widget SubmittedDetailsList(data, BuildContext context, String TripStatus) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildSubmittedData(data[index], context, TripStatus);
      });
}

Widget _buildSubmittedData(data, BuildContext context, String flg) {
  /*----------------------Completed Trip------------------------*/
  var estimateTimeForSubmittrip = int.parse(data.Sub_Trip_Estimate_Time);
  var EstimateTimeForSubmitTrip =
      Duration(minutes: (estimateTimeForSubmittrip).toInt());

  DateTime CompletedSubTripTime = DateTime.parse(data.Sub_Trip_Completed_Time);
  DateTime StartedSubTripTime = DateTime.parse(data.Sub_Trip_Start_Time);
  final Duration ActualSubmitTripTime =
      StartedSubTripTime.difference(CompletedSubTripTime);

  // var DelayTimeCompleted = InitialTripTime.toString().substring(0, 4) -
  //     EstimateTimeForTrip.toStringAsFixed(2);

  /*----------------------Submitted Trip------------------------*/

  var head = "";
  var subHead = "";
  var Title = "";

  if (flg == "SU") {
    head = data.Sub_Route_NAme.toString();
    subHead = data.Sub_Shift_From_DT.toString();
    Title = int.parse(data.Sub_Total_Samples).toString();
  }
  return (flg == "SU")
      ? InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubmittedTripsDetails(
                        data.Sub_Trip_Shift_ID,
                        data.Sub_Route_Map_ID,
                        data.Sub_Route_NAme)));
          },
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
              child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: Color.fromARGB(255, 219, 218, 218))),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Container(
                                    decoration: BoxDecoration(
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
                                    Text(head,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 1, 0, 2),
                                child: Row(
                                  children: [
                                    Text("Start : " + subHead,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80),
                                      child: SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: Card(
                                          elevation: 3.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          color: Colors.green[400],
                                          child: Center(
                                            child: Text(Title,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                                child: Row(
                                  children: [
                                    Text(
                                        "Submitted Location : " +
                                            data.Sub_Submitted_Center,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                                child: Row(
                                  children: [
                                    Text(
                                        "Received By : " + data.Sub_Received_BY,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                                child: Row(
                                  children: [
                                    Text(
                                        "Received Samples : " +
                                            data.Sub_Received_Samples,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
                      child: Row(
                        children: [
                          Text(
                              "Estimated Time : " +
                                  EstimateTimeForSubmitTrip.toString()
                                      .substring(0, 4) +
                                  " Hrs",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                          Spacer(),
                          Text(
                              "Actual Time : " +
                                  ActualSubmitTripTime.toString()
                                      .substring(0, 4) +
                                  " Hrs",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(5, 8, 5, 4),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //           "Delayed Time : " +
                    //               EstimateTimeForTrip.toStringAsFixed(2) +
                    //               " Hrs",
                    //           style: const TextStyle(
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.w500,
                    //               fontSize: 13)),
                    //     ],
                    //   ),
                    // )
                  ]))),
        )
      : SizedBox();
}

Widget RejectedDetailsList(data, BuildContext context, String TripStatus) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildRejectedData(data[index], context, TripStatus);
      });
}

Widget _buildRejectedData(data, BuildContext context, String flg) {
  var head = "";
  var subHead = "";
  var Title = "";
  if (flg == "RJ") {
    head = data.Rej_Route_NAme.toString();
    subHead = data.Rej_Shift_From_DT.toString();
    Title = data.Rej_Trip_Reject_DT.toString();
  }
  return (flg == "RJ")
      ? Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 1),
          child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color.fromARGB(255, 219, 218, 218))),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Container(
                                decoration: BoxDecoration(
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 2),
                            child: Row(
                              children: [
                                Text(head,
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
                                Text("Start : " + subHead,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                            child: Row(
                              children: [
                                Text("Reject : " + Title,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ])))
      : SizedBox();
}
