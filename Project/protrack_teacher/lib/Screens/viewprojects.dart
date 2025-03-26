import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/mainproject.dart';
import 'package:protrack_teacher/Screens/miniproject.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:protrack_teacher/main.dart'; // Ensure Supabase instance is imported

class ViewProjects extends StatefulWidget {
  const ViewProjects({super.key});

  @override
  State<ViewProjects> createState() => _ViewProjectsState();
}

class _ViewProjectsState extends State<ViewProjects> {
  late ProjectDataSource projectDataSource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    projectDataSource = ProjectDataSource();
    fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    try {
      final response = await supabase.from('tbl_project').select();

      if (response.isNotEmpty) {
        projectDataSource.updateProjectList(response);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("ERROR FETCHING PROJECT DATA: $e");
    }
  }

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
            builder: (context) => Miniproject(pid: id),
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
        appBar: AppBar(title: Text("View Projects")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        checkProject();
                      },
                      child: Container(
                        width: 500,
                        height: 120,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 12, 47, 68),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 85, right: 85, top: 40, bottom: 40),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Mini Project",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Icon(
                                    Icons.computer,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mainproject()));
                      },
                      child: Container(
                        width: 500,
                        height: 120,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 12, 47, 68),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 82, right: 82, top: 40, bottom: 40),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Main Project",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Icon(
                                    Icons.computer,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}

class ProjectDataSource extends DataGridSource {
  List<DataGridRow> _projectRows = [];

  ProjectDataSource();

  void updateProjectList(List<Map<String, dynamic>> projects) {
    _projectRows = projects.map<DataGridRow>((project) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: project['id']),
        DataGridCell<String>(
            columnName: 'Project type', value: project['project_type']),
        DataGridCell<String>(
            columnName: 'Starting date', value: project['project_date']),
        DataGridCell<String>(
            columnName: 'Review1', value: project['project_review1']),
        DataGridCell<String>(
            columnName: 'Review2', value: project['project_review2']),
        DataGridCell<String>(
            columnName: 'Review3', value: project['project_review3']),
      ]);
    }).toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _projectRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child:
              Text(dataCell.value.toString(), style: TextStyle(fontSize: 16)),
        );
      }).toList(),
    );
  }
}
