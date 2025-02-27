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
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ));
                      },
                      child: Container(
                        width: 350,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A61),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Mini Project",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Mainproject()));
                      },
                      child: Container(
                        width: 350,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A61),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Main Project",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
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
