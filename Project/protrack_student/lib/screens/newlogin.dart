import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/dashboard.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
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
            builder: (context) => HomePage(),
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0ecf7), Color(0xFF004A61)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo or Avatar
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: const Color(0xFF004A61),
                      child: Icon(Icons.school, color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 18),
                    // Welcome Text
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004A61),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue to ProTrack",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFF004A61)),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF004A61)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passkey = !passkey;
                            });
                          },
                          icon: Icon(
                            passkey ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: passkey,
                    ),
                    const SizedBox(height: 28),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: const Color(0xFF004A61),
                          elevation: 4,
                        ),
                        onPressed: signIn,
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
