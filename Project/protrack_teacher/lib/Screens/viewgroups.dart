import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';

class Viewgroups extends StatefulWidget {
  const Viewgroups({super.key});

  @override
  State<Viewgroups> createState() => _ViewgroupsState();
}

class _ViewgroupsState extends State<Viewgroups> {
  List<Map<String, dynamic>> _groupList = [];
  Future<void> fetchgroups() async {
    try {
      final response = await supabase
          .from('tbl_group')
          .select(" *, tbl_groupmember(*, tbl_student(*))");
      print(response);
      setState(() {
        _groupList = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchgroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Project Groups"),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _groupList.length,
            itemBuilder: (context, index) {
              final groups = _groupList[index];
              print(groups);

              String stud1 =
                  groups['tbl_groupmember'][0]['tbl_student']['student_name'];

              String stud2 =
                  groups['tbl_groupmember'][1]['tbl_student']['student_name'];
              return ListTile(
                onTap: () {},
                leading: Text((index + 1).toString()),
                title: Text(groups['project_title'] ?? "Mini Project Group"),
                subtitle: Text(
                  '$stud1,$stud2',
                  style: TextStyle(color: Colors.indigo),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
