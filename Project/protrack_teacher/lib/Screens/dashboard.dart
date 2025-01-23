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
            backgroundColor: Colors.blue,
            title: Text("Pro Track"),
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
