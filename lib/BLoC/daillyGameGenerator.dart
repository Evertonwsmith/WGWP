import 'dart:math';

import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:wordgamewithpals/dbAccess/save.dart';
import 'package:wordgamewithpals/model/game.dart';
import 'package:wordgamewithpals/model/user.dart';

class dailyGameGenerator{
  getGame() {

  }


// List of common English words
  List<String> englishWords = [
    'apple', 'banana', 'orange', 'pear', 'grape', 'peach', 'kiwi', 'melon', 'plum',
    'carrot', 'potato', 'tomato', 'onion', 'cabbage', 'lettuce', 'pepper', 'cucumber',
    'chair', 'table', 'desk', 'lamp', 'book', 'pencil', 'pen', 'marker', 'paper',
    'cat', 'dog', 'bird', 'fish', 'rabbit', 'hamster', 'turtle', 'horse', 'snake'
    // Add more words as needed
  ];

// Function to generate a random word
  String generateRandomWord() {
    // Random number generator
    final random = Random();

    // Filter words with length between 4 and 6 characters
    List<String> filteredWords = englishWords.where((word) => word.length >= 4 && word.length <= 6).toList();

    // Randomly select a word from the filtered list
    String randomWord = filteredWords[random.nextInt(filteredWords.length)];

    return randomWord;
  }

  void main() {
    String word = generateRandomWord();
    print('Random word: $word');
  }

  game getDailyGame(String user,String ret) {
    return game(ret, ret.length, 5, 0,false,true,DateTime.now().toString().substring(0,10), user, 'system',[]);
  }

  void generateDailys() async{
    List<String> userList = await load().getUsers();
    String ret = generateRandomWord();
    for(int i = 0; i < userList.length; i++){
      String user = userList[i];
      game ng = getDailyGame(user,ret);
      save().saveDaily(ng,user);
    }
  }

  Future<game> getThisUsersGame(String user) async {
    return await load().getDailyGame(user);
  }


}