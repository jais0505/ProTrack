import 'package:flutter/material.dart';
import 'package:protrack_student/screens/homepage.dart';
import 'package:protrack_student/screens/myaccount.dart';
import 'package:protrack_student/screens/myprojects.dart';
import 'package:protrack_student/screens/notification.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final List<Widget> items = [
    Homepage(),
    ProjectScreen(),
    NotificationPage(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[_selectedIndex],
      // body: DashBoard(),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 12, 47, 68),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            items[_selectedIndex];
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
    );
  }
}
