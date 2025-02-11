import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/student_profile.dart';
import 'package:protrack_teacher/main.dart';

class ManagestudentsScreen extends StatefulWidget {
  const ManagestudentsScreen({super.key});

  @override
  State<ManagestudentsScreen> createState() => _ManagestudentsScreenState();
}

class _ManagestudentsScreenState extends State<ManagestudentsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _studentList = [];

  fetchStudetsData() async {
    try {
      final response = await supabase.from('tbl_student').select();
      setState(() {
        _studentList = response;
      });
    } catch (e) {
      print("ERROR FETECHING STUDENT DATA:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudetsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Manage Students",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _studentList.length,
            itemBuilder: (context, index) {
              final students = _studentList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentProfile(student: students),
                      ));
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(students['student_photo']),
                ),
                title: Text(students['student_name']),
              );
            },
          )
        ],
      ),
    );
  }
}
