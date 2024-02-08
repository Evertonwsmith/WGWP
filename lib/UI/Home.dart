import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordgamewithpals/Login.dart';
import 'package:wordgamewithpals/UI/ActiveGames.dart';
import 'package:wordgamewithpals/UI/InactiveGames.dart';
import 'package:wordgamewithpals/UI/NewGame.dart';
import 'package:wordgamewithpals/UI/Profile.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';

import '../model/game.dart';
import 'Settings.dart';

class Home extends StatefulWidget {
  final String user;

  Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool gamesLoaded = false;

  List<game> games = [];
  List<int> ids = [];

  bool notifs = false;

  void getGames() async {
    games = await load().getGames(this.widget.user);
    ids = await load().getIds(this.widget.user);
    if(games.length > 0) {
      setState(() {
        notifs = true;
      });


    }else{
      setState(() {
        notifs = false;
      });
    }
  }
bool init = true;
  @override
  Widget build(BuildContext context) {
    if(init) {
      getGames();
    init = false;
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.login_outlined),
            onPressed: () {
              logout(context);
            }
          ),
          title: Text('Welcome ${widget.user}'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewGame()));
                  },
                  icon: Icon(Icons.add_circle_outline)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ActiveGames(games: games, ids: ids)));
                  },
                  icon: Icon(Icons.notification_important_outlined,color: notifs ? Colors.red : Colors.black)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InactiveGames()));
                  },
                  icon: Icon(Icons.drive_folder_upload)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  icon: Icon(Icons.settings_applications_outlined)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  icon: Icon(Icons.person_2_outlined)),
            ],
          ),
        ));
  }
}

void logout(BuildContext context) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  });
}