import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/dashboard.dart';
import 'package:protrack_teacher/main.dart';
import 'package:protrack_teacher/services/auth_service.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  bool passkey = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> signIn() async {
    try {
      await _authService.storeCredentials(
          _emailController.text, _passwordController.text);
      await supabase.auth.signInWithPassword(
          password: _passwordController.text, email: _emailController.text);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ));
    } catch (e) {
      CherryToast.error(
              description: Text("No user found for that email.",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or Avatar
              CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFF004A61),
                child: Icon(Icons.school, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 18),
              // App Title
              Text(
                "ProTrack Teacher",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004A61),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Welcome back! Please login to continue.",
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 28),
              // Login Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF004A61)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: passkey,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Color(0xFF004A61)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passkey ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFF004A61),
                            ),
                            onPressed: () {
                              setState(() {
                                passkey = !passkey;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004A61),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: signIn,
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
