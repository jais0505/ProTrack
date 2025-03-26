import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/mainabstractform.dart';
import 'package:protrack_student/screens/viewmainabstract.dart';

class MainProjectScreen extends StatefulWidget {
  const MainProjectScreen({super.key});

  @override
  State<MainProjectScreen> createState() => _MainProjectScreenState();
}

class _MainProjectScreenState extends State<MainProjectScreen> {
  bool isLoading = false;
  Map<String, dynamic> data = {};
  int? status;
  String projectTitle = "";
  String projectCenter = "";
  String technology = "";
  String guide = "";

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

  Future<void> fetchDetails() async {
    try {
      String? sid = supabase.auth.currentUser?.id;

      final response = await supabase
          .from('tbl_mainproject')
          .select(" *, tbl_technology(*)")
          .eq('student_id', sid!)
          .single();

      final response2 = await supabase
          .from('tbl_student')
          .select(" *, tbl_teacher(*)")
          .eq('student_id', sid)
          .single();

      if (response.isNotEmpty) {
        setState(() {
          status = response['mainproject_status'];
          projectTitle = response['mainproject_title'];
          projectCenter = response['mainproject_center'];
          technology = response['tbl_technology']['technology_name'];
          guide = response2['tbl_teacher']['teacher_name'];
        });
        print("Status:$status");
        print("Techonolgy:$technology");
      }
    } catch (e) {
      print("Error fetching project details: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProjectData();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Main Project",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        ),
        body: isLoading
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "📌 Important Dates",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                    status == ""
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 85, right: 90, bottom: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF017AFF),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainAbstract()));
                                },
                                child: Row(
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Start Project',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.start_rounded,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          )
                        : SizedBox(),
                    status != ""
                        ? Container(
                            padding:
                                const EdgeInsets.all(16.0), // Inner spacing
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 8.0), // Outer spacing
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
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
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Project title: ${projectTitle}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 12, 47,
                                          68), // Slightly softer black
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
                                    "Project guide: ${guide}",
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
                                      left: 50, right: 50, bottom: 10, top: 20),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF017AFF),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewMainAbstract()));
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
                                                  'View Abstract',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
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
