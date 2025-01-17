import 'package:flutter/material.dart';
import 'package:protrack_admin/components/appbar.dart';
import 'package:protrack_admin/components/sidebar.dart';
import 'package:protrack_admin/screens/managefiletype.dart';
import 'package:protrack_admin/screens/manageproject.dart';
import 'package:protrack_admin/screens/managetechnology.dart';
import 'package:protrack_admin/screens/manageyear.dart';
import 'package:protrack_admin/screens/viewstudents.dart';
import 'package:protrack_admin/screens/manageteachers.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    StudentsScreen(),
    TeacherScreen(),
    YearScreen(),
    TechnologyScreen(),
    FileTypeScreen(),
    ProjectScreen(),
  ];

  void onSidebarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDF0F6),
        body: Row(
          children: [
            Expanded(
                flex: 1, child: SideBar(onItemSelected: onSidebarItemTapped)),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Appbar1(),
                  _pages[_selectedIndex],
                ],
              ),
            )
          ],
        ));
  }
}
