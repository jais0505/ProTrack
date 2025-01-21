import 'package:flutter/material.dart';
import 'package:protrack_admin/firebase_options.dart';
import 'package:protrack_admin/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        debugShowCheckedModeBanner: false, home: AdminLogin());
  }
}
