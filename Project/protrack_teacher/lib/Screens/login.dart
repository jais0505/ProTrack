import 'package:flutter/material.dart';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:protrack_teacher/Screens/dashboard.dart';

import 'package:protrack_teacher/main.dart';
import 'package:protrack_teacher/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passkey = true;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> signIn() async {
    try {
      await _authService.storeCredentials(
          _emailEditingController.text, _passwordEditingController.text);
      await supabase.auth.signInWithPassword(
          password: _passwordEditingController.text,
          email: _emailEditingController.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ));
    } catch (e) {
      print("Error occur in login:$e");
      CherryToast.error(
              description: Text("No user found for that email.",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
      print('No user found for that email.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFEDF0F6)),
        child: Form(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/Logo1.png',
                        width: 45,
                        height: 45,
                      ),
                    ),
                    Text(
                      'Pro Track',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22, right: 22),
                          child: TextFormField(
                            controller: _emailEditingController,
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(fontSize: 12),
                                hintStyle: TextStyle(fontSize: 11),
                                hintText: 'Enter your email',
                                border: UnderlineInputBorder(),
                                prefixIcon: Icon(Icons.email)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22, right: 22),
                          child: TextFormField(
                            controller: _passwordEditingController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 12),
                                hintStyle: TextStyle(fontSize: 11),
                                hintText: 'Enter your password',
                                border: UnderlineInputBorder(),
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                  icon: Icon(passkey
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      passkey = !passkey;
                                    });
                                  },
                                )),
                            obscureText: passkey,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 39, top: 10, bottom: 10),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Color(0xFF017AFF), fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF017AFF),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 96, vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              signIn();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
