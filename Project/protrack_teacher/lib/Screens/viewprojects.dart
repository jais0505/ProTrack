import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Projects")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfDataGrid(
                horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
                source: projectDataSource,
                allowFiltering: true,
                rowHeight: 100,
                columns: [
                  GridColumn(
                    columnName: 'id',
                    label: Center(
                        child: Text('ID',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  GridColumn(
                    allowFiltering: true,
                    width: 100,
                    columnName: 'project_type',
                    label: Center(
                        child: Text('Project type',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  GridColumn(
                    width: 100,
                    columnName: 'project_date',
                    label: Center(
                        child: Text('Starting date',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  GridColumn(
                    width: 100,
                    columnName: 'project_review1',
                    label: Center(
                        child: Text('Review1',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  GridColumn(
                    width: 100,
                    columnName: 'project_review2',
                    label: Center(
                        child: Text('Review2',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  GridColumn(
                    width: 100,
                    columnName: 'project_review3',
                    label: Center(
                        child: Text('Review3',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ],
                columnWidthMode: ColumnWidthMode.fill,
              ),
            ),
    );
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
