import 'dart:async';
import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class ReportPage extends StatefulWidget {
  final int id;
  final String type;
  const ReportPage({super.key, required this.id, required this.type});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Map<String, dynamic>> _miniList = [];

  Future<void> fetchProjectDetails() async {
    try {
      print('TYPE: ${widget.type}');
      List<Map<String, dynamic>> dataList = [];

      if (widget.type == "Mini Project") {
        final response = await supabase
            .from('tbl_project')
            .select(
                '*, tbl_group(*, tbl_review(*), tbl_groupmember(tbl_student(student_name,tbl_teacher(teacher_name))))')
            .eq('project_id', widget.id);
        print("Mini Project Response: $response");

        for (var project in response) {
          for (var group in project['tbl_group']) {
            List<String> membersName = [];
            // Extract student names
            List members = group['tbl_groupmember'] ?? [];
            for (var member in members) {
              String studentName = member['tbl_student'] != null
                  ? member['tbl_student']['student_name']?.toString() ?? "N/A"
                  : "N/A";
              membersName.add(studentName);
            }

            print(
                "Student Guide ID: ${members[0]['tbl_student']['tbl_teacher']['teacher_name']}");
            // String member1 = members.isNotEmpty
            //     ? members[0]['tbl_student']['student_name']?.toString() ?? "N/A"
            //     : "N/A";
            // String member2 = members.length > 1
            //     ? members[1]['tbl_student']['student_name']?.toString() ?? "N/A"
            //     : "N/A";

            // Extract review marks
            List reviews = group['tbl_review'] ?? [];
            int r1 = 0, r2 = 0, r3 = 0;

            for (var review in reviews) {
              final mark =
                  int.tryParse(review['review_mark']?.toString() ?? '0') ?? 0;
              if (review['review_type'] == 'FIRST') r1 = mark;
              if (review['review_type'] == 'SECOND') r2 = mark;
              if (review['review_type'] == 'THIRD') r3 = mark;
            }

            dataList.add({
              'members': membersName,
              // 'Member1': member1,
              // 'Member2': member2,
              'project_title': group['project_title']?.toString() ?? 'N/A',
              'guide': members[0]['tbl_student']['tbl_teacher']
                      ['teacher_name'] ??
                  'N/A',
              'r1': r1,
              'r2': r2,
              'r3': r3,
              'status': group['group_status'] ?? 0,
            });
          }
        }
      } else if (widget.type == "Main Project") {
        final response = await supabase
            .from('tbl_project')
            .select(
                '*, tbl_mainproject(*, tbl_student(*,tbl_teacher(teacher_name)), tbl_review(*))')
            .eq('project_id', widget.id)
            .eq('project_type', widget.type);
        print("Main Project Response: $response");

        for (var project in response) {
          for (var mainProject in project['tbl_mainproject']) {
            List<String> membersName = [];
            // Extract student name
            // List members = mainProject['tbl_student'] ?? [];
            // for (var member in members) {
            //   String studentName = member['student_name']?.toString() ?? "N/A";
            //   membersName.add(studentName);
            // }

            String studentName = mainProject['tbl_student'] != null
                ? mainProject['tbl_student']['student_name']?.toString() ??
                    "N/A"
                : "N/A";
            membersName.add(studentName);
            // Extract review marks
            print(
                "Teacher:${mainProject['tbl_student']['tbl_teacher']['teacher_name']}");
            List reviews = mainProject['tbl_review'] ?? [];
            int r1 = 0, r2 = 0, r3 = 0;

            for (var review in reviews) {
              final mark =
                  int.tryParse(review['review_mark']?.toString() ?? '0') ?? 0;
              if (review['review_type'] == 'FIRST') r1 = mark;
              if (review['review_type'] == 'SECOND') r2 = mark;
              if (review['review_type'] == 'THIRD') r3 = mark;
            }

            dataList.add({
              'members': membersName,
              // 'Member1': studentName,
              // 'Member2': "N/A", // Main project typically has one student
              'project_title':
                  mainProject['mainproject_title']?.toString() ?? 'N/A',
              'guide': mainProject['tbl_student']['tbl_teacher']
                      ['teacher_name'] ??
                  'N/A',
              'r1': r1,
              'r2': r2,
              'r3': r3,
              'status': mainProject['status'] ?? 0,
            });
          }
        }
      } else {
        print("Invalid project type: ${widget.type}");
        // Optionally show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid project type: ${widget.type}")),
        );
      }

      setState(() {
        _miniList = dataList;
      });
    } catch (e) {
      print("Error fetching project details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching project details: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjectDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.type} Report"),
        actions: [
          IconButton(
              onPressed: fetchProjectDetails, icon: Icon(Icons.refresh_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              height: 500,
              width: 1100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "${widget.type} Report",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Members')),
                          DataColumn(label: Text('Project Title')),
                          DataColumn(label: Text('Guide')),
                          DataColumn(label: Text('Review 1')),
                          DataColumn(label: Text('Review 2')),
                          DataColumn(label: Text('Review 3')),
                          DataColumn(label: Text('Total (15)')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: _miniList.map((data) {
                          final total = (data['r1'] as int) +
                              (data['r2'] as int) +
                              (data['r3'] as int);
                          return DataRow(cells: [
                            DataCell(
                              Text(
                                data['members']?.join(', ') ?? 'N/A',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            DataCell(Text(
                                data['project_title']?.toString() ?? 'N/A')),
                            DataCell(Text(data['guide']?.toString() ?? 'N/A')),
                            DataCell(Text(data['r1'].toString())),
                            DataCell(Text(data['r2'].toString())),
                            DataCell(Text(data['r3'].toString())),
                            DataCell(Text(total.toString())),
                            DataCell(
                                Text(_getStatusText(data['status'] as int))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return "Submitted";
      case 2:
        return "Accepted";
      case 3:
        return "Rejected";
      case 9:
        return "Completed";
      default:
        return "Not Submitted";
    }
  }
}
