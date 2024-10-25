import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDMzdYfjICDI2EonFpLZakqpOG6VaGSyZM',
          appId: '1:351876152515:android:2c84567d5868100cd63676',
          messagingSenderId: '351876152515',
          projectId: 'educonnect-410d6'));
  runApp(const EduConnectApp());
}
