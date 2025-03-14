import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:protrack_student/main.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _contactController = TextEditingController();

  String photo = "";
  String teacherid = "";

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        _image = File(pickedfile.path);
      });
    }
  }

  Future<void> fetchStudentData() async {
    try {
      teacherid = supabase.auth.currentUser!.id;
      if (teacherid != null) {
        final response = await supabase
            .from('tbl_student')
            .select()
            .eq('student_id', teacherid)
            .single();
        setState(() {
          photo = response['student_photo'];
          _nameController.text = response['student_name'];
          _contactController.text = response['studnet_contact'];
        });
      } else {
        print("Error");
      }
    } catch (e) {
      print("ERROR FETCHING DATA:$e");
    }
  }

  Future<void> UpdateData() async {
    try {
      await supabase.from('tbl_student').update({
        'studnet_name': _nameController.text,
        'student_contact': _contactController.text
      }).eq('stundet_id', teacherid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile Updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      fetchStudentData();
    } catch (e) {
      print("ERROR UPDATING PROFILE:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 10),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF004A61),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Stack(children: [
                      ClipOval(
                          child: Image.network(
                              width: 130,
                              height: 130,
                              fit: BoxFit.fill,
                              photo)),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 275),
                    child: Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 32, right: 32),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 265),
                    child: Text(
                      "Contact",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 32, right: 32),
                    child: TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF004A61),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15)),
                      onPressed: () {
                        UpdateData();
                      },
                      label: Text(
                        "Submit",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
