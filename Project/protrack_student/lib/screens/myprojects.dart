import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Column(
          children: [
            Container(
              width: 500,
              height: 350,
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Text(
                            "My Projects",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
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
                      child: Container(
                        width: 400,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                  "Mini Project",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 22, right: 22),
                      child: Container(
                        width: 400,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                  "Main Project",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
