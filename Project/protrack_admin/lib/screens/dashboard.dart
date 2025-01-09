import 'package:flutter/material.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1150,
            height: 50,
            decoration: BoxDecoration(color: Colors.blue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/Profile.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Admin',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(
                  width: 50,
                )
              ],
            ),
          ),
          Container(
            width: 240,
            height: 535,
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 64, 146, 214),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {},
                      child: Text(
                        'Screen1',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 64, 146, 214),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {},
                      child: Text(
                        'Screen2',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 64, 146, 214),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {},
                      child: Text(
                        'Screen3',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 64, 146, 214),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {},
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
