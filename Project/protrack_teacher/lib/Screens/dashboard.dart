import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/homepage.dart';
import 'package:protrack_teacher/Screens/managestudents.dart';
import 'package:protrack_teacher/Screens/myaccount.dart';
import 'package:protrack_teacher/Screens/viewprojects.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final List<Widget> items = [
    HomeScreen(),
    Account(),
    ViewProjects(),
    ManagestudentsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF004A61),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.computer_rounded), label: 'Project'),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: 'Manage Student'),
          ]),
    );
  }
}
