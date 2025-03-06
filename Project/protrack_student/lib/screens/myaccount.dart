import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/login.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // List<Map<String, dynamic>> _studentdataList = [];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String photo = "";
  String Name = "";

  Future<void> fetchData() async {
    try {
      String? studentid = supabase.auth.currentUser?.id;

      if (studentid != null) {
        final response = await supabase
            .from('tbl_student')
            .select(" *,tbl_year(*)")
            .eq("student_id", studentid)
            .single();
        print("Response:$response");
        setState(() {
          Name = response['student_name'];
          photo = response['student_photo'];
          _emailController.text = response['student_email'];
          _phonenoController.text = response['student_contact'];
          _yearController.text = response['tbl_year']['year_name'];
        });
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error Fetching data:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 10, right: 10, bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                          child: Image.network(
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                              photo)),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        Name,
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 200, top: 16, left: 16),
                      child: Text(
                        "Email",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 16, right: 16),
                      child: TextField(
                        controller: _emailController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 200, top: 16, left: 16),
                      child: Text(
                        "Phone No",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 16, right: 16),
                      child: TextField(
                        controller: _phonenoController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 200, top: 16, left: 16),
                      child: Text(
                        "Year of study",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 16, right: 16),
                      child: TextField(
                        controller: _yearController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: ElevatedButton.icon(
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 132, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
