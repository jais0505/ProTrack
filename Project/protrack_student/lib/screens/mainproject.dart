import 'package:flutter/material.dart';

class MainProjectScreen extends StatefulWidget {
  const MainProjectScreen({super.key});

  @override
  State<MainProjectScreen> createState() => _MainProjectScreenState();
}

class _MainProjectScreenState extends State<MainProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Main Project Screeen"),
        ],
      ),
    );
  }
}
