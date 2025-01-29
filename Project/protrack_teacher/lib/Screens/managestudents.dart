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
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Manage Students",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF161616),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18)),
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
        ],
      ),
    );
  }
}
