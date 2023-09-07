import 'dart:convert';

import 'package:flutter/material.dart';

import 'Logistics_Pending_Trips.dart';

import 'globals.dart' as globals;

import 'package:http/http.dart' as http;

var SUB_TRIP_SHIF_ID = "";
var SUB_ROUTE_MAP_ID = "";
var SUB_ROUTE_NAME = "";

class SubmittedTripsDetails extends StatefulWidget {
  SubmittedTripsDetails(SubTripShiftID, SubRouteMapID, SubRouteName) {
    SUB_TRIP_SHIF_ID = "";
    SUB_ROUTE_MAP_ID = "";
    SUB_ROUTE_NAME = "";
    SUB_TRIP_SHIF_ID = SubTripShiftID;
    SUB_ROUTE_MAP_ID = SubRouteMapID;
    SUB_ROUTE_NAME = SubRouteName;
  }

  @override
  State<SubmittedTripsDetails> createState() => _SubmittedTripsDetailsState();
}

class _SubmittedTripsDetailsState extends State<SubmittedTripsDetails> {
  @override
  Widget build(BuildContext context) {
    Future<List<SubmittedTripsModels>> _fetchSubmittedTrips() async {
      var jobsListAPIUrl;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_ROUTE_ID": SUB_ROUTE_MAP_ID,
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_SESSION_ID": "1",
        "IP_FLAG": "SU",
        "IP_TRIP_SHIFT_ID": SUB_TRIP_SHIF_ID,
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
        globals.SubmitteddataLastIndex = jsonDecode(response.body)["Data"];
        return listresponse
            .map((smbtrans) => SubmittedTripsModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget CompletedTripsData = Container(
      child: FutureBuilder<List<SubmittedTripsModels>>(
          future: _fetchSubmittedTrips(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return const NoContent();
              } else {
                return SubmittedTripsDataDetailsList(data, context);
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
          backgroundColor: const Color(0xff123456),
          title: Text(SUB_ROUTE_NAME,
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
            child: CompletedTripsData));
  }
}

class SubmittedTripsModels {
  final Submt_Area_ID;
  final Submt_Area_Name;
  final Submt_Area_Wise_Samples;
  final Submt_Containers;
  final Submt_Start_DT;
  final Submt_Accept_DT;
  final Submt_Reached_DT;
  final Submt_Reject_DT;
  final Submt_Complete_DT;
  final Submt_Longitude;
  final Submt_Latitude;
  final Submt_Trip_Shift_ID;
  final Submt_REmarks;
  final Submt_TRF_NO;
  final Submt_Total_Samples;
  SubmittedTripsModels(
      {required this.Submt_Area_ID,
      required this.Submt_Area_Name,
      required this.Submt_Area_Wise_Samples,
      required this.Submt_Containers,
      required this.Submt_Start_DT,
      required this.Submt_Accept_DT,
      required this.Submt_Reached_DT,
      required this.Submt_Reject_DT,
      required this.Submt_Complete_DT,
      required this.Submt_Longitude,
      required this.Submt_Latitude,
      required this.Submt_Trip_Shift_ID,
      required this.Submt_REmarks,
      required this.Submt_TRF_NO,
      required this.Submt_Total_Samples});
  factory SubmittedTripsModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return SubmittedTripsModels(
        Submt_Area_ID: json["AREA_ID"].toString(),
        Submt_Area_Name: json["AREA_NAME"].toString(),
        Submt_Area_Wise_Samples: json["AREA_WISE_SAMPLES"].toString(),
        Submt_Containers:json["CONTAINERS"].toString(),
        Submt_Start_DT: json["START_DT"].toString(),
        Submt_Accept_DT: json["ACCEPT_DT"].toString(),
        Submt_Reached_DT: json["REACHED_DT"].toString(),
        Submt_Reject_DT: json["REJECT_DT"].toString(),
        Submt_Complete_DT: json["COMPLETED_DT"].toString(),
        Submt_Longitude: json["LONGITUDE"].toString(),
        Submt_Latitude: json["LATTITUDE"].toString(),
        Submt_Trip_Shift_ID: json["TRIP_SHIFT_ID"].toString(),
        Submt_REmarks: json["REMARKS"].toString(),
        Submt_TRF_NO: json["TRF_NO"].toString(),
        Submt_Total_Samples: json["TOTAL_SAMPLES"].toString());
  }
}

Widget SubmittedTripsDataDetailsList(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildSubmittedData(data[index], context, index);
      });
}

Widget _buildSubmittedData(data, BuildContext context, int index) {
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
                                  child: Text(data.Submt_Area_Name,
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
                          const Text("Reached : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Submt_Reached_DT,
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
                          Text(data.Submt_Complete_DT,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500))
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != globals.SubmitteddataLastIndex.length - 1)
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
                            data.Submt_Start_DT,
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
                          Text(data.Submt_Area_Wise_Samples,
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
                          Text(data.Submt_Containers,
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
                          Text(data.Submt_REmarks,
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
                          Text(data.Submt_TRF_NO,
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
