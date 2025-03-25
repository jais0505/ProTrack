import 'package:flutter/material.dart';
import 'package:protrack_admin/screens/login.dart';

class SideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  const SideBar({super.key, required this.onItemSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedIndex = 0; // Track selected index

  final List<String> pages = [
    "View Students",
    "Manage Teachers",
    "Manage Year",
    "Manage Technology",
    "Manage Project",
  ];

  final List<IconData> icons = [
    Icons.school,
    Icons.person_3_outlined,
    Icons.date_range,
    Icons.terminal,
    Icons.computer,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 15, 23, 42),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 30),
                child: Text(
                  'DASHBOARD',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 129, 140, 248)),
                ),
              ),
              ListView.builder(
                padding: const EdgeInsets.only(top: 16, left: 5),
                shrinkWrap: true,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedIndex;
                  return Container(
                    color: isSelected
                        ? const Color.fromARGB(255, 238, 239, 243)
                        : Colors.transparent, // White background when selected
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        widget.onItemSelected(index);
                      },
                      leading: Icon(
                        icons[index],
                        color: isSelected
                            ? Color.fromARGB(255, 15, 23,
                                42) // Dark icon color when selected
                            : Colors.white, // Default white color
                      ),
                      title: Text(
                        pages[index],
                        style: TextStyle(
                          color: isSelected
                              ? Color.fromARGB(255, 15, 23,
                                  42) // Dark text color when selected
                              : Colors.white, // Default white color
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 20),
            child: ListTile(
              leading: Icon(Icons.logout_outlined, color: Colors.white),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
