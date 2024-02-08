import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordgamewithpals/UI/Home.dart';
import 'package:wordgamewithpals/dbAccess/save.dart';
import 'package:wordgamewithpals/model/game.dart';

import '../dbAccess/load.dart';

class NewGame extends StatefulWidget {
  NewGame({super.key});

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  // TextEditingController wordLength = new TextEditingController();
  TextEditingController guessLength = new TextEditingController();

  TextEditingController word = new TextEditingController();
  TextEditingController drdnController = new TextEditingController();

  List<String> users = [];

  bool loaded = false;

  @override
  void dispose() {
    word.dispose();
    guessLength.dispose();
    super.dispose();
  }

  void getUsers() async {
    List<String> res = await load().getUsers();
    users = res;
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      getUsers();
    }
    List<DropdownMenuEntry<String>> items =
        users.map<DropdownMenuEntry<String>>((String value) {
      return DropdownMenuEntry<String>(
        value: value,
        label: value,
        enabled: true,
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('New Game'),
      ),
      body: Center(
        child: Form(
          child: Column(children: [
            Text('How Many Guesses?'),
            TextField(
              keyboardType: TextInputType.number,
              controller: guessLength,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[4-7]')),
                LengthLimitingTextInputFormatter(1),
              ],
            ),
            Text('Enter your word, between 4 and 6 letters'),
            TextField(
              keyboardType: TextInputType.text,
              controller: word,
            ),
            SizedBox(height: 10),
            loaded
                ? DropdownMenu(
                    dropdownMenuEntries: items,
                    controller: drdnController,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 10),
            IconButton(
                icon: Icon(Icons.send_time_extension_outlined),
                onPressed: () {
                  if (int.parse(guessLength.text) < 3 ||
                      int.parse(guessLength.text) > 7) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a number between 3 and 7'),
                      ),
                    );
                  } else if (4 > word.text.length || word.text.length > 7) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Please enter a word between 4 and 6 letters'),
                      ),
                    );
                  } else if (drdnController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a user'),
                      ),
                    );
                  } else {
                    sendNewGame(context, int.parse(guessLength.text), word.text,
                        drdnController.text);
                  }
                })
          ]),
        ),
      ),
    );
  }
}

void sendNewGame(BuildContext context, int guesses, String word, String chlngd) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user = prefs.getString('user');
  print("USER: "+user!);
  game newGame =
      game(word, word.length, guesses, 0,
          false, true, DateTime.now(), chlngd, user, []);
  save().saveGame(newGame, -1);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Home(user: user)),
  );
}
