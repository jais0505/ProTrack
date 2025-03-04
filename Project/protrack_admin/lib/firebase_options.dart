// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrumjtXRuPpEHxr6cw2UUrCAdtBzZmQlQ',
    appId: '1:1030071218254:web:987f58da941862a6b7131f',
    messagingSenderId: '1030071218254',
    projectId: 'pro-track-da4b9',
    authDomain: 'pro-track-da4b9.firebaseapp.com',
    storageBucket: 'pro-track-da4b9.firebasestorage.app',
    measurementId: 'G-B9SG3XGPCP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIz63zduFtyW3EARPn5cF3mhGl-G6VLAU',
    appId: '1:1030071218254:android:ac771918b1bcc5d2b7131f',
    messagingSenderId: '1030071218254',
    projectId: 'pro-track-da4b9',
    storageBucket: 'pro-track-da4b9.firebasestorage.app',
  );
}
