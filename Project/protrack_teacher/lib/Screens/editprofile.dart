import 'package:flutter/material.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Edit Profile Page",
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    );
  }
}
