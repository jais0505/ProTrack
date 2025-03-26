import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/mainproject.dart';
import 'package:protrack_student/screens/miniproject.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  Future<void> checkProject() async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_status', 0)
          .order('createdAt', ascending: false)
          .limit(1);

      // Check if the response is empty (no rows returned)
      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No project Started")),
        );
      } else {
        // Since limit(1) is used, response will be a list with at most 1 item
        final project = response[0]; // Access the first (and only) row
        int id = project['project_id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Miniproject(id: id),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 12, 47, 68)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 500,
                height: 327,
                decoration:
                    BoxDecoration(color: const Color.fromARGB(255, 12, 47, 68)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 10),
                            child: Text(
                              "My Projects",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/Myproject.png',
                      width: 400,
                      height: 250,
                    )
                  ],
                ),
              ),
              Container(
                width: 500,
                height: 564,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 30),
                        child: Text(
                          "Projects",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 22, right: 22),
                        child: GestureDetector(
                          onTap: () {
                            checkProject();
                          },
                          child: Container(
                            width: 400,
                            height: 150,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 12, 47, 68),
                                borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      "Mini Project",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/Miniproject.jpg',
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 25, left: 22, right: 22),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainProjectScreen()));
                          },
                          child: Container(
                            width: 400,
                            height: 150,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 12, 47, 68),
                                borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      "Main Project",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/Mainproject.jpg',
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
