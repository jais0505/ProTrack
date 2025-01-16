import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Name:'),
          ],
        )
      ],
    );
  }
}
