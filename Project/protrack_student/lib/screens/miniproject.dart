import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/abstractform.dart';

class Miniproject extends StatefulWidget {
  const Miniproject({super.key});

  @override
  State<Miniproject> createState() => _MiniprojectState();
}

class _MiniprojectState extends State<Miniproject> {
  String projectTitle = "";
  String groupmember = "";
  String guide = "";
  Future<void> fetchProjectTitle() async {
    try {
      final response = await supabase
          .from('tbl_groupmember')
          .select("*, tbl_group(*)")
          .eq('student_id', supabase.auth.currentUser!.id)
          .single();

      final response3 = await supabase
          .from('tbl_groupmember')
          .select(' *, tbl_student(*)')
          .eq('group_id', response['group_id'])
          .neq('student_id', supabase.auth.currentUser!.id)
          .single();
      String member = response3['tbl_student']['student_name'];
      final responnse2 = await supabase
          .from('tbl_teacher')
          .select()
          .eq('teacher_id', response3['tbl_student']['teacher_id'])
          .single();
      print(responnse2);
      String teacher = responnse2['teacher_name'];
      setState(() {
        projectTitle = response['tbl_group']['project_title'] ?? "NOT ASSIGNED";
        guide = teacher;
        groupmember = member;
      });
    } catch (e) {
      print("Error fetching project title:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProjectTitle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mini Project",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Project title: ${projectTitle}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Group member: ${groupmember}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Project Guide: ${guide}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 180),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF017AFF),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AbstractForm()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 24,
                        color: Colors.white,
                      ),
                      Text(
                        'Add abstract',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
