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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Main Project",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF004A61),
        actions: [
          status >= 5
              ? IconButton(
                  icon: const Icon(Icons.history, color: Colors.white),
                  tooltip: "Review Results",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainReviewResults(
                                  mid: mid!,
                                )));
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : myProjectData.isEmpty
              ? _buildStartProjectCard(context)
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildReviewDeadlineMessage(),
                        // Project Info Card
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: const Color(0xFF004A61),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.engineering,
                                      color: Color(0xFF004A61), size: 36),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        projectTitle,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.computer,
                                              color: Colors.amber, size: 20),
                                          const SizedBox(width: 6),
                                          Text(
                                            technology,
                                            style: const TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.school,
                                              color: Colors.white70, size: 20),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Guide: $guide",
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.white70, size: 20),
                                          const SizedBox(width: 6),
                                          Text(
                                            projectCenter,
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // _StatusBadge(status: status),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Timeline Card
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "📅 Project Timeline",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 12),
                                _TimelineTile(
                                    icon: Icons.flag,
                                    label: "Started",
                                    value: "${data['project_date']}"),
                                _TimelineTile(
                                    icon: Icons.looks_one,
                                    label: "Review 1",
                                    value: "${data['project_review1']}"),
                                _TimelineTile(
                                    icon: Icons.looks_two,
                                    label: "Review 2",
                                    value: "${data['project_review2']}"),
                                _TimelineTile(
                                    icon: Icons.looks_3,
                                    label: "Review 3",
                                    value: "${data['project_review3']}"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Actions Card
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Actions",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 14),
                                if (status >= 1)
                                  _ActionButton(
                                    icon: Icons.remove_red_eye_sharp,
                                    label: "View Abstract",
                                    color: Colors.blue,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewMainAbstract()));
                                    },
                                  ),
                                if (status == 3)
                                  _ActionButton(
                                    icon: Icons.refresh,
                                    label: "Re-submit Abstract",
                                    color: Colors.orange,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResubmitMainAbstract()));
                                    },
                                  ),
                                if (status == 2)
                                  _ActionButton(
                                    icon: Icons.rate_review,
                                    label: "Proceed to Review 1",
                                    color: Colors.green,
                                    onTap: addReview1,
                                  ),
                                if (status == 5)
                                  _ActionButton(
                                    icon: Icons.rate_review,
                                    label: "Proceed to Review 2",
                                    color: Colors.green,
                                    onTap: addReview2,
                                  ),
                                if (status == 7)
                                  _ActionButton(
                                    icon: Icons.rate_review,
                                    label: "Proceed to Review 3",
                                    color: Colors.green,
                                    onTap: addReview3,
                                  ),
                                if (status == 9)
                                  _ActionButton(
                                    icon: Icons.file_upload,
                                    label: "Upload Project Certificate",
                                    color: Colors.purple,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainCertificateUpload()));
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Status Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: getStatusColor(status),
                                  size: 28,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    getStatus(status),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: getStatusColor(status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Helper for start project card
  Widget _buildStartProjectCard(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.rocket_launch,
                  size: 60, color: Color(0xFF017AFF)),
              const SizedBox(height: 18),
              const Text(
                "Start Your Main Project",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004A61)),
              ),
              const SizedBox(height: 12),
              const Text(
                "Kick off your main project by submitting your abstract.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF017AFF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  final result = Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainAbstract(pid: data['project_id'])));
                  if (result == true) {
                    fetchProjectData();
                  }
                },
                icon: const Icon(Icons.start_rounded, color: Colors.white),
                label: const Text(
                  'Start Project',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add this helper function in your _MainProjectScreenState class:
  Widget _buildReviewDeadlineMessage() {
    // Initialize variables
    DateTime? deadline;
    String reviewName = "";

    // Helper function to parse DD/M/YYYY or DD/MM/YYYY format
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) {
        print("Invalid date string: $dateStr");
        return null;
      }
      try {
        // Split the date string (e.g., "16/4/2025" or "16/04/2025")
        final parts = dateStr.split('/');
        if (parts.length != 3) {
          print("Invalid date format: $dateStr");
          return null;
        }
        // Parse day, month, year
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final parsedDate = DateTime(year, month, day);
        print("Parsed date '$dateStr' as: $parsedDate");
        return parsedDate;
      } catch (e) {
        print("Error parsing date '$dateStr': $e");
        return null;
      }
    }

    // Determine the relevant review deadline based on status
    if (status == 2 && data['project_review1'] != null) {
      print("Processing review1 date: ${data['project_review1']}");
      deadline = parseDate(data['project_review1']);
      reviewName = "1st Review";
    } else if (status == 5 && data['project_review2'] != null) {
      print("Processing review2 date: ${data['project_review2']}");
      deadline = parseDate(data['project_review2']);
      reviewName = "2nd Review";
    } else if (status == 7 && data['project_review3'] != null) {
      print("Processing review3 date: ${data['project_review3']}");
      deadline = parseDate(data['project_review3']);
      reviewName = "3rd Review";
    }

    // If no valid deadline is found, return an empty widget
    if (deadline == null) {
      print("No valid deadline found for status: $status");
      return const SizedBox();
    }

    // Calculate days left
    final now = DateTime.now();
    final daysLeft = deadline.difference(now).inDays;

    // Normalize daysLeft to handle same-day deadlines
    final isToday = now.year == deadline.year &&
        now.month == deadline.month &&
        now.day == deadline.day;

    // If the deadline has passed
    if (now.isAfter(deadline) && !isToday) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "You have passed the end date for $reviewName submission!",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    // If the deadline is today or within 5 days
    else if (isToday || (daysLeft >= 0 && daysLeft <= 5)) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            const Icon(Icons.info, color: Colors.orange),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isToday
                    ? "Today is the last day to submit your $reviewName!"
                    : "Only $daysLeft day${daysLeft == 1 ? '' : 's'} left to submit your $reviewName!",
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Return empty widget if no message is needed
    return const SizedBox();
  }
}

// Timeline tile widget
class _TimelineTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _TimelineTile(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF004A61), size: 22),
          const SizedBox(width: 10),
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// Action button widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
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
