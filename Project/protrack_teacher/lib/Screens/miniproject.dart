import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/creategroup.dart';
import 'package:protrack_teacher/Screens/minireport.dart';
import 'package:protrack_teacher/Screens/viewgroups.dart';
import 'package:protrack_teacher/main.dart';

class Miniproject extends StatefulWidget {
  final int pid;
  const Miniproject({super.key, required this.pid});

  @override
  State<Miniproject> createState() => _MiniprojectState();
}

class _MiniprojectState extends State<Miniproject> {
  bool isLoading = true;
  Map<String, dynamic> data = {};
  Future<void> fetchProjectData() async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_type', 'Mini Project')
          .single();
      if (response.isNotEmpty) {
        setState(() {
          data = response;
        });
      }
    } catch (e) {
      print("ERROR FETCHING PROJECT DATA: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProjectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mini Project",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              "Important Dates",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  "Starting Date: ${data['project_date']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  "Review1 Date:${data['project_review1']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  "Review2 Date:${data['project_review2']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  "Review3 Date:${data['project_date']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 22, top: 25),
              child: Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF017AFF),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateGroup(
                                      pid: widget.pid,
                                    )));
                      },
                      child: Text(
                        'Create Group',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                  SizedBox(
                    width: 14,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewgroups(
                                      pid: data['project_id'],
                                    )));
                      },
                      child: Text(
                        'View Groups',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 22, top: 25),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {
                      print(data['project_id']);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MiniReprotPage(
                      //       id: data['project_id'],
                      //     ),
                      //   ),
                      // );
                    },
                    icon: Icon(Icons.summarize_outlined,
                        size: 22, color: Colors.white), // 📄 Report icon
                    label: Text(
                      'View Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
