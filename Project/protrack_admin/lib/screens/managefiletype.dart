import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class FileTypeScreen extends StatefulWidget {
  const FileTypeScreen({super.key});

  @override
  State<FileTypeScreen> createState() => _FileTypeScreenState();
}

class _FileTypeScreenState extends State<FileTypeScreen>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController filetypeController = TextEditingController();
  List<Map<String, dynamic>> _filetypeList = [];
  int _editId = 0;

  Future<void> insertFiletype() async {
    try {
      String filetype = filetypeController.text;
      await supabase.from('tbl_filetype').insert({
        'filetype_name': filetype,
      });
      fetchFiletype();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'File type added',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      print("Inserted");
      filetypeController.clear();
    } catch (e) {
      print("ERROR ADDING FILE TYPE: $e");
    }
  }

  Future<void> fetchFiletype() async {
    try {
      final response = await supabase.from('tbl_filetype').select();
      setState(() {
        _filetypeList = response;
      });
    } catch (e) {
      print("ERROR FETCHING FILE TYPE DATA: $e");
    }
  }

  Future<void> deleteFiletype(int filetypeId) async {
    try {
      await supabase.from('tbl_filetype').delete().eq('id', filetypeId);
      fetchFiletype();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "File type Deleted",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      print("File type deleted");
    } catch (e) {
      print("ERROR DELETING FILETYPE:$e");
    }
  }

  Future<void> updateFiletype() async {
    try {
      await supabase
          .from('tbl_filetype')
          .update({'filetype_name': filetypeController.text}).eq('id', _editId);
      fetchFiletype();
      filetypeController.clear;
      _editId = 0;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "File type Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      fetchFiletype();
    } catch (e) {
      print("ERROR UPDATING FILETYPE:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFiletype();
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
              Text('Manage File Type'),
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
                  _isFormVisible ? "Cancel" : "Add File Type",
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
                              "File Type Form",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 20, bottom: 20),
                            child: TextFormField(
                              controller: filetypeController,
                              decoration: InputDecoration(
                                hintText: 'File type',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.file_copy_outlined),
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
                                    updateFiletype();
                                    _isFormVisible = false;
                                  } else {
                                    insertFiletype();
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
          Text(
            "File types",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text("Sl.No")),
              DataColumn(label: Text("File type")),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            rows: _filetypeList.asMap().entries.map((entry) {
              print(entry.value);
              return DataRow(cells: [
                DataCell(Text((entry.key + 1).toString())),
                DataCell(Text(entry.value['filetype_name'])),
                DataCell(IconButton(
                    onPressed: () {
                      setState(() {
                        _editId = entry.value['id'];
                        filetypeController.text = entry.value['filetype_name'];
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
                      deleteFiletype(entry.value['id']);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
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
