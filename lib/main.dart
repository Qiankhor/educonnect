import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyA7mUBkc2n8LBxcoLnPXNlrNF9oRfDsvFk',
          appId: '1:865014841760:android:e427e8517526f3af0fe4c5',
          messagingSenderId: '865014841760',
          projectId: 'educonnect-410d6'));
  runApp(const EduConnectApp());
}
