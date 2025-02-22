import 'package:flutter/material.dart';

class TeacherLoginPage extends StatelessWidget {
  const TeacherLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE5F8F9),
                  Color(0xFFB2EBF2)
                ], // Light blue shades
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Login Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Text
                  Text(
                    "Selamat Datang!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004A61),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Masukkan NISN dan password untuk memulai belajar.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 40),

                  // NISN Field
                  TextField(
                    decoration: InputDecoration(
                      labelText: "NISN",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon:
                          Icon(Icons.person_outline, color: Color(0xFF004A61)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password Field
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Color(0xFF004A61)),
                      suffixText: "Lupa Password?",
                      suffixStyle: TextStyle(color: Color(0xFF004A61)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color(0xFF004A61),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Handle Login Logic
                        print("Login Button Pressed");
                      },
                      child: Text(
                        "MULAI BELAJAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Additional Bottom Links
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        print("Need Help? Pressed");
                      },
                      child: Text(
                        "Butuh bantuan?",
                        style: TextStyle(
                          color: Color(0xFF004A61),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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

void main() => runApp(MaterialApp(home: TeacherLoginPage()));
