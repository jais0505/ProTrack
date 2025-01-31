import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/addstudents.dart';

class ManagestudentsScreen extends StatefulWidget {
  const ManagestudentsScreen({super.key});

  @override
  State<ManagestudentsScreen> createState() => _ManagestudentsScreenState();
}

class _ManagestudentsScreenState extends State<ManagestudentsScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Manage Students",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10, right: 10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 60)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddstudentsScreen(),
                        ),
                      );
                    },
                    label: Text(
                      "Add Student",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10, right: 5),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 60)),
                    onPressed: () {},
                    label: Text(
                      "View Student",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    icon: Icon(
                      Icons.view_headline_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
