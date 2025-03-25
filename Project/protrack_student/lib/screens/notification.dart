import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Notifications",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 2,
          backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        ),
        body: ListView(
          children: [],
        ));
  }
}
