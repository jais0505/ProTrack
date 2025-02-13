import 'package:flutter/material.dart';

class Mainproject extends StatefulWidget {
  const Mainproject({super.key});

  @override
  State<Mainproject> createState() => _MainprojectState();
}

class _MainprojectState extends State<Mainproject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Main Project Page",
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    );
  }
}
