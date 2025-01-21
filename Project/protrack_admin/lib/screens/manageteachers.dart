import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:protrack_admin/main.dart';

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
  Future<void> register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailEditingController.text,
        password: _passwordEditingController.text,
      );
      if (credential.user!.uid.isNotEmpty) {
        await storeData(credential.user!.uid);
      } else {
        print("Authentication Failed");
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
      await supabase.from('tbl_teacher').insert({
        'teacher_name': name,
        'teacher_email': email,
        'teacher_contact': contact,
        'teacher_password': password,
        'teacher_auth': uid
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Teacher details added",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      print("Teacher details inserted");
    } catch (e) {
      print("Error inserting teacher details:$e");
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
                      width: 500,
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
                                top: 30,
                                bottom: 6,
                              ),
                              child: Text(
                                "Add Teacher form",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 30, bottom: 20),
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
                                  left: 40, right: 40, top: 30, bottom: 20),
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
                                  left: 40, right: 40, top: 30, bottom: 20),
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
                                  left: 40, right: 40, top: 30, bottom: 20),
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
