import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordgamewithpals/BLoC/daillyGameGenerator.dart';
import 'package:wordgamewithpals/Login.dart';
import 'package:wordgamewithpals/UI/ActiveGames.dart';
import 'package:wordgamewithpals/UI/InactiveGames.dart';
import 'package:wordgamewithpals/UI/NewGame.dart';
import 'package:wordgamewithpals/UI/Profile.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';

import '../model/game.dart';
import 'Settings.dart';
import 'gameScreen.dart';

class Home extends StatefulWidget {
  final String user;

  Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool gamesLoaded = false;
  List<game> games = [];
  List<game> oldGames = [];
  List<game> oldChallenges = [];
  List<int> ids = [];
  bool notifs = false;
  String itemName = '';

  game todaysGame =
      game('word', 0, 0, 0, false, false, '', 'challenged', 'creator', []);

  void getOldGames() async {
    oldGames = await load().getGames(this.widget.user, false);
    oldChallenges = await load().getChallenges(this.widget.user, false);
  }

  void getGames() async {
    // dailyGameGenerator().generateDailys();
    games = await load().getGames(this.widget.user, true);
    ids = await load().getIds(this.widget.user);
    todaysGame = await dailyGameGenerator().getThisUsersGame(this.widget.user);
    if (games.length > 0) {
      setState(() {
        notifs = true;
      });
    } else {
      setState(() {
        notifs = false;
      });
    }
  }

  bool init = true;

  @override
  Widget build(BuildContext context) {
    if (init) {
      getGames();
      init = false;
    }
    getOldGames();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () {
                logout(context);
              }),

          // title: Text('Welcome ${widget.user}'),
          title: TextLiquidFill(
            text: 'WELCOME ${widget.user}',
            waveColor: Colors.greenAccent,
            boxBackgroundColor: Colors.black,
            textStyle: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),

              // ElevatedButton(onPressed:(){
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) =>
              //           gameScreen(currentGame: todaysGame, daily: true, id: 99,)));
              //
              // }

                  // , child: Text('Daily Challenge')),
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        itemName = 'New Game';
                      });
                    },
                    onLongPressUp: () {
                      setState(() {
                        itemName = '';
                      });
                    },
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewGame()));
                        },
                        icon: Icon(Icons.add_circle_outline)),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        itemName = 'Challenges';
                      });
                    },
                    onLongPressUp: () {
                      setState(() {
                        itemName = '';
                      });
                    },
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActiveGames(games: games, ids: ids)));
                        },
                        icon: Icon(Icons.notification_important_outlined,
                            color: notifs ? Colors.red : Colors.white70)),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InactiveGames(
                                      oldgames: oldGames,
                                      oldchallenges: oldChallenges,
                                    )));
                      },
                      icon: Icon(Icons.drive_folder_upload)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings()));
                      },
                      icon: Icon(Icons.settings_applications_outlined)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Profile(user: widget.user)));
                      },
                      icon: Icon(Icons.person_2_outlined)),
                ],
              ),
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
