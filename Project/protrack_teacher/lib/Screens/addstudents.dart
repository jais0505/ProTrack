import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:protrack_teacher/services/auth_service.dart';

class AddstudentsScreen extends StatefulWidget {
  const AddstudentsScreen({super.key});

  @override
  State<AddstudentsScreen> createState() => _AddstudentsScreenState();
}

class _AddstudentsScreenState extends State<AddstudentsScreen> {
  final formKey = GlobalKey<FormState>();

  bool passkey = true;
  bool repasskey = true;
  final TextEditingController studentnameControllor = TextEditingController();
  final TextEditingController _emailEditingControllor = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _repassEditingController =
      TextEditingController();

  final TextEditingController studentcontactControllor =
      TextEditingController();
  final TextEditingController yearController = TextEditingController();
  List<Map<String, dynamic>> _yearList = [];

  String? selectedYear;

  final AuthService _authService = AuthService();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print("Image:$_image");
      });
    }
  }

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
      if (_passwordEditingController.text == _repassEditingController.text) {
        final auth = await supabase.auth.signUp(
            password: _passwordEditingController.text,
            email: _emailEditingControllor.text);

        await _authService.relogin();

        final uid = auth.user!.id;
        if (uid.isEmpty || uid != "") {
          storeData(uid);
        }
      } else {
        CherryToast.error(
                description: Text("password and re-entered password mismatch",
                    style: TextStyle(color: Colors.black)),
                animationType: AnimationType.fromRight,
                animationDuration: Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
        print("Password and re-entered password not same");
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
      String teacherId = supabase.auth.currentUser!.id;
      final imageUrl = await uploadImage(uid);
      print("URL IMAGE: $imageUrl");
      print("teacherId:$teacherId");
      await supabase.from('tbl_student').insert({
        'student_name': name,
        'student_email': email,
        'student_password': password,
        'student_contact': contact,
        'year_id': year,
        'student_id': uid,
        'teacher_id': teacherId,
        'student_photo': imageUrl,
      });
      studentnameControllor.clear();
      studentcontactControllor.clear();
      _emailEditingControllor.clear();
      _passwordEditingController.clear();
      _repassEditingController.clear();
      setState(() {
        selectedYear = null;
        _image = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Student added",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      print('Image URL:$imageUrl');
    } catch (e) {
      print("Error inserting students data:$e");
    }
  }

  Future<String?> uploadImage(String uid) async {
    try {
      final fileName =
          'Student-photo-$uid-${DateTime.now().millisecondsSinceEpoch}';

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
          Form(
            key: formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Add Student Form",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: studentnameControllor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter name";
                }
                return null;
              },
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter Email';
                }
                return null;
              },
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter password';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: 'Enter student password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passkey = !passkey;
                      });
                    },
                    icon:
                        Icon(passkey ? Icons.visibility_off : Icons.visibility),
                  )),
              obscureText: passkey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _repassEditingController,
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
                    icon: Icon(
                        repasskey ? Icons.visibility_off : Icons.visibility),
                  )),
              obscureText: repasskey,
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
