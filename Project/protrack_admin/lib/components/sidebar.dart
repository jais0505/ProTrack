import 'package:flutter/material.dart';
import 'package:protrack_admin/screens/login.dart';

class SideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  const SideBar({super.key, required this.onItemSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final List<String> pages = [
    "View Students",
    "Manage Teachers",
    "Manage Year",
    "Manage Technology",
    "Manage File Type",
    "Manage Project",
  ];
  final List<IconData> icons = [
    Icons.school,
    Icons.person_3_outlined,
    Icons.date_range,
    Icons.terminal,
    Icons.file_copy,
    Icons.computer // Icon for "Profile"
    // Icon for "Manage Faculty"
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
                  padding: const EdgeInsets.only(top: 10, left: 5),
                  shrinkWrap: true,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        widget.onItemSelected(index);
                      },
                      leading: Icon(icons[index], color: Colors.white),
                      title: Text(pages[index],
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    );
                  }),
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
