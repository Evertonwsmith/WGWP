import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:wordgamewithpals/dbAccess/save.dart';
import 'package:wordgamewithpals/model/game.dart';

import '../model/dailyGame.dart';

class DailyChallenge extends StatefulWidget {
  final String user;

  const DailyChallenge({Key? key, required this.user}) : super(key: key);

  @override
  State<DailyChallenge> createState() => _DailyChallengeState();
}

class _DailyChallengeState extends State<DailyChallenge> {
  dailyGame current = dailyGame('',[],[], []);
  TextEditingController mainController = TextEditingController();
  bool init = true;
  String currentGuess = '';

  @override
  void initState() {
    super.initState();
    getDaily();
  }

  Future<void> getDaily() async {
    current = (await load().getDailyGame())!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('dailyGuesses')) {
      List<String>? lan = prefs.getStringList('dailyGuesses');
      if (lan != null) {
        current.guesses = lan;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return current.guesses.length != current.word.length
        ? SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('WordGameWithPals!'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: getLttrRows(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      onEditingComplete: () {
                        setState(() {
                          currentGuess = mainController.text;
                        });
                      },
                      controller: mainController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a guess',
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (mainController.text.length !=
                            current.word.length) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong length')),
                          );
                        } else {
                          enterGuess(mainController.text);
                        }
                      },
                      child: const Text('Enter Guess'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        : SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WordGameWithPals!'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Text('Word was: ${current.word}'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getLttrRows(BuildContext context) {
    double wdth = MediaQuery.of(context).size.width / current.word.length;
    List<Widget> rows = [];
    for (int j = 0; j < 5; j++) {
      List<Container> lttrs = [];
      for (int i = 0; i < current.word.length; i++) {
        bool yl = false;
        bool gr = false;
        String textToShow = '';
        if (j < current.guesses.length) {
          textToShow = current.guesses[j].toString().substring(i, i + 1);
          if (textToShow == current.word.substring(i, i + 1)) {
            gr = true;
          } else if (current.word.contains(textToShow)) {
            yl = true;
          }
        } else if (j == current.guesses.length) {
          textToShow = '*';
        } else if (j > current.guesses.length && j < 5) {
          if (i < current.guesses[j].length) {
            textToShow = current.guesses[j].substring(i, i + 1);
            if (textToShow == current.word.substring(i, i + 1)) {
              gr = true;
            } else if (current.word.contains(textToShow)) {
              yl = true;
            }
          } else {
            textToShow = '';
          }
        } else {
          textToShow = '';
        }
        lttrs.add(
          Container(
            width: wdth * .9,
            height: wdth * .9,
            decoration: BoxDecoration(
              color: gr
                  ? Colors.green
                  : yl
                  ? Colors.yellow
                  : Colors.white38,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                textToShow,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        );
      }
      rows.add(const SizedBox(height: 20));
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: lttrs,
        ),
      );
    }
    return rows;
  }

  void enterGuess(String guess) {
    dailyGame sv = current;

    sv.guesses.add(guess);
    if (guess == current.word) {
sv.winners.add(widget.user);

    }
    else if (sv.guesses.length == current.guesses.length) {
      sv.losers.add(widget.user);
    }
    save().saveDaily(widget.user, sv);
    setState(() {
      current = sv;
    });
    updatePrefs();
  }

  void updatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ret = [];
    for (var dor in current.guesses) {
      ret.add(dor.toString());
    }
    prefs.setStringList('dailyGuesses', ret);
  }
}
