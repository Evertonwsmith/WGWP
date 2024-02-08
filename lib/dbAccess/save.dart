import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:wordgamewithpals/model/game.dart';

class save {
  Future<void> generalSave(
      String collection, String document, Map<String, dynamic> data) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot ref = await firestore.collection(collection).get();
    DocumentReference newRef = firestore.collection(collection).doc(document);
    await newRef.set(data);
  }

  Future<void> saveGame(game game, int gamenum) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int gameCount = await load().getGameCount();
    if(gamenum == -1) {
      gamenum = gameCount;
    }

    try {
      await firestore.collection('games').doc(gamenum.toString()).set({
        'word': game.word,
        'wlength': game.wlength,
        'glength': game.glength,
        'gused': game.gused,
        'win': game.win,
        'active': game.active,
        'date': game.date,
        'challenged': game.challenged,
        'creator' : game.creator,
        'guesses' : game.guesses
      });
      print('Game saved successfully');
    } catch (e) {
      print('Error saving game: $e');
      throw e; // Re-throw the exception to handle it in the caller function if needed
    }
  }
}
