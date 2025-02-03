import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // List<Map<String, dynamic>> _studentdataList = [];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();

  String Name = "";
  Future<void> fetchData() async {
    try {
      String? studentid = supabase.auth.currentUser?.id;

      if (studentid != null) {
        final response = await supabase
            .from('tbl_student')
            .select()
            .eq("student_id", studentid)
            .single();
        setState(() {
          Name = response['student_name'];
          _emailController.text = response['student_email'];
          _phonenoController.text = response['student_contact'];
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              width: 500,
              height: 350,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "My Account",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 165),
                          child: Icon(
                            Icons.more_vert,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 40),
                          child: Image.asset(
                            'assets/Profile.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 25),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 124),
                                child: Text(
                                  Name,
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Text(
                                  "BCA S6 | Roll No:26",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
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
                      decoration: InputDecoration(border: OutlineInputBorder()),
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
                    padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
                    child: TextField(
                      controller: _phonenoController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
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
                    padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
                    child: TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
