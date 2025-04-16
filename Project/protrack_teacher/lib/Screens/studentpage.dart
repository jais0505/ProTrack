import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protrack_teacher/Screens/mainreviewproject.dart';
import 'package:protrack_teacher/main.dart';

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
  String certificateUrl = "";
  int status = 0;
  int? mid;

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
        status = response['mainproject_status'];
        mid = response['mainproject_id'];
        certificateUrl = response["mainproject_certificate"] ?? "";
      });
      print("Status:$status");
    } catch (e) {
      print("Error fetching project details: $e");
    }
  }

  Future<void> updateGroupStatus(int status) async {
    try {
      await supabase
          .from('tbl_mainproject')
          .update({'mainproject_status': status}).eq('student_id', sid);
      fetchProjectDetails();
      if (status == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abstract Accepted Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (status == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abstract rejected Successfully!'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No change in abstract status!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating mainproject status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to update mainproject status. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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

  Future<void> completeProject() async {
    try {
      await supabase
          .from('tbl_mainproject')
          .update({'mainproject_status': 11}).eq('mainproject_id', mid!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Main project completed!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("Error completing project:$e");
    }
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
                          child: Row(
                            children: [
                              Text(
                                "Project title: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                              Text(
                                (projectTitle.isEmpty)
                                    ? "N/A"
                                    : "${projectTitle}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text(
                                "Technology: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                              Text(
                                (technology.isEmpty) ? "N/A" : "${technology}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text(
                                "Project center: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                              Text(
                                (projectCenter.isEmpty)
                                    ? "N/A"
                                    : "${projectCenter}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                            ],
                          ),
                        ),
                        status >= 1
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 70, right: 70, bottom: 10, top: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF017AFF),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
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
                              )
                            : SizedBox(),
                        status == 1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Accept Button
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        updateGroupStatus(2);
                                      },
                                      icon: Icon(Icons.check_circle,
                                          color: Colors.white),
                                      label: Text(
                                        'Accept',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 6,
                                        shadowColor: Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  // Reject Button
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        updateGroupStatus(3);
                                      },
                                      icon: Icon(Icons.cancel,
                                          color: Colors.white),
                                      label: Text(
                                        'Reject',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 6,
                                        shadowColor: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        status == 4
                            ? ElevatedButton.icon(
                                icon: Icon(Icons.remove_red_eye,
                                    color: Colors.white),
                                label: Text(
                                  'Review 1',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainReviewProjectPage(
                                                type: "FIRST",
                                                mid: mid!,
                                              )));
                                },
                              )
                            : SizedBox(),
                        status == 6
                            ? ElevatedButton.icon(
                                icon: Icon(Icons.remove_red_eye,
                                    color: Colors.white),
                                label: Text(
                                  'Review 2',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainReviewProjectPage(
                                                type: "SECOND",
                                                mid: mid!,
                                              )));
                                },
                              )
                            : SizedBox(),
                        status == 8
                            ? ElevatedButton.icon(
                                icon: Icon(Icons.remove_red_eye,
                                    color: Colors.white),
                                label: Text(
                                  'Review 3',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainReviewProjectPage(
                                                type: "THIRD",
                                                mid: mid!,
                                              )));
                                },
                              )
                            : SizedBox(),
                        status >= 10
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 60, right: 60, bottom: 10, top: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF004A61),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onPressed: () {
                                      _launchPDF(certificateUrl);
                                    },
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
                                                'View Certificate',
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
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  status == 10
                      ? OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            completeProject();
                          },
                          label: Text("Mark Project as Complete"),
                          icon: Icon(Icons.check),
                        )
                      : SizedBox(),
                  status == 11
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green
                                .withOpacity(0.1), // Light green background
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.green.shade300, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min, // Keeps the container compact
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (true) ...[
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 28,
                                ),
                                const SizedBox(
                                    width: 8), // Space between icon and text
                              ],
                              Text(
                                "Project Completed",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green
                                      .shade800, // Dark green for contrast
                                  letterSpacing:
                                      1.2, // Slight spacing for elegance
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
