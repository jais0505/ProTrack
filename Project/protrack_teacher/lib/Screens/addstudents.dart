import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Add students Form",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: studentnameControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: studentemailControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: studentpasswordControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: studentcontactControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student contact',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
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
