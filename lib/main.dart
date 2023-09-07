import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Logistics_DashBoard.dart';
import 'logistics_login.dart';
import 'globals.dart' as globals;

late SharedPreferences logindata;

void main() {
  runApp(LogisticsApp());
}

class LogisticsApp extends StatefulWidget {
  const LogisticsApp({super.key});

  @override
  State<LogisticsApp> createState() => _LogisticsAppState();
}

class _LogisticsAppState extends State<LogisticsApp> {
  Future<bool> setUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('UserID') != "" && prefs.getString('UserID') != null) {
      globals.Logistic_global_User_Id = (prefs.getString('UserID') ?? '');

      globals.Login_User_Name = (prefs.getString('EMpNaME') ?? '');
      globals.Global_Logistic_Api_URL = (prefs.getString('APIuRL') ?? '');
      globals.Logistic_App_Connection_String =
          (prefs.getString('ConnecTIOnSTrinG') ?? '');
      globals.All_Client_Logo = (prefs.getString('CompaNYLoGo') ?? '');
    }
    setState(() {});
    return true;
  }

  void initState() {
    setUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.black,
              background: Colors.grey,
              secondary: Colors.black,
            ),
      ),
      home: globals.Logistic_global_User_Id != null &&
              globals.Logistic_global_User_Id != ""
          ? LogisticDashboard()
          : LogisticsLogin(),
    );
  }
}
