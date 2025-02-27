import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<Map<String, dynamic>> _studentList = [];

  String? selectedStudent1;
  String? selectedStudent2;
  fetchStudetsData() async {
    try {
      final response = await supabase.from('tbl_student').select();
      setState(() {
        _studentList = response;
      });
    } catch (e) {
      print("ERROR FETECHING STUDENT DATA:$e");
    }
  }

  Future<void> storeData() async {
    try {
      String? student1 = selectedStudent1;
      String? student2 = selectedStudent2;
      String groupStatus = " ";
      await supabase.from('tbl_group').insert({'group_status': groupStatus});
      await supabase.from('tbl_groupmember').insert({''});
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudetsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 500,
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "Create Group",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: selectedStudent1,
                    hint: const Text("Select student1"),
                    onChanged: (newValue) {
                      setState(() {
                        selectedStudent1 = newValue;
                      });
                    },
                    items: _studentList.map((year) {
                      return DropdownMenuItem<String>(
                        value: year['student_id'].toString(),
                        child: Text(year['student_name']),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: selectedStudent2,
                    hint: const Text("Select student1"),
                    onChanged: (newValue) {
                      setState(() {
                        selectedStudent2 = newValue;
                      });
                    },
                    items: _studentList.map((year) {
                      return DropdownMenuItem<String>(
                        value: year['student_id'].toString(),
                        child: Text(year['student_name']),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 25),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF017AFF),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        storeData();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
