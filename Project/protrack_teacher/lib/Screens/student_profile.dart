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
      body: Text(widget.student['student_name']),
    );
  }
}
