import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFF8F8F8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 40, bottom: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber),
                    height: 50,
                    width: 50,
                    child: Icon(Icons.person_2_outlined),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Hi, Teacher",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 12, 47, 68)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 10),
              child: Container(
                width: 500,
                height: 120,
                decoration: BoxDecoration(
                    color: Color(0xFF004A61),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Gjbvsdts BUYFDB YVCYITF",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  Card(
                    color: Color(0xFFFFFFFF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text("1")),
                  ),
                  Card(
                    color: Color(0xFFFFFFFF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text("2")),
                  ),
                  Card(
                    color: Color(0xFFFFFFFF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text("3")),
                  ),
                  Card(
                    color: Color(0xFFFFFFFF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text("4")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
