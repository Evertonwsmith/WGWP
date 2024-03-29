import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordgamewithpals/dbAccess/save.dart';
import 'package:wordgamewithpals/model/game.dart';

class gameScreen extends StatefulWidget {
  final game currentGame;
  final int id;
  final bool daily;

  gameScreen({super.key, required this.currentGame, required this.id, required this.daily});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  TextEditingController mainController = new TextEditingController();
  bool init = true;
  String currentGuess = '';
  game thisGame = new game('', -1, -1, -1, false, false, '', '', '', []);

  Map<String, dynamic> wordBreakdown = {};

  @override
  Widget build(BuildContext context) {
    // if (init) {
      thisGame = widget.currentGame;
      for (int i = 0; i < thisGame.wlength; i++) {
        if (!wordBreakdown.containsKey(thisGame.word.substring(i, i + 1))) {
          wordBreakdown[thisGame.word.substring(i, i + 1)] = 1;
        } else {
          wordBreakdown[thisGame.word.substring(i, i + 1)]++;
        }
      }
      // init = false;
    // }
    print('END INIT');
    return thisGame.active
        ? SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    title: Text('WordGameWithPals!'),
                    centerTitle: true,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(30),
                        child: Center(
                          child: Text("Guesses Used: " +
                              thisGame.gused.toString() +
                              "/" +
                              thisGame.glength.toString()),
                        ))),
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
                              onEditingComplete: () => setState(() {
                                currentGuess = mainController.text;
                              }),
                              controller: mainController,
                              decoration: InputDecoration(
                                hintText: 'Enter a guess',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (mainController.text.length !=
                                    thisGame.wlength) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Wrong length')));
                                  return;
                                } else {
                                  enterGuess(mainController.text);
                                }
                              },
                              child: Text('Enter Guess'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('WordGameWithPals!'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(thisGame.win ? "You won!" : "You lost!"),
                        Text('Word was: ${thisGame.word}'),
                      ],
                    ),
                  ),
                //implement copy/paste
                //   createShareable();
                ],
              ),
            ),
          );
  }

  getLttrRows(BuildContext context) {
    double wdth = MediaQuery.of(context).size.width / thisGame.wlength;
    List<Widget> rows = [];
    for (int j = 0; j < thisGame.glength; j++) {
      Map<String, dynamic> temp = wordBreakdown;

      List<Container> lttrs = [];
      for (int i = 0; i < thisGame.wlength; i++) {
        bool yl = false;
        bool gr = false;
        String textToShow = '';
        if (j < thisGame.gused) {
          textToShow = thisGame.guesses[j].toString().substring(i, i + 1);
          print('TEXT TO SHOW: ' + textToShow);

          if (textToShow == thisGame.word.substring(i, i + 1)) {
            gr = true;
            temp.update(thisGame.word.substring(i, i + 1),
                (value) => value = value - 1);
            print(
                j.toString() + temp.toString() + " GR: ${thisGame.word.substring(i, i + 1)}");
          } else if (thisGame.word.contains(textToShow)) {

            if (temp[textToShow] > 0) {
              yl = true;
              print(
                  j.toString() + temp.toString() + " YL: ${i}");
              temp.update(textToShow,
                      (value) => value = value - 1);
            }

          }
        } else if (j == thisGame.gused) {
          textToShow = '*';
        } else if (j > thisGame.gused && j < thisGame.guesses.length) {
          if (i < thisGame.guesses[j].length) {
            textToShow = thisGame.guesses[j].substring(i, i + 1);
            if (textToShow == thisGame.word.substring(i, i + 1)) {
              gr = true;
              temp.update(thisGame.word.substring(i, i + 1),
                  (value) => value = value - 1);
            } else if (thisGame.word.contains(textToShow)) {
              temp.update(thisGame.word.substring(i, i + 1),
                  (value) => value = value - 1);
              if (temp[thisGame.word.substring(i, i + 1)] > 0) {
                yl = true;
              }
            }
          } else {
            textToShow = '';
          }
        } else {
          textToShow = '';
        }
        lttrs.add(Container(
          width: wdth * .9,
          height: wdth * .9,
          decoration: BoxDecoration(
            color: gr
                ? Colors.green
                : yl
                    ? Colors.yellow[800]
                    : Colors.white38,
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
    if (guess == widget.currentGame.word) {
      sv.win = true;
      sv.active = false;
    }
    if (sv.guesses.length == widget.currentGame.glength) {
      sv.active = false;
    }
    print('SAveINGuess');
    save().saveGame(sv, widget.id);
    if(!sv.active && widget.daily){
      save().saveDaily(sv,sv.challenged);
    }
    setState(() {
      thisGame = sv;
    });
  }
}
