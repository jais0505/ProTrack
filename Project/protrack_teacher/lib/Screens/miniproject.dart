import 'package:flutter/material.dart';

class Miniproject extends StatefulWidget {
  const Miniproject({super.key});

  @override
  State<Miniproject> createState() => _MiniprojectState();
}

class _MiniprojectState extends State<Miniproject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Mini Project Page",
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    );
  }
}
