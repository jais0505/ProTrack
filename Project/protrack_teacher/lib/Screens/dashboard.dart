import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/managestudents.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Pro Track",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 15, top: 6, bottom: 6),
              child: Image.asset(
                'assets/Logo1.png',
                height: 20,
                width: 20,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Image.asset(
                      'assets/Profile.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 50),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManagestudentsScreen(),
                              ),
                            );
                          },
                          label: Text(
                            "Manage Students",
                            style: TextStyle(color: Colors.white),
                          ))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
