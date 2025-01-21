import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen>
    with SingleTickerProviderStateMixin {
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

  Future<void> insertProjectdetails() async {
    try {
      String type = projecttypeController.text;
      String date = projectdateController.text;
      String review1 = projectreview1Controller.text;
      String review2 = projectreview1Controller.text;
      String review3 = projectreview1Controller.text;
      await supabase.from('tbl_project').insert({
        'project_type': type,
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
      print("Project data inserted");
    } catch (e) {
      print("ERROR INSERTING PROJECT DETAILS:$e");
    }
  }

  Future<void> fetchProjectdata() async {
    try {
      final reponse = await supabase.from('tbl_project').select();
      setState(() {
        _projectdataList = reponse;
      });
    } catch (e) {
      print("ERROR FETCHING PROJECT DATA:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProjectdata();
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
                  _isFormVisible ? "Cancel" : "Manage Project",
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
                                      SizedBox(
                                        width: 5,
                                      ),
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
                                      SizedBox(
                                        width: 5,
                                      ),
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: projectdateController,
                                    decoration: InputDecoration(
                                      hintText: 'Projcet date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: projectreview1Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Review1 date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: projectreview2Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Review2 date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: projectreview3Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Review3 date',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
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
          DataTable(
            columns: [
              DataColumn(label: Text("Sl.NO")),
              DataColumn(label: Text("Project type")),
              DataColumn(label: Text("Project date")),
              DataColumn(label: Text("Review1 date")),
              DataColumn(label: Text("Review2 date")),
              DataColumn(label: Text("Review3 date")),
            ],
            rows: _projectdataList.asMap().entries.map((entry) {
              print(entry.value);
              return DataRow(cells: [
                DataCell(Text((entry.key + 1).toString())),
                DataCell(Text(entry.value['project_type'])),
                DataCell(Text(entry.value['project_date'])),
                DataCell(Text(entry.value['project_review1'])),
                DataCell(Text(entry.value['project_review2'])),
                DataCell(Text(entry.value['project_review3'])),
              ]);
            }).toList(),
          )
        ],
      ),
    );
  }
}
