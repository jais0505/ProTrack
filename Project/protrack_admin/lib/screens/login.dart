import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';
import 'package:protrack_admin/screens/dashboard.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cherry_toast/cherry_toast.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool passkey = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> signIn() async {
    try {
      await supabase.auth.signInWithPassword(
          password: _passwordController.text, email: _emailController.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHome(),
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
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/Logo1.png',
                      width: 40,
                      height: 40,
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
                width: 310,
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
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 22, right: 22),
                        child: TextFormField(
                          controller: _emailController,
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
                          controller: _passwordController,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 12),
                              hintStyle: TextStyle(fontSize: 11),
                              hintText: 'Enter your password',
                              border: UnderlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outline),
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
        )),
      ),
    );
  }
}
