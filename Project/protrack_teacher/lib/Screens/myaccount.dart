import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004A61)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amber),
                    height: 100,
                    width: 100,
                    child: Icon(
                      Icons.person_2_outlined,
                      size: 70,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Name",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004A61)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
