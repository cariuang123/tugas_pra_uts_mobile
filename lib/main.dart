import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/home.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: "YOUR_APP_ID", 
      apiKey: "YOUR_API_KEY", 
      projectId: "YOUR_PROJECT_ID", 
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID", 
      databaseURL: "https://latihan1-1b180-default-rtdb.asia-southeast1.firebasedatabase.app", 
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), 
    );
  }
}
