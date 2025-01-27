import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';

class AddstudentsScreen extends StatefulWidget {
  const AddstudentsScreen({super.key});

  @override
  State<AddstudentsScreen> createState() => _AddstudentsScreenState();
}

class _AddstudentsScreenState extends State<AddstudentsScreen> {
  final TextEditingController studentnameControllor = TextEditingController();
  final TextEditingController studentemailControllor = TextEditingController();
  final TextEditingController studentpasswordControllor =
      TextEditingController();
  final TextEditingController studentcontactControllor =
      TextEditingController();
  final TextEditingController yearController = TextEditingController();
  List<Map<String, dynamic>> _yearList = [];

  String? selectedYear;

  Future<void> fetchyear() async {
    try {
      final reponse = await supabase.from('tbl_year').select();
      setState(() {
        _yearList = reponse;
      });
    } catch (e) {
      print("Error fetching year data:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchyear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Add Student Form",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 120,
            width: 120,
            child: Icon(
              Icons.add_a_photo,
              size: 50,
              color: Color(0xFF0277BD),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: studentnameControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: studentemailControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: studentpasswordControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: studentcontactControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student contact',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              value: selectedYear,
              hint: const Text("Select District"),
              onChanged: (newValue) {
                setState(() {
                  selectedYear = newValue;
                });
              },
              items: _yearList.map((year) {
                return DropdownMenuItem<String>(
                  value: year['year_id'].toString(),
                  child: Text(year['year_name']),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF017AFF),
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {},
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
