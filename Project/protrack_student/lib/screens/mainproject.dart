import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/mainabstractform.dart';
import 'package:protrack_student/screens/maincertificateupload.dart';
import 'package:protrack_student/screens/mainreviewpage.dart';
import 'package:protrack_student/screens/mainreviewresult.dart';
import 'package:protrack_student/screens/resubmitmainabstract.dart';
import 'package:protrack_student/screens/viewmainabstract.dart';

class MainProjectScreen extends StatefulWidget {
  const MainProjectScreen({super.key});

  @override
  State<MainProjectScreen> createState() => _MainProjectScreenState();
}

class _MainProjectScreenState extends State<MainProjectScreen> {
  bool isLoading = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> myProjectData = {};
  int status = 0;
  String projectTitle = "";
  String projectCenter = "";
  String technology = "";
  String guide = "";
  int? mid;

  Future<void> fetchProjectData() async {
    try {
      // Ensure user is authenticated
      final String? sid = supabase.auth.currentUser?.id;
      if (sid == null) {
        print("No authenticated user found");
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Fetch project data
      print("Fetching project data for Main Project...");
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_type', 'Main Project')
          .maybeSingle(); // Use maybeSingle instead of single

      setState(() {
        data = response!;
      });

      if (response == null) {
        print("No project found with project_type 'Main Project'");
        setState(() {
          isLoading = false;
        });
        return;
      }

      print("Project data fetched: $response");

      // Fetch main project data
      print(
          "Fetching main project data for student_id: $sid, project_id: ${response['project_id']}...");
      final response2 = await supabase
          .from('tbl_mainproject')
          .select("*, tbl_technology(*)")
          .eq('student_id', sid)
          .eq('project_id', response['project_id'])
          .maybeSingle(); // Use maybeSingle instead of single

      if (response2 == null) {
        print(
            "No main project found for student_id: $sid and project_id: ${response['project_id']}");
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          // Main project details
          status = response2[
              'mainproject_status']; // Avoid ! unless you're sure it's non-null
          projectTitle = response2['mainproject_title'];
          projectCenter = response2['mainproject_center'];
          technology = response2['tbl_technology']?['technology_name'];
          mid = response2['mainproject_id'] as int?;

          // Teacher details

          myProjectData = response2;
        });
      }

      print("Main project data fetched: $response2");

      // Fetch student and teacher data
      print("Fetching student data for student_id: $sid...");
      final response3 = await supabase
          .from('tbl_student')
          .select("*, tbl_teacher(*)")
          .eq('student_id', sid)
          .maybeSingle(); // Use maybeSingle instead of single
      setState(() {
        guide = response3!['tbl_teacher']['teacher_name'];
      });

      if (response3 == null) {
        print("No student found for student_id: $sid");
      }

      print("Student data fetched: $response3");

      // Update state only if all queries succeed

      print("Status: $status");
      print("Technology: $technology");
      print("mid: $mid");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("ERROR FETCHING PROJECT DATA: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> fetchDetails() async {
  //   try {
  //     String? sid = supabase.auth.currentUser?.id;

  //     final response2 = await supabase
  //         .from('tbl_mainproject')
  //         .select(" *, tbl_technology(*)")
  //         .eq('student_id', sid!)
  //         .single();

  //     final response3 = await supabase
  //         .from('tbl_student')
  //         .select(" *, tbl_teacher(*)")
  //         .eq('student_id', sid)
  //         .single();

  //     if (response2.isNotEmpty || response3.isNotEmpty) {
  //       setState(() {
  //         status = response2['mainproject_status'];
  //         projectTitle = response2['mainproject_title'];
  //         projectCenter = response2['mainproject_center'];
  //         technology = response2['tbl_technology']['technology_name'];
  //         guide = response3['tbl_teacher']['teacher_name'];
  //         mid = response2['mainproject_id'];
  //       });
  //       print("Status:$status");
  //       print("Techonolgy:$technology");
  //       print("mid:$mid");
  //     }
  //   } catch (e) {
  //     print("Error fetching project details: $e");
  //   }
  // }

  Future<void> addReview1() async {
    try {
      DateTime date = DateTime.now();
      String formattedDate = "${date.year}-${date.month}-${date.day}";

      final response = await supabase
          .from('tbl_review')
          .insert({
            'review_date': formattedDate,
            'review_type': "FIRST",
            'mainproject_id': mid,
          })
          .select()
          .single();
      int id = response['review_id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainReviewPage(
                    reviewId: id,
                    type: "FIRST",
                  )));
      print("Review details added");
    } catch (e) {
      print("Error inserting review details:$e");
    }
  }

  Future<void> addReview2() async {
    try {
      DateTime date = DateTime.now();
      String formattedDate = "${date.year}-${date.month}-${date.day}";

      final response = await supabase
          .from('tbl_review')
          .insert({
            'review_date': formattedDate,
            'review_type': "SECOND",
            'mainproject_id': mid,
          })
          .select()
          .single();
      int id = response['review_id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainReviewPage(
                    reviewId: id,
                    type: "SECOND",
                  )));
      print("Review details added");
    } catch (e) {
      print("Error inserting review details:$e");
    }
  }

  Future<void> addReview3() async {
    try {
      DateTime date = DateTime.now();
      String formattedDate = "${date.year}-${date.month}-${date.day}";

      final response = await supabase
          .from('tbl_review')
          .insert({
            'review_date': formattedDate,
            'review_type': "THIRD",
            'mainproject_id': mid,
          })
          .select()
          .single();
      int id = response['review_id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainReviewPage(
                    reviewId: id,
                    type: "THIRD",
                  )));
      print("Review details added");
    } catch (e) {
      print("Error inserting review details:$e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Main Project",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 12, 47, 68),
            actions: [
              status >= 5
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton.icon(
                        icon: Icon(Icons.history, color: Colors.white), // Icon
                        label: Text(
                          'Review Results',
                          style: TextStyle(color: Colors.white), // Text style
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainReviewResults(
                                        mid: mid!,
                                      )));
                          print('Review Results button pressed');
                        },
                        style: TextButton.styleFrom(
                          side: BorderSide(
                              color: Colors.white,
                              width: 2), // Border color and thickness
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8)), // Rounded border
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8), // Button padding
                        ),
                      ),
                    )
                  : SizedBox(),
            ]),
        body: !isLoading
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
                            "Started Date: ${data['project_date']}",
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
                            "Review3 Date:${data['project_review3']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    myProjectData.isEmpty
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
                                          builder: (context) => MainAbstract(
                                                pid: data['project_id'],
                                              )));
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
                        : Container(
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
                                status >= 1
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50,
                                            right: 50,
                                            bottom: 10,
                                            top: 20),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF017AFF),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 15),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
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
                                                        Icons
                                                            .remove_red_eye_sharp,
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
                                    : SizedBox(),
                                status == 3
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 23,
                                            right: 23,
                                            bottom: 10,
                                            top: 20),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF017AFF),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 15),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResubmitMainAbstract()));
                                            },
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        size: 24,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'Re-submit Abstract',
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
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                status == 2
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          addReview1();
                                          print("Click triggered");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // Button color
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Proceed to Review 1 ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox(),
                                status == 5
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          addReview2();
                                          print("Click triggered");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // Button color
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Proceed to Review 2 ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox(),
                                status == 7
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          addReview3();
                                          print("Click triggered");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // Button color
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Proceed to Review 3 ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox(),
                                status == 9
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainCertificateUpload()));
                                          print("Click triggered");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // Button color
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize
                                              .min, // Keeps the Row compact
                                          children: [
                                            const Icon(
                                              Icons.add, // Add icon
                                              color: Colors.white, // Icon color
                                              size: 24, // Icon size
                                            ),
                                            const SizedBox(
                                                width:
                                                    8), // Space between icon and text
                                            const Text(
                                              "Upload project certificate",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    status >= 0
                        ? Container(
                            height: 100,
                            width: 360,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: getStatusBGColor(status), // Border color
                                width: 2, // Border width
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                getStatus(status),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: getStatusColor(status),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
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

String getStatus(int st) {
  switch (st) {
    case 0:
      return "Submit your abstract";
    case 1:
      return "Abstract verification pending";
    case 2:
      return "Abstract approved";
    case 3:
      return "Abstarct rejected";
    case 4:
      return "1st review verification pending";
    case 5:
      return "1st review finished";
    case 6:
      return "2st review verification pending";
    case 7:
      return "2st review finished";
    case 8:
      return "3rd review verification pending";
    case 9:
      return "3rd review finished";
    case 10:
      return "Upload certificate";
    case 11:
      return "Project completed";
    default:
      return " ";
  }
}

Color getStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.amber;
    case 2:
      return Colors.green;
    case 3:
      return Colors.red;
    case 4:
      return Colors.amber;
    case 5:
      return Colors.green;
    case 6:
      return Colors.amber;
    case 7:
      return Colors.green;
    case 8:
      return Colors.amber;
    case 9:
      return Colors.green;
    case 10:
      return Colors.blueAccent;
    case 11:
      return Colors.green;
    default:
      return Colors.white;
  }
}

Color getStatusBGColor(int status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.amber;
    case 2:
      return Colors.green;
    case 3:
      return Colors.red;
    case 4:
      return Colors.amber;
    case 5:
      return Colors.green;
    case 6:
      return Colors.amber;
    case 7:
      return Colors.green;
    case 8:
      return Colors.amber;
    case 9:
      return Colors.green;
    case 10:
      return Colors.blueAccent;
    case 11:
      return Colors.green;
    default:
      return Colors.white;
  }
}
