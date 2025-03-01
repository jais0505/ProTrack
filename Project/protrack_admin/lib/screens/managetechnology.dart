import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class TechnologyScreen extends StatefulWidget {
  const TechnologyScreen({super.key});

  @override
  State<TechnologyScreen> createState() => _TechnologyScreenState();
}

class _TechnologyScreenState extends State<TechnologyScreen>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController technologyController = TextEditingController();
  List<Map<String, dynamic>> _technologyList = [];
  int _editId = 0;

  Future<void> insertTechnology() async {
    try {
      String technology = technologyController.text;
      await supabase.from('tbl_technology').insert({
        'technology_name': technology,
      });
      fetchTechnology();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Technology Added',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      print("Inserted");
      technologyController.clear();
    } catch (e) {
      print("ERROR ADDING TECHNOLOGY: $e");
    }
  }

  Future<void> fetchTechnology() async {
    try {
      final response = await supabase.from('tbl_technology').select();
      setState(() {
        _technologyList = response;
      });
    } catch (e) {
      print("ERROR FETCHING TECHNOLOGY DATA: $e");
    }
  }

  Future<void> deletetechnology(int techId) async {
    try {
      await supabase
          .from('tbl_technology')
          .delete()
          .eq('technology_id', techId);
      fetchTechnology();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Technology deleted',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      print("Technology deleted");
    } catch (e) {
      print("ERROR DELETING:$e");
    }
  }

  Future<void> updateTechnology() async {
    try {
      await supabase
          .from('tbl_technology')
          .update({'technology_name': technologyController.text}).eq(
              'technology_id', _editId);
      fetchTechnology();
      technologyController.clear();
      _editId = 0;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Technology Updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      print("Technology updated");
      fetchTechnology();
    } catch (e) {
      print("ERROR UPDATING TECHNOLOGY:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTechnology();
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
              Text('Manage Technology'),
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
                  _isFormVisible ? "Cancel" : "Add Technology",
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
                      height: 250,
                      width: 300,
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
                              "Technology Form",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 30, bottom: 20),
                            child: TextFormField(
                              controller: technologyController,
                              decoration: InputDecoration(
                                hintText: 'Enter technology',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.terminal_outlined),
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
                                  if (_editId != 0) {
                                    updateTechnology();
                                    _isFormVisible = false;
                                  } else {
                                    insertTechnology();
                                    _isFormVisible = false;
                                  }
                                },
                                child: Text(
                                  'Add',
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
            "Technologies",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                dividerThickness: 2,
                dataRowHeight: 50.0,
                headingRowHeight: 60.0,
                columns: [
                  DataColumn(
                      label: Text("Sl.No",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                  DataColumn(
                      label: Text("Technology",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                  DataColumn(
                      label: Text("Edit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                  DataColumn(
                      label: Text("Delete",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                ],
                rows: _technologyList.asMap().entries.map((entry) {
                  print(entry.value);
                  return DataRow(cells: [
                    DataCell(Text(
                      (entry.key + 1).toString(),
                    )),
                    DataCell(Text(entry.value['technology_name'])),
                    DataCell(IconButton(
                        onPressed: () {
                          setState(() {
                            _editId = entry.value['technology_id'];
                            technologyController.text =
                                entry.value['technology_name'];
                            _isFormVisible = true;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ))),
                    DataCell(
                      IconButton(
                        onPressed: () {
                          deletetechnology(entry.value['technology_id']);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
