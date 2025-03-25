import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/addstudents.dart';
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
    String? tid = supabase.auth.currentUser?.id;

    try {
      final response =
          await supabase.from('tbl_student').select().eq('teacher_id', tid!);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 50),
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
                          builder: (context) =>
                              StudentProfile(student: students),
                        ));
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(students['student_photo'] ?? ""),
                  ),
                  title: Text(students['student_name']),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddstudentsScreen()));
        },
        backgroundColor: Color(0xFF004A61),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
