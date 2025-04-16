import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/mainreport.dart';
import 'package:protrack_teacher/Screens/viewstudents.dart';
import 'package:protrack_teacher/main.dart';

class Mainproject extends StatefulWidget {
  const Mainproject({super.key});

  @override
  State<Mainproject> createState() => _MainprojectState();
}

class _MainprojectState extends State<Mainproject> {
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<Map<String, dynamic>> _studentList = [];

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

  fetchStudetsData() async {
    String? tid = supabase.auth.currentUser?.id;
    try {
      final response =
          await supabase.from('tbl_student').select().eq('teacher_id', tid!);
      setState(() {
        _studentList = response;
      });
    } catch (e) {
      print("ERROR FETECHING STUDENT DATA:$e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjectData();
    fetchStudetsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Main Project",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        elevation: 2,
      ),
      body: isLoading
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.event_note,
                                  color: Colors.blue, size: 28),
                              SizedBox(width: 10),
                              Text(
                                "Important Dates",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1.2),
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: "Starting Date",
                            value: data['project_date'] ?? '-',
                          ),
                          _InfoRow(
                            icon: Icons.looks_one,
                            label: "Review 1",
                            value: data['project_review1'] ?? '-',
                          ),
                          _InfoRow(
                            icon: Icons.looks_two,
                            label: "Review 2",
                            value: data['project_review2'] ?? '-',
                          ),
                          _InfoRow(
                            icon: Icons.looks_3,
                            label: "Review 3",
                            value: data['project_review3'] ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.group,
                        label: "View Students",
                        color: const Color(0xFF017AFF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewStudents()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _ActionButton(
                        icon: Icons.bar_chart,
                        label: "View Report",
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainReprotPage(id: data['project_id']),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Students Assigned",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _studentList.isEmpty
                              ? const Text(
                                  "No students assigned yet.",
                                  style: TextStyle(color: Colors.grey),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _studentList.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, idx) {
                                    final student = _studentList[idx];
                                    return ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Color(0xFF017AFF),
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                      title: Text(
                                        student['student_name'] ?? 'Unnamed',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        student['student_email'] ?? '',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.hourglass_empty_rounded,
                      size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "Main project is not started",
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 10),
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
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
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
      ),
      icon: Icon(icon, color: Colors.white, size: 22),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      onPressed: onTap,
    );
  }
}
