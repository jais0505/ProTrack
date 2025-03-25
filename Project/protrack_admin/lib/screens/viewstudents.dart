import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Map<String, dynamic>> _studentsList = [];
  Future<void> fetchStudents() async {
    try {
      final response = await supabase.from('tbl_student').select();
      setState(() {
        _studentsList = response;
      });
    } catch (e) {
      print("Error fetching student list:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(
          "Students List",
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
                    label: Text("Studnet Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
                DataColumn(
                    label: Text("Photo",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
                DataColumn(
                    label: Text("Contact No",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
                DataColumn(
                    label: Text("Mail id",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
              ],
              rows: _studentsList.asMap().entries.map((entry) {
                print(entry.value);
                return DataRow(cells: [
                  DataCell(Text(
                    (entry.key + 1).toString(),
                  )),
                  DataCell(Text(entry.value['student_name'])),
                  DataCell(
                    Image.network(
                      entry.value[
                          'student_photo'], // Assuming this is the image URL
                      width: 40, // Adjust width
                      height: 40, // Adjust height
                      fit: BoxFit.cover, // Adjust how the image fits
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person,
                            size: 50,
                            color: Colors.grey); // Default icon if image fails
                      },
                    ),
                  ),
                  DataCell(Text(entry.value['student_contact'])),
                  DataCell(Text(entry.value['student_email'])),
                ]);
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
