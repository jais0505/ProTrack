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
  List<Map<String, dynamic>> dataList = [];

  Future<void> fetchProjectDetails() async {
    try {
      print('TYPE: ${widget.type}');
      if (widget.type != null && widget.type == "Mini Project") {
        final response = await supabase
            .from('tbl_project')
            .select(
                '*, tbl_group(*, tbl_review(*), tbl_groupmember(tbl_student(student_name)))')
            .eq('project_id', widget.id);
        print("Response:$response");

        List<Map<String, dynamic>> dataList = [];

        for (var project in response) {
          for (var group in project['tbl_group']) {
            // Extracting student names
            List members = group['tbl_groupmember'];
            String member1 = members.isNotEmpty
                ? members[0]['tbl_student']['student_name']
                : "N/A";
            String member2 = members.length > 1
                ? members[1]['tbl_student']['student_name']
                : "N/A";

            // Extracting review marks
            List reviews = group['tbl_review'];
            int r1 = 0, r2 = 0, r3 = 0;

            for (var review in reviews) {
              final mark = int.tryParse(review['review_mark'].toString()) ?? 0;

              if (review['review_type'] == 'FIRST') r1 = mark;
              if (review['review_type'] == 'SECOND') r2 = mark;
              if (review['review_type'] == 'THIRD') r3 = mark;
            }

            dataList.add({
              'Student': member1,
              'project_title': group['project_title'] ?? 'N/A',
              'guide': group['group_center'] ?? 'N/A',
              'r1': r1,
              'r2': r2,
              'r3': r3,
              'status': group['group_status'] ?? 0,
            });
          }
        }
      } else if (widget.type != null && widget.type == "Main Project") {
        final response = await supabase
            .from('tbl_project')
            .select(
                '*, tbl_mainproject(*, tbl_student(student_name), tbl_review(*))')
            .eq('project_id', widget.id);

        print("Response:$response");
      }

      setState(() {
        _miniList = dataList;
      });
    } catch (e) {
      print("Error fetching project details: $e");
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              height: 500,
              width: 1100,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 246, 243, 243)
                        .withOpacity(0.5),
                  )
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Project Report",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                          DataColumn(label: Text('Member 1')),
                          DataColumn(label: Text('Member 2')),
                          DataColumn(label: Text('Project Title')),
                          DataColumn(label: Text('Guide')),
                          DataColumn(label: Text('Review 1')),
                          DataColumn(label: Text('Review 2')),
                          DataColumn(label: Text('Review 3')),
                          DataColumn(label: Text('Total (15)')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: _miniList.map((data) {
                          final total = data['r1'] + data['r2'] + data['r3'];
                          return DataRow(cells: [
                            DataCell(Text(data['member1'])),
                            DataCell(Text(data['member2'])),
                            DataCell(Text(data['project_title'])),
                            DataCell(Text(data['guide'])),
                            DataCell(Text(data['r1'].toString())),
                            DataCell(Text(data['r2'].toString())),
                            DataCell(Text(data['r3'].toString())),
                            DataCell(Text(total.toString())),
                            DataCell(Text(_getStatusText(data['status']))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            )
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
