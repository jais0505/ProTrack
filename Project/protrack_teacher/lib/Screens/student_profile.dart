import 'package:flutter/material.dart';

class StudentProfile extends StatefulWidget {
  final Map<String, dynamic> student;
  const StudentProfile({super.key, required this.student});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                        width: 120,
                        height: 120,
                        widget.student['student_photo'],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.student['student_name'],
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004A61)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
