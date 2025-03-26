import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/viewstudents.dart';
import 'package:protrack_teacher/main.dart';

class Mainproject extends StatefulWidget {
  const Mainproject({super.key});

  @override
  State<Mainproject> createState() => _MainprojectState();
}

class _MainprojectState extends State<Mainproject> {
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<Map<String, dynamic>> _studentList = [];
  Future<void> fetchProjectData() async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_type', 'Main Project')
          .single();
      if (response.isNotEmpty) {
        setState(() {
          data = response;
          isLoading = true;
        });
      }
    } catch (e) {
      print("ERROR FETCHING PROJECT DATA: $e");
    }
  }

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
    fetchProjectData();
    fetchStudetsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "Main Project",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        ),
        body: isLoading
            ? Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "📌 Important Dates",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          "Starting Date: ${data['project_date']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          "Review1 Date:${data['project_review1']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          "Review2 Date:${data['project_review2']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          "Review3 Date:${data['project_date']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF017AFF),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewStudents()));
                        },
                        child: Text(
                          'View Students',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.hourglass_empty_rounded,
                          size: 32,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Main project is not started",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }
}
