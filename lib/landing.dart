import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordgamewithpals/Login.dart';
import 'package:wordgamewithpals/SignUp.dart';
import 'package:wordgamewithpals/UI/Home.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});


  @override
  Widget build(BuildContext context) {
    checkPrefs(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login or create account"),
            SizedBox(height: 30),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                icon: Icon(Icons.login_rounded)),
            SizedBox(height: 30),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                icon: Icon(Icons.person_add_alt_1_rounded)),
          ],
        ),
      ),
    );
  }
}

void checkPrefs(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user =
      prefs.getString('user'); // Check if user exists in SharedPreferences
  if (user != null) {
    // If user exists, navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home(user: user)),
    );
  }
}
