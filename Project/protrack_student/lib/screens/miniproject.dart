import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/abstractform.dart';
import 'package:protrack_student/screens/resubmitabstract.dart';
import 'package:protrack_student/screens/reviewpage.dart';
import 'package:protrack_student/screens/reviewresults.dart';
import 'package:protrack_student/screens/viewabstract.dart';

class Miniproject extends StatefulWidget {
  final int id;
  const Miniproject({super.key, required this.id});

  @override
  State<Miniproject> createState() => _MiniprojectState();
}

class _MiniprojectState extends State<Miniproject> {
  String projectTitle = "";
  String projectCenter = "";
  String groupmember = "";
  String guide = "";
  int status = 0;
  int gid = 0;
  bool isLoading = false;
  bool isProjectCompleted = false;
  Map<String, dynamic> projectData = {};

  Future<void> fetchProject() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch project review dates from tbl_project
      final projectResponse = await supabase
          .from('tbl_project')
          .select(
              'project_date, project_review1, project_review2, project_review3')
          .eq('project_id', widget.id)
          .maybeSingle();

      if (projectResponse == null) {
        print("No project found for project_id: ${widget.id}");
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        projectData = projectResponse;
      });
      print("Project data: $projectData");

      // Fetch group data
      final groupResponse = await supabase
          .from('tbl_groupmember')
          .select('tbl_group(*)')
          .eq('student_id', supabase.auth.currentUser!.id)
          .eq('tbl_group.project_id', widget.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (groupResponse != null) {
        final groupId = groupResponse['tbl_group']['group_id'] as int;
        print("Group ID: $groupId");

        // Fetch group member data
        final memberResponse = await supabase
            .from('tbl_groupmember')
            .select('*, tbl_student(*)')
            .eq('group_id', groupId)
            .neq('student_id', supabase.auth.currentUser!.id)
            .maybeSingle();

        String member = memberResponse?['tbl_student']['student_name'] ?? "N/A";

        // Fetch teacher data
        final teacherResponse = await supabase
            .from('tbl_teacher')
            .select()
            .eq('teacher_id',
                memberResponse?['tbl_student']['teacher_id'] ?? '')
            .maybeSingle();

        String teacher = teacherResponse?['teacher_name'] ?? "N/A";

        setState(() {
          projectTitle =
              groupResponse['tbl_group']['project_title'] ?? "NOT ASSIGNED";
          projectCenter =
              groupResponse['tbl_group']['group_center'] ?? "NOT ASSIGNED";
          guide = teacher;
          groupmember = member;
          status = groupResponse['tbl_group']['group_status'] ?? 0;
          gid = groupId;
          isProjectCompleted = status == 9;
          isLoading = false;
        });
      } else {
        print("No matching group found");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching project: $e");
      setState(() {
        isLoading = false;
      });
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
      await fetchProject();
    } catch (e) {
      print("Error inserting review details: $e");
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
      await fetchProject();
    } catch (e) {
      print("Error inserting review details: $e");
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
      await fetchProject();
    } catch (e) {
      print("Error inserting review details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProject();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: Text(
                "Mini Project",
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
                          icon: Icon(Icons.history, color: Colors.white),
                          label: Text(
                            'Review Results',
                            style: TextStyle(color: Colors.white),
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
                            side: BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
            body: gid == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_off_sharp,
                          size: 35,
                        ),
                        Text(
                          "Group not created",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildMiniReviewDeadlineMessage(),
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
                                    child: Icon(Icons.group,
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
                                            const Icon(Icons.person,
                                                color: Colors.amber, size: 20),
                                            const SizedBox(width: 6),
                                            Text(
                                              "Member: $groupmember",
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
                                                color: Colors.white70,
                                                size: 20),
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
                                                color: Colors.white70,
                                                size: 20),
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
                                      value:
                                          projectData['project_date'] ?? "N/A"),
                                  _TimelineTile(
                                      icon: Icons.looks_one,
                                      label: "Review 1",
                                      value: projectData['project_review1'] ??
                                          "N/A"),
                                  _TimelineTile(
                                      icon: Icons.looks_two,
                                      label: "Review 2",
                                      value: projectData['project_review2'] ??
                                          "N/A"),
                                  _TimelineTile(
                                      icon: Icons.looks_3,
                                      label: "Review 3",
                                      value: projectData['project_review3'] ??
                                          "N/A"),
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
                                  if (status == 0)
                                    _ActionButton(
                                      icon: Icons.add,
                                      label: "Add Abstract",
                                      color: Color(0xFF017AFF),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AbstractForm()));
                                      },
                                    ),
                                  if (status == 1)
                                    _ActionButton(
                                      icon: Icons.remove_red_eye,
                                      label: "View Abstract",
                                      color: Colors.green,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewAbstractPage()));
                                      },
                                    ),
                                  if (status == 3)
                                    _ActionButton(
                                      icon: Icons.refresh,
                                      label: "Re-submit Abstract",
                                      color: Color(0xFF017AFF),
                                      onTap: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResubmittAbstract()));
                                        if (result == true) {
                                          fetchProject();
                                        }
                                      },
                                    ),
                                  if (status == 2)
                                    _ActionButton(
                                      icon: Icons.rate_review,
                                      label: "Proceed to Review 1",
                                      color: Colors.blue,
                                      onTap: addReview1,
                                    ),
                                  if (status == 5)
                                    _ActionButton(
                                      icon: Icons.rate_review,
                                      label: "Proceed to Review 2",
                                      color: Colors.blue,
                                      onTap: addReview2,
                                    ),
                                  if (status == 7)
                                    _ActionButton(
                                      icon: Icons.rate_review,
                                      label: "Proceed to Review 3",
                                      color: Colors.blue,
                                      onTap: addReview3,
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
                          const SizedBox(height: 24),
                          if (status == 9)
                            Text(
                              "Project completed successfully!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                letterSpacing: 1.2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          );
  }

  Widget _buildMiniReviewDeadlineMessage() {
    DateTime? deadline;
    String? rawDeadline;
    String reviewName = "";

    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) {
        print("Invalid date string: $dateStr");
        return null;
      }
      try {
        final parts = dateStr.split('/');
        if (parts.length != 3) {
          print("Invalid date format: $dateStr");
          return null;
        }
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

    if (status == 2 && projectData['project_review1'] != null) {
      rawDeadline = projectData['project_review1'];
      deadline = parseDate(rawDeadline);
      reviewName = "1st Review";
    } else if (status == 5 && projectData['project_review2'] != null) {
      rawDeadline = projectData['project_review2'];
      deadline = parseDate(rawDeadline);
      reviewName = "2nd Review";
    } else if (status == 7 && projectData['project_review3'] != null) {
      rawDeadline = projectData['project_review3'];
      deadline = parseDate(rawDeadline);
      reviewName = "3rd Review";
    }

    if (deadline == null || rawDeadline == null) {
      print("No valid deadline found for status: $status");
      return const SizedBox();
    }

    final now = DateTime.now();
    final daysLeft = deadline.difference(now).inDays;
    final isToday = now.year == deadline.year &&
        now.month == deadline.month &&
        now.day == deadline.day;

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
                "You have passed the end date for $reviewName submission ($rawDeadline)!",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (isToday || (daysLeft >= 0 && daysLeft <= 5)) {
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
                    ? "Today is the last day to submit your $reviewName ($rawDeadline)!"
                    : "Only $daysLeft day${daysLeft == 1 ? '' : 's'} left to submit your $reviewName ($rawDeadline)!",
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

    return const SizedBox();
  }
}

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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

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
      return "Abstract rejected";
    case 4:
      return "1st review verification pending";
    case 5:
      return "1st review finished";
    case 6:
      return "2nd review verification pending";
    case 7:
      return "2nd review finished";
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
