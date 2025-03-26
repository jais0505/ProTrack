import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protrack_teacher/main.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  final Map<String, dynamic> student;
  const StudentPage({super.key, required this.student});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool isLoading = true;

  String projectTitle = "";
  String projectCenter = "";
  String technology = "";
  String sid = "";
  String abstractURl = "";
  int status = 0;

  Future<void> fetchProjectDetails() async {
    try {
      sid = widget.student['student_id'];
      print("sid:$sid");
      final response = await supabase
          .from('tbl_mainproject')
          .select(" *, tbl_technology(*)")
          .eq('student_id', sid)
          .single();
      print("Response:$response");
      setState(() {
        projectTitle = response['mainproject_title'];
        projectCenter = response['mainproject_center'];
        technology = response['tbl_technology']['technology_name'];
        abstractURl = response['mainproject_abstract'];
      });
    } catch (e) {
      print("Error fetching project details: $e");
    }
  }

  Future<void> _launchPDF(String abstractUrl) async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(abstractUrl));
      final bytes = response.bodyBytes;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);

      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        print('Error opening PDF: ${result.message}');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProjectDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Student Page",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      width: 130,
                      height: 130,
                      widget.student['student_photo'],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.student['student_name'],
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004A61)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0), // Inner spacing
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0), // Outer spacing
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 12, 47, 68)
                              .withOpacity(0.3), // Subtle shadow
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade300, // Light border
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Main project details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 12, 47, 68), // Slightly softer black
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Project title: ${projectTitle}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 12, 47, 68), // Slightly softer black
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Technology: ${technology}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 12, 47, 68),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Project center: ${projectCenter}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 12, 47, 68),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 70, right: 70, bottom: 10, top: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF017AFF),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () => _launchPDF(abstractURl),
                              child: Row(
                                children: [
                                  Center(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye_sharp,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'View Abstract',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
