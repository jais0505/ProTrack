import 'package:flutter/material.dart';
import 'package:protrack_student/screens/dashboard.dart';

import 'package:protrack_student/screens/newlogin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://jjgpiuqajneevdvwhmku.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqZ3BpdXFham5lZXZkdndobWt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzNDY3ODQsImV4cCI6MjA0OTkyMjc4NH0.D6huZEvSmiouOe_Tzqky0FcJV_bOrAOA1PrtWjnzETM',
  );
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: AuthWrapper());
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    final session = supabase.auth.currentSession;

    // Navigate to the appropriate screen based on the authentication state
    if (session != null) {
      return HomePage(); // Replace with your home screen widget
    } else {
      return NewLoginPage(); // Replace with your auth page widget
    }
  }
}
