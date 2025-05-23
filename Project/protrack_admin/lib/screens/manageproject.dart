import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';
import 'package:protrack_admin/screens/report.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen>
    with SingleTickerProviderStateMixin {
  int? status;
  bool _isFormVisible = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController projecttypeController = TextEditingController();
  final TextEditingController projectdateController = TextEditingController();
  final TextEditingController projectreview1Controller =
      TextEditingController();
  final TextEditingController projectreview2Controller =
      TextEditingController();
  final TextEditingController projectreview3Controller =
      TextEditingController();

  String? _type = "";

  List<Map<String, dynamic>> _projectdataList = [];

  final _formKey = GlobalKey<FormState>(); // Add form key

  String? _formError; // For custom validation errors

  // Helper to parse dd/MM/yyyy to DateTime
  DateTime? _parseDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  void _showEditDialog(Map<String, dynamic> project) {
    final TextEditingController dateController =
        TextEditingController(text: project['project_date']);
    final TextEditingController r1Controller =
        TextEditingController(text: project['project_review1']);
    final TextEditingController r2Controller =
        TextEditingController(text: project['project_review2']);
    final TextEditingController r3Controller =
        TextEditingController(text: project['project_review3']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Project Dates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDateField("Project Date", dateController, context),
            _buildDateField("Review 1", r1Controller, context),
            _buildDateField("Review 2", r2Controller, context),
            _buildDateField("Review 3", r3Controller, context),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await supabase.from('tbl_project').update({
                'project_date': dateController.text,
                'project_review1': r1Controller.text,
                'project_review2': r2Controller.text,
                'project_review3': r3Controller.text,
              }).eq('project_id', project['project_id']);
              Navigator.pop(context);
              fetchProjectdata(); // Refresh table
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Project updated")),
              );
              fetchProjectdata();
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  Future<void> insertProjectdetails() async {
    try {
      // String type = projecttypeController.text;
      String date = projectdateController.text;
      String review1 = projectreview1Controller.text;
      String review2 = projectreview1Controller.text;
      String review3 = projectreview1Controller.text;
      final resonse =
          await supabase.from('tbl_project').count().eq('project_status', 0);
      if (resonse > 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Project Already Exist")));
      } else {
        await supabase.from('tbl_project').insert({
          'project_type': _type,
          'project_date': date,
          'project_review1': review1,
          'project_review2': review2,
          'project_review3': review3,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Project details added",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
      }

      print("Project data inserted");
      fetchProjectdata();
    } catch (e) {
      print("ERROR INSERTING PROJECT DETAILS:$e");
    }
  }

  Future<void> fetchProjectdata() async {
    try {
      final response = await supabase.from('tbl_project').select();
      setState(() {
        _projectdataList = response;
      });
    } catch (e) {
      print("ERROR FETCHING PROJECT DATA:$e");
    }
  }

  Future<void> updateStatus(int id) async {
    try {
      await supabase
          .from('tbl_project')
          .update({'project_status': 1}).eq("project_id", id);
      fetchProjectdata();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Project finished",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("ERROR UPDATING PROJECT STATUS FINISH:$e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjectdata();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Manage Project"),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF161616),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18)),
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible;
                  });
                },
                label: Text(
                  _isFormVisible ? "Cancel" : "Create Project",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  _isFormVisible ? Icons.cancel : Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          ),
          AnimatedSize(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            child: _isFormVisible
                ? Form(
                    key: _formKey, // Assign form key
                    child: Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 246, 243, 243)
                                  .withOpacity(0.5),
                            )
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 6),
                            child: Text(
                              "Manage Project Form",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 30, bottom: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Project Type",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 5),
                                      Radio(
                                        value: 'Mini Project',
                                        groupValue: _type,
                                        onChanged: (String? e) {
                                          setState(() {
                                            _type = e!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Mini Project',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 5),
                                      Radio(
                                        value: 'Main Project',
                                        groupValue: _type,
                                        onChanged: (String? e) {
                                          setState(() {
                                            _type = e!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Main Project',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  if (_formError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _formError!,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () => _selectDate(
                                        context, projectdateController),
                                    controller: projectdateController,
                                    decoration: InputDecoration(
                                      hintText: 'Projcet date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select project date';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () => _selectDate(
                                        context, projectreview1Controller),
                                    controller: projectreview1Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Review1 date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select review 1 date';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () => _selectDate(
                                        context, projectreview2Controller),
                                    controller: projectreview2Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Review2 date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select review 2 date';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () => _selectDate(
                                        context, projectreview3Controller),
                                    controller: projectreview3Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Review3 date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select review 3 date';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 15),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF017AFF),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 70, vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  setState(() {
                                    _formError = null;
                                  });
                                  // Validate form fields
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  // Validate project type
                                  if (_type == null || _type!.isEmpty) {
                                    setState(() {
                                      _formError =
                                          "Please select a project type";
                                    });
                                    return;
                                  }
                                  // Parse dates
                                  final d0 =
                                      _parseDate(projectdateController.text);
                                  final d1 =
                                      _parseDate(projectreview1Controller.text);
                                  final d2 =
                                      _parseDate(projectreview2Controller.text);
                                  final d3 =
                                      _parseDate(projectreview3Controller.text);

                                  // Check for nulls (shouldn't happen due to validators)
                                  if (d0 == null ||
                                      d1 == null ||
                                      d2 == null ||
                                      d3 == null) {
                                    setState(() {
                                      _formError = "Invalid date format.";
                                    });
                                    return;
                                  }

                                  // Dates must be unique
                                  final dateSet = {d0, d1, d2, d3};
                                  if (dateSet.length != 4) {
                                    setState(() {
                                      _formError =
                                          "All dates must be different.";
                                    });
                                    return;
                                  }

                                  // Review 1 > Project, Review 2 > Review 1, Review 3 > Review 2
                                  if (!(d1.isAfter(d0))) {
                                    setState(() {
                                      _formError =
                                          "Review 1 date must be after project date.";
                                    });
                                    return;
                                  }
                                  if (!(d2.isAfter(d1))) {
                                    setState(() {
                                      _formError =
                                          "Review 2 date must be after review 1 date.";
                                    });
                                    return;
                                  }
                                  if (!(d3.isAfter(d2))) {
                                    setState(() {
                                      _formError =
                                          "Review 3 date must be after review 2 date.";
                                    });
                                    return;
                                  }

                                  insertProjectdetails();
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Project Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text("Sl.NO")),
                DataColumn(label: Text("Project type")),
                DataColumn(label: Text("Project date")),
                DataColumn(label: Text("Review1 date")),
                DataColumn(label: Text("Review2 date")),
                DataColumn(label: Text("Review3 date")),
                DataColumn(label: Text("Report")),
                DataColumn(label: Text("Project status")),
                status == 0
                    ? DataColumn(label: Text("Button"))
                    : DataColumn(label: Text("")),
              ],
              rows: _projectdataList.asMap().entries.map((entry) {
                print("Data: ${entry.value}");
                return DataRow(cells: [
                  DataCell(SizedBox(
                      width: 10,
                      child: Text((entry.key + 1).toString()))), // Adjust width
                  DataCell(SizedBox(
                      width: 80, child: Text(entry.value['project_type']))),
                  DataCell(SizedBox(
                      width: 85, child: Text(entry.value['project_date']))),
                  DataCell(SizedBox(
                      width: 85, child: Text(entry.value['project_review1']))),
                  DataCell(SizedBox(
                      width: 85, child: Text(entry.value['project_review2']))),
                  DataCell(SizedBox(
                      width: 85, child: Text(entry.value['project_review3']))),
                  DataCell(SizedBox(
                    width: 90, // Adjust button width
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportPage(
                                    id: entry.value['project_id'],
                                    type: _projectdataList[entry.key]
                                            ['project_type'] as String? ??
                                        'unknown',
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        elevation: 3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.summarize_outlined,
                              size: 18, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            "Report",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
                  DataCell(
                    entry.value['project_status'] == 0
                        ? Container(
                            width: 100, // Adjust button width
                            child: ElevatedButton(
                              onPressed: () {
                                print("Finish button pressed");
                                updateStatus(entry.value['project_id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Button color
                                foregroundColor: Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                elevation: 3,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check,
                                      size: 18, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    "Finish",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text(
                            "Finished",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight:
                                  FontWeight.bold, // Optional: make it bold
                            ),
                          ),
                  ),
                  status == 0
                      ? DataCell(
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              _showEditDialog(entry.value); // Pass project row
                            },
                          ),
                        )
                      : DataCell(Text("")),
                ]);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildDateField(
    String label, TextEditingController controller, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      readOnly: true,
      controller: controller,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          controller.text = "${picked.day}/${picked.month}/${picked.year}";
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.date_range),
      ),
    ),
  );
}
