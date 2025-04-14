import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';

class MiniReprotPage extends StatefulWidget {
  final int id;
  const MiniReprotPage({super.key, required this.id});

  @override
  State<MiniReprotPage> createState() => _MiniReprotPageState();
}

class _MiniReprotPageState extends State<MiniReprotPage> {
  List<Map<String, dynamic>> _miniList = [];

  Future<void> fetchMiniDetails() async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select(
              '*, tbl_group(*, tbl_review(*), tbl_groupmember(tbl_student(student_name, teacher_id)))')
          .eq('project_id', widget.id);

      print("Response:$response");

      List<Map<String, dynamic>> dataList = [];

      // Assuming loggedInTeacherId is the teacher_id of the logged-in teacher
      String loggedInTeacherId = supabase.auth.currentUser!.id;

      for (var project in response) {
        for (var group in project['tbl_group']) {
          // Extracting group members
          List members = group['tbl_groupmember'];

          // Check if any member in the group is assigned to the logged-in teacher
          bool hasTeacherStudent = members.any((member) =>
              member['tbl_student']['teacher_id'] == loggedInTeacherId);

          // Only process the group if it has at least one student assigned to the logged-in teacher
          if (hasTeacherStudent) {
            // Extracting student names
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
              'member1': member1,
              'member2': member2,
              'project_title': group['project_title'] ?? 'N/A',
              'guide': group['group_center'] ?? 'N/A',
              'r1': r1,
              'r2': r2,
              'r3': r3,
              'status': group['group_status'] ?? 0,
            });
          }
        }
      }

      setState(() {
        _miniList = dataList;
      });
    } catch (e) {
      print("Error fetching mini project details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMiniDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Mini Project Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        elevation: 0,
      ),
      body: _miniList.isEmpty
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
              itemCount: _miniList.length,
              itemBuilder: (context, index) {
                final item = _miniList[index];
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
                        // Project Title
                        Row(
                          children: [
                            const Icon(
                              Icons.book_rounded,
                              color: Color.fromARGB(255, 12, 47, 68),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['project_title'] == 'N/A'
                                    ? 'Untitled Project'
                                    : item['project_title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 47, 68),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Members
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'Member 1',
                          value: item['member1'],
                        ),
                        if (item['member2'] != 'N/A')
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: 'Member 2',
                            value: item['member2'],
                          ),
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

  // Helper method for info rows (e.g., Member, Guide)
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
