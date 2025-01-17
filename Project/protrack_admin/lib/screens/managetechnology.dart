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

  Future<void> yearSubmit() async {
    try {
      String technology = technologyController.text;
      await supabase.from('tbl_technology').insert({
        'technology_name': technology,
      });
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

  Future<void> deletetechnology() async {
    try {
      //await supabase.from('tbl_technology').delete().eq('id',noteid[]);
      fetchTechnology();
    } catch (e) {
      print("ERROR DELETING:$e");
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
                                hintText: 'Year',
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
                                  yearSubmit();
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
          Text(
            "Technologies",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text("Sl.No")),
              DataColumn(label: Text("Technology")),
              DataColumn(label: Text("Delete")),
            ],
            rows: _technologyList.asMap().entries.map((entry) {
              print(entry.value);
              return DataRow(cells: [
                DataCell(Text((entry.key + 1).toString())),
                DataCell(Text(entry.value['technology_name'])),
                DataCell(
                  IconButton(
                    onPressed: () {
                      //deletetechnology(tech['id']);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ]);
            }).toList(),
          )
        ],
      ),
    );
  }
}
