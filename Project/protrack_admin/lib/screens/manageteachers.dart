import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:protrack_admin/main.dart';
import 'package:file_picker/file_picker.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;

  final Duration _animationDuration = const Duration(milliseconds: 300);

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  PlatformFile? pickedImage;

  // Handle File Upload Process
  Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Only single file upload
    );
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
      });
    }
  }

  Future<void> register() async {
    try {
      final auth = await supabase.auth.signUp(
          password: _passwordEditingController.text,
          email: _emailEditingController.text);
      final uid = auth.user!.id;
      if (uid.isNotEmpty || uid != "") {
        storeData(uid);
      }
    } catch (e) {
      print("Authentication Error: $e");
    }
  }

  Future<void> storeData(String uid) async {
    try {
      String name = _nameController.text;
      String email = _emailEditingController.text;
      String password = _passwordEditingController.text;
      String contact = _contactController.text;
      String? url = await photoUpload(uid);

      if (url!.isNotEmpty) {
        await supabase.from('tbl_teacher').insert({
          'teacher_id': uid,
          'teacher_name': name,
          'teacher_email': email,
          'teacher_contact': contact,
          'teacher_password': password,
          'teacher_photo': url,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Teacher details added",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        _nameController.clear();
        _passwordEditingController.clear();
        _emailEditingController.clear();
        _contactController.clear();
      } else {
        print("Teacher profile not given");
      }
    } catch (e) {
      print("Error inserting teacher details:$e");
    }
  }

  Future<String?> photoUpload(String uid) async {
    try {
      final bucketName = 'teacher'; // Replace with your bucket name
      final filePath = "$uid-${pickedImage!.name}";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedImage!.bytes!, // Use file.bytes for Flutter Web
          );
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);
      // await updateImage(uid, publicUrl);
      return publicUrl;
    } catch (e) {
      print("Error photo upload: $e");
      return null;
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
              Text("Manage Teachers"),
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
                  _isFormVisible ? "Cancel" : "Add Teacher",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(_isFormVisible ? Icons.cancel : Icons.add,
                    color: Colors.white),
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
                      width: 400,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 246, 243, 243)
                                  .withOpacity(0.5),
                            )
                          ]),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 6,
                              ),
                              child: Text(
                                "Add Teacher form",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: pickedImage == null
                                  ? GestureDetector(
                                      onTap: handleImagePick,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Color(0xFF0277BD),
                                        size: 50,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: handleImagePick,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: pickedImage!.bytes != null
                                            ? Image.memory(
                                                Uint8List.fromList(pickedImage!
                                                    .bytes!), // For web
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(pickedImage!
                                                    .path!), // For mobile/desktop
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: 'Teacher name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: _emailEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Teacher email',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: _contactController,
                                decoration: InputDecoration(
                                  hintText: 'Teacher contact',
                                  border: OutlineInputBorder(),
                                  prefixIcon:
                                      Icon(Icons.contact_phone_outlined),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: _passwordEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Teacher password',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.password),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 15),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF017AFF),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () {
                                    register();
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
