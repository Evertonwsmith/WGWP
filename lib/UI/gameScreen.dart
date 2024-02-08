import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordgamewithpals/dbAccess/save.dart';
import 'package:wordgamewithpals/model/game.dart';

class gameScreen extends StatefulWidget {
  final game currentGame;
  final int id;

  gameScreen({super.key, required this.currentGame, required this.id});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  TextEditingController mainController = new TextEditingController();
  bool init = true;
  String currentGuess = '';
  game thisGame = new game('', -1, -1, -1, false, false, '', '', '', []);

  @override
  Widget build(BuildContext context) {
    if (init) {
      thisGame = widget.currentGame;
      init = false;
    }
    print(thisGame.gused.toString());
    print(thisGame.glength.toString());
    return thisGame.active
        ? Scaffold(
            appBar: AppBar(
              title: Text('WordGameWithPals!'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: getLttrRows(context),
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    TextField(
                      onEditingComplete:()=>
                          setState(() {
                            currentGuess = mainController.text;
                          }),
                      controller: mainController,
                      decoration: InputDecoration(
                        hintText: 'Enter a guess',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        enterGuess(mainController.text);
                      },
                      child: Text('Enter Guess'),
                    ),
                  ],
                ))
              ],
            ))
        : Scaffold(
            appBar: AppBar(
              title: Text('WordGameWithPals!'),
              centerTitle: true,
            ),
            body: Center(
              child: Text(thisGame.win ? "You won!" : "You lost!"),
            ),
          );
  }

  getLttrRows(BuildContext context) {
    List<Widget> rows = [];
    for (int j = 0; j < thisGame.guesses.length; j++) {
      List<Container> lttrs = [];
      for (int i = 0; i < thisGame.wlength; i++) {
        bool yl = false;
        bool gr = false;
        String textToShow='';
        if (j < thisGame.gused) {
          textToShow = thisGame.guesses[j].toString().substring(i, i + 1);
          if (textToShow == thisGame.word.substring(i, i + 1)) {
            gr = true;
          } else if (thisGame.word.contains(textToShow)) {
            yl = true;
          }
        }
        else if (j == thisGame.gused) {

          // if (i < thisGame.glength) {
          //   textToShow = mainController.text.substring(i, i + 1);
          //   if (textToShow == thisGame.word.substring(i, i + 1)) {
          //     gr = true;
          //   } else if (thisGame.word.contains(textToShow)) {
          //     yl = true;
          //   }
          // } else {
          //   textToShow = '';
          // }
        } else if (j > thisGame.gused && j < thisGame.guesses.length) {
          if (i < thisGame.guesses[j].length) {
            textToShow = thisGame.guesses[j].substring(i, i + 1);
            if (textToShow == thisGame.word.substring(i, i + 1)) {
              gr = true;
            } else if (thisGame.word.contains(textToShow)) {
              yl = true;
            }
          } else {
            textToShow = '';
          }
        } else {
          textToShow = '';
        }
        lttrs.add(Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: gr
                ? Colors.green
                : yl
                    ? Colors.yellow
                    : Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              textToShow,
              style: TextStyle(fontSize: 30),
            ),
          ),
        ));
      }
      rows.add(SizedBox(
        height: 20,
      ));
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: lttrs,
      ));
    }
    return rows;
  }

  void enterGuess(String guess) {
    game sv = widget.currentGame;
    sv.gused++;
    sv.guesses.add(guess);
    if (sv.guesses.length == widget.currentGame.glength) {
      sv.active = false;
      if (guess == widget.currentGame.word) {
        sv.win = true;
      }
    }
    save().saveGame(sv, widget.id);
    setState(() {
      thisGame = sv;
    });
  }
}