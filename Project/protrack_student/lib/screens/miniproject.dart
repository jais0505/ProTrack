import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/abstractform.dart';
import 'package:protrack_student/screens/resubmitabstract.dart';
import 'package:protrack_student/screens/reviewpage.dart';
import 'package:protrack_student/screens/reviewresults.dart';
import 'package:protrack_student/screens/viewabstract.dart';

class Miniproject extends StatefulWidget {
  const Miniproject({super.key});

  @override
  State<Miniproject> createState() => _MiniprojectState();
}

class _MiniprojectState extends State<Miniproject> {
  String projectTitle = "";
  String groupmember = "";
  String guide = "";
  int status = 0;
  int gid = 0;
  Future<void> fetchProject() async {
    try {
      final response = await supabase
          .from('tbl_groupmember')
          .select("*,tbl_group(*)")
          .eq('student_id', supabase.auth.currentUser!.id)
          .single();

      final response3 = await supabase
          .from('tbl_groupmember')
          .select(' *, tbl_student(*)')
          .eq('group_id', response['group_id'])
          .neq('student_id', supabase.auth.currentUser!.id)
          .single();
      String member = response3['tbl_student']['student_name'];
      final response2 = await supabase
          .from('tbl_teacher')
          .select()
          .eq('teacher_id', response3['tbl_student']['teacher_id'])
          .single();
      print("response:$response['tbl_group']");
      String teacher = response2['teacher_name'];
      setState(() {
        projectTitle = response['tbl_group']['project_title'] ?? "NOT ASSIGNED";
        guide = teacher;
        groupmember = member;
        status = response['tbl_group']['group_status'];
        gid = response['tbl_group']['group_id'];
      });
      print("Status:$status");
      print("Gid:$gid");
    } catch (e) {
      print("Error fetching project title:$e");
    }
  }

  Future<void> addReview1() async {
    try {
      DateTime date = DateTime.now();
      String formattedDate = "${date.year}-${date.month}-${date.day}";

      final response = await supabase
          .from('tbl_review')
          .insert({
            'review_date': formattedDate,
            'review_type': "FIRST",
            'group_id': gid,
          })
          .select()
          .single();
      int id = response['review_id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewPage(
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
            'group_id': gid,
          })
          .select()
          .single();
      int id = response['review_id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewPage(
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
            'group_id': gid,
          })
          .select()
          .single();
      int id = response['review_id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewPage(
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
    // TODO: implement initState
    super.initState();
    fetchProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Mini Project",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                              builder: (context) => ReviewResults(
                                    gid: gid,
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
              : SizedBox()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Project title: ${projectTitle}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Group member: ${groupmember}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Project Guide: ${guide}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                status == 0
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF017AFF),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AbstractForm()));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Add abstract',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                      )
                    : SizedBox(),
                status == 3
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF017AFF),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResubmittAbstract()));

                              if (result == true) {
                                fetchProject();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Re-submit abstract',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                      )
                    : SizedBox(),
                status == 1
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewAbstractPage()));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                Text(
                                  'View abstract',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                      )
                    : SizedBox()
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
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
            ),
            SizedBox(
              height: 30,
            ),
            status == 2
                ? ElevatedButton(
                    onPressed: () async {
                      addReview1();
                      print("Click triggered");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      backgroundColor: Colors.blue, // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      backgroundColor: Colors.blue, // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                : SizedBox()
          ],
        ),
      ),
    );
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
        return "Re-submit after updation";
      default:
        return "Something went wrong";
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
      default:
        return Colors.grey;
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
      default:
        return Colors.grey;
    }
  }
}
