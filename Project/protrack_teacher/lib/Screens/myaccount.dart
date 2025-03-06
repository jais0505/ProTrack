import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/changepassword.dart';
import 'package:protrack_teacher/Screens/editprofile.dart';
import 'package:protrack_teacher/Screens/login.dart';
import 'package:protrack_teacher/main.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();

  String name = "";
  String photo = "";

  Future<void> fetchTeacherData() async {
    try {
      String? teacherid = supabase.auth.currentUser?.id;
      print("Teacher ID:$teacherid");
      if (teacherid != null) {
        final response = await supabase
            .from('tbl_teacher')
            .select()
            .eq("teacher_id", teacherid)
            .single();
        setState(() {
          name = response['teacher_name'];
          photo = response['teacher_photo'];
          _emailController.text = response['teacher_email'];
          _phonenoController.text = response['teacher_contact'];
        });
      } else {
        print("Error");
      }
    } catch (e) {
      print("ERROR FETCHING TEACHER DATA:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTeacherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004A61)),
                    ),
                  ),
                  Center(
                    child: ClipOval(
                        child: Image.network(
                            width: 120, height: 120, fit: BoxFit.fill, photo)),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004A61)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF004A61),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Editprofile()));
                      },
                      label: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF004A61),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Changepassword()));
                      },
                      label: Text(
                        "Change Password",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.change_circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 20, color: Color(0xFF004A61)),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    style: TextStyle(color: Color(0xFF004A61)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Contact",
                      style: TextStyle(fontSize: 20, color: Color(0xFF004A61))),
                  SizedBox(height: 5),
                  TextField(
                    controller: _phonenoController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    style: TextStyle(color: Color(0xFF004A61)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    icon: Icon(Icons.logout),
                    label: Text(
                      "Logout",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Logout button color
                      foregroundColor: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
