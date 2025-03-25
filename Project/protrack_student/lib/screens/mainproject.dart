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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Main Project",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 10),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Project title: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Group guide: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
