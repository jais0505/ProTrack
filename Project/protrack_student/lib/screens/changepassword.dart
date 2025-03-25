import 'package:flutter/material.dart';
import 'package:protrack_student/components/form_validation.dart';
import 'package:protrack_student/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangepasswordScreen extends StatefulWidget {
  const ChangepasswordScreen({super.key});

  @override
  State<ChangepasswordScreen> createState() => _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  bool oldpasskey = true;
  bool newpasskey = true;
  bool conpasskey = true;

  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _conpasswordController = TextEditingController();
  String oldP = "";

  Future<void> fetchpass() async {
    try {
      String? studentid = supabase.auth.currentUser?.id;
      if (studentid != null) {
        final response = await supabase
            .from('tbl_student')
            .select()
            .eq('student_id', studentid)
            .single();
        setState(() {
          oldP = response['student_password'];
        });
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error fetching data:$e");
    }
  }

  Future<void> updatePassword() async {
    try {
      String? studentid = supabase.auth.currentUser?.id;
      await supabase.auth.updateUser(
        UserAttributes(
          password: _newpasswordController.text,
        ),
      );

      await supabase
          .from('tbl_student')
          .update({'student_password': _newpasswordController.text}).eq(
              'student_id', studentid!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password Updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              "Change Password",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Old Password",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  validator: (value) {
                    if (value != oldP) {
                      return "Old password doesn't match";
                    }
                    if (value!.isEmpty || value == "") {
                      return "Please Enter your old password";
                    }
                    return null;
                  },
                  controller: _oldpasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(oldpasskey
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            oldpasskey = !oldpasskey;
                          });
                        },
                      )),
                  obscureText: oldpasskey,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "New Password",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _newpasswordController,
                  validator: (value) => FormValidation.validatePassword(value),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(newpasskey
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            newpasskey = !newpasskey;
                          });
                        },
                      )),
                  obscureText: newpasskey,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Confirm Password",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _conpasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(conpasskey
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            conpasskey = !conpasskey;
                          });
                        },
                      )),
                  obscureText: conpasskey,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF004A61),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    onPressed: () {
                      updatePassword();
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
    );
  }
}
