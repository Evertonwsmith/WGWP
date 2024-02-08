import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordgamewithpals/Login.dart';
import 'package:wordgamewithpals/UI/Home.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProcess {
  Future<void> login(
      BuildContext context, String username, String passcode) async {
    try {
      bool found = await findUser(context, username);
      if (found) {
        await updatePrefs(context, username);
        print('logged in as $username');
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(user: username)));
                },
                child: Center(child: Text('Welcome'))));
      }else{
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Center(child: Container(child: Center(child: Text("Cannot find User or passcode incorrect"))));
            });
      }
    } catch (e) {
      print(e);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Center(child: Container(child: Center(child: Text("Error Validating: Call Ghostbusters"))));
          });
    }
  }

  Future<void>
  updatePrefs(BuildContext context, String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("SharedPreferences");
    prefs.setString('user', username);
  }

  Future<void> signup(
      BuildContext context, String username, String passcode) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Text("Username already taken");
            });
      } else {
        createUser(context, username, passcode);
      }
    } catch (e) {
      print('ERROR');
    }
  }
}

void createUser(BuildContext context, String username, String passcode) {
  FirebaseFirestore.instance.collection('users').doc(username).set({
    'username': username,
    'passcode': passcode,
  });
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Text("User created");
      });
  Navigator.popAndPushNamed(
      context, MaterialPageRoute(builder: (context) => Login()).toString());
}

Future<bool> findUser(BuildContext context, String username) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore
      .collection('users')
      .where('username', isEqualTo: username)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    print("Found");
    return true;
  } else {
    print("Not found");
    return false;
  }
}
