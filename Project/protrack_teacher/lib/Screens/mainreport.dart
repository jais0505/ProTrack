import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';

class MainReprotPage extends StatefulWidget {
  final int id;
  const MainReprotPage({super.key, required this.id});

  @override
  State<MainReprotPage> createState() => _MainReprotPageState();
}

class _MainReprotPageState extends State<MainReprotPage> {
  List<Map<String, dynamic>> _mainList = [];

  Future<void> fetchMainDetails() async {
    try {
      final response = await supabase
          .from('tbl_mainproject')
          .select(
              '*, tbl_review(*), tbl_student(student_name, tbl_teacher(teacher_name))')
          .eq('project_id', widget.id);

      List<Map<String, dynamic>> dataList = [];

      if (response.isNotEmpty) {
        for (var mainProject in response) {
          var studentRaw = mainProject['tbl_student'];
          Map<String, dynamic> student;
          if (studentRaw is List && studentRaw.isNotEmpty) {
            student = Map<String, dynamic>.from(studentRaw[0]);
          } else if (studentRaw is Map) {
            student = Map<String, dynamic>.from(studentRaw);
          } else {
            student = {};
          }

          var reviewsRaw = mainProject['tbl_review'];
          List<dynamic> reviews;
          if (reviewsRaw is List) {
            reviews = reviewsRaw;
          } else if (reviewsRaw is Map) {
            reviews = [reviewsRaw];
          } else {
            reviews = [];
          }

          // Extract review marks (r1, r2, r3)
          int r1 = 0, r2 = 0, r3 = 0;
          for (var review in reviews) {
            if (review['review_type'] == "FIRST") {
              r1 = int.tryParse(review['review_mark']?.toString() ?? "0") ?? 0;
            }
            if (review['review_type'] == "SECOND") {
              r2 = int.tryParse(review['review_mark']?.toString() ?? "0") ?? 0;
            }
            if (review['review_type'] == "THIRD") {
              r3 = int.tryParse(review['review_mark']?.toString() ?? "0") ?? 0;
            }
          }

          dataList.add({
            'student_name': student['student_name'] ?? 'N/A',
            'guide': student['tbl_teacher']?['teacher_name'] ?? 'N/A',
            'r1': r1,
            'r2': r2,
            'r3': r3,
            'status': mainProject['mainproject_status'] ?? 0,
          });
        }
      }

      setState(() {
        _mainList = dataList;
      });
    } catch (e) {
      print("Error fetching main project details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMainDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Main Project Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        elevation: 0,
      ),
      body: _mainList.isEmpty
          ? const Center(
              child: Text(
                "No data available",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _mainList.length,
              itemBuilder: (context, index) {
                final item = _mainList[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 12, 47, 68),
                      width: 0.5,
                    ),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student Name
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'Student',
                          value: item['student_name'],
                        ),
                        // Guide
                        _buildInfoRow(
                          icon: Icons.school,
                          label: 'Guide',
                          value: item['guide'],
                        ),
                        const SizedBox(height: 12),
                        // Reviews
                        _buildReviewRow(
                          label: 'Review 1',
                          mark: item['r1'],
                          color: Colors.blueAccent,
                        ),
                        _buildReviewRow(
                          label: 'Review 2',
                          mark: item['r2'],
                          color: Colors.green,
                        ),
                        _buildReviewRow(
                          label: 'Review 3',
                          mark: item['r3'],
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        // Status
                        Row(
                          children: [
                            Icon(
                              item['status'] == 0
                                  ? Icons.hourglass_empty
                                  : Icons.check_circle,
                              color: item['status'] == 0
                                  ? Colors.redAccent
                                  : Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Status: ${item['status'] == 0 ? 'Pending' : 'Completed'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: item['status'] == 0
                                    ? Colors.redAccent
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Helper method for info rows (e.g., Student, Guide)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for review rows
  Widget _buildReviewRow({
    required String label,
    required int mark,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.star, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            mark.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
