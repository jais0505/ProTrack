import 'dart:io';
import 'dart:typed_data';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
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
  bool passkey = true;
  bool repasskey = true;
  bool _isFormVisible = false;

  final Duration _animationDuration = const Duration(milliseconds: 300);

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _repasswordEditingController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  List<Map<String, dynamic>> _teacherList = [];

  PlatformFile? pickedImage;

  final _formKey = GlobalKey<FormState>();
  String? _formError;

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Contact validation (10 digits)
  bool _isValidContact(String contact) {
    final contactRegex = RegExp(r'^\d{10}$');
    return contactRegex.hasMatch(contact);
  }

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
    setState(() {
      _formError = null;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (pickedImage == null) {
      setState(() {
        _formError = "Please select a profile photo.";
      });
      return;
    }
    if (_passwordEditingController.text != _repasswordEditingController.text) {
      setState(() {
        _formError = "Passwords do not match.";
      });
      return;
    }
    await _registerTeacher();
  }

  Future<void> _registerTeacher() async {
    try {
      final auth = await supabase.auth.signUp(
          password: _passwordEditingController.text,
          email: _emailEditingController.text);
      final uid = auth.user!.id;
      if (uid.isNotEmpty) {
        await storeData(uid);
        FetchTeachers();
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
        _repasswordEditingController.clear();
        setState(() {
          pickedImage = null;
        });
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

  Future<void> FetchTeachers() async {
    try {
      final response = await supabase.from('tbl_teacher').select();
      setState(() {
        _teacherList = response;
      });
    } catch (e) {
      print("Error fetching teachers list:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchTeachers();
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
                    key: _formKey,
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
                            if (_formError != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  _formError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter teacher name';
                                  }
                                  // Require at least two words (first and last name)
                                  final parts =
                                      value.trim().split(RegExp(r'\s+'));
                                  if (parts.length < 2) {
                                    return 'Please enter full name (first and last name)';
                                  }
                                  // Only allow letters and spaces
                                  if (!RegExp(r'^[a-zA-Z\s]+$')
                                      .hasMatch(value.trim())) {
                                    return 'Name can only contain letters and spaces';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter email';
                                  }
                                  if (!_isValidEmail(value.trim())) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  if (!_isValidContact(value.trim())) {
                                    return 'Enter a valid 10-digit contact number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: _passwordEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Enter teacher password',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passkey = !passkey;
                                      });
                                    },
                                    icon: Icon(passkey
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                obscureText: passkey,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: _repasswordEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Re-enter password',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        repasskey = !repasskey;
                                      });
                                    },
                                    icon: Icon(repasskey
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                obscureText: repasskey,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please re-enter password';
                                  }
                                  if (value !=
                                      _passwordEditingController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
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
          SizedBox(height: 30),
          Text(
            "Teachers List",
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
                      label: Text("Teacher Name",
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
                rows: _teacherList.asMap().entries.map((entry) {
                  print(entry.value);
                  return DataRow(cells: [
                    DataCell(Text(
                      (entry.key + 1).toString(),
                    )),
                    DataCell(Text(entry.value['teacher_name'])),
                    DataCell(
                      Image.network(
                        entry.value[
                            'teacher_photo'], // Assuming this is the image URL
                        width: 40, // Adjust width
                        height: 40, // Adjust height
                        fit: BoxFit.cover, // Adjust how the image fits
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person,
                              size: 50,
                              color:
                                  Colors.grey); // Default icon if image fails
                        },
                      ),
                    ),
                    DataCell(Text(entry.value['teacher_contact'])),
                    DataCell(Text(entry.value['teacher_email'])),
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
