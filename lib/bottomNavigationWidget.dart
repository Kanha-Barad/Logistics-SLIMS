import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Logistics_DashBoard.dart';
import 'Logistics_Login.dart';
import 'Logistics_Pending_Trips.dart';

class LogisticBottomBar extends StatelessWidget {
  const LogisticBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: const Color(0xff123456),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PendingTrips()),
                );
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text("Home", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogisticDashboard()),
                );
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                    size: 23,
                  ),
                  Text("Dashboard", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                SharedPreferences pref =
                    await SharedPreferences.getInstance();
                await pref.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogisticsLogin()),
                );
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text("Log Out", style: TextStyle(color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
