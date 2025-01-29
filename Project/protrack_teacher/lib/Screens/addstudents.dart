import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddstudentsScreen extends StatefulWidget {
  const AddstudentsScreen({super.key});

  @override
  State<AddstudentsScreen> createState() => _AddstudentsScreenState();
}

class _AddstudentsScreenState extends State<AddstudentsScreen> {
  final TextEditingController studentnameControllor = TextEditingController();
  final TextEditingController _emailEditingControllor = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  final TextEditingController studentcontactControllor =
      TextEditingController();
  final TextEditingController yearController = TextEditingController();
  List<Map<String, dynamic>> _yearList = [];

  String? selectedYear;

  //Image Picking Function Start
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  //Image Picking Function End

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

  Future<void> register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailEditingControllor.text,
        password: _passwordEditingController.text,
      );
      if (credential.user!.uid.isNotEmpty) {
        String uid = credential.user!.uid;
        await storeData(uid);
      } else {
        print("Error User Authentication");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print("Error auth: $e");
    }
  }

  Future<void> storeData(uid) async {
    try {
      String name = studentnameControllor.text;
      String email = _emailEditingControllor.text;
      String password = _passwordEditingController.text;
      String contact = studentcontactControllor.text;
      String? year = selectedYear;

      await supabase.from('tbl_student').insert({
        'student_name': name,
        'student_email': email,
        'student_password': password,
        'student_contact': contact,
        'year_id': year,
        'student_auth': uid
      });

      final imageUrl = await uploadImage(uid);
      await updateData(uid, imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Student added",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("Error inserting students data:$e");
    }
  }

  Future<void> updateData(final uid, final url) async {
    try {
      await supabase
          .from('tbl_student')
          .update({'student_photo': url}).eq("student_auth", uid);
    } catch (e) {
      print("Image updation failed: $e");
    }
  }

  ///File upload Function
  Future<String?> uploadImage(String uid) async {
    try {
      final fileName = 'user_$uid';

      await supabase.storage.from('student').upload(fileName, _image!);

      // Get public URL of the uploaded image
      final imageUrl = supabase.storage.from('student').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchyear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Add Student Form",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          //Image Upload Section Start
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white38,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt,
                        color: Colors.black, size: 50)
                    : null,
              ),
            ),
          ),
          //Image Upload Section End

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
              controller: _emailEditingControllor,
              decoration: InputDecoration(
                  hintText: 'Enter student email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _passwordEditingController,
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
                  prefixIcon: Icon(Icons.phone)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              value: selectedYear,
              hint: const Text("Select Year"),
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
            padding: const EdgeInsets.only(left: 80, right: 80, top: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF017AFF),
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  print("Click triggered");
                  register();
                },
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
