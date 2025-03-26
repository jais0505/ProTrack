import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/studentpage.dart';
import 'package:protrack_teacher/main.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({super.key});

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Students List",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
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
                        builder: (context) => StudentPage(student: students),
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
    );
  }
}
