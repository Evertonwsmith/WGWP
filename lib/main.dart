import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wordgamewithpals/landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyD2pL_AOQFfbg_9bNk_Aes6ETqoVpYLbRY",
          authDomain: "wordgamewithpals.firebaseapp.com",
          projectId: "wordgamewithpals",
          storageBucket: "wordgamewithpals.appspot.com",
          messagingSenderId: "541477768814",
          appId: "1:541477768814:web:16ed741d894883d503a07f",
          measurementId: "G-1NCKFZWYT0"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Landing(),
    );
  }
}
