import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:wordgamewithpals/model/dailyGame.dart';
import 'package:wordgamewithpals/model/game.dart';
import 'package:wordgamewithpals/model/userLeaderboard.dart';

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
    if (gamenum == -1) {
      gamenum = gameCount;
    }

    if (!game.active) {
      updateLeaderboards(game, firestore);
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
        'creator': game.creator,
        'guesses': game.guesses
      });
      print('Game saved successfully');
    } catch (e) {
      print('Error saving game: $e');
      throw e; // Re-throw the exception to handle it in the caller function if needed
    }
  }

  Future<void> saveDaily(String user, dailyGame sv) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference newRef = await firestore
        .collection('dailyChallenge')
        .doc(DateTime.now().toString().substring(0, 10));
    DocumentSnapshot doc = await newRef.get();
    List<String> winners = doc.get('winners');
    List<String> losers = doc.get('losers');
    // if (!sv.active) {
    //   sv.win ? winners.add(user) : losers.add(user);
    //   // doc.set({'winners', winners});
    //   await firestore.collection('dailyChallenge').doc(DateTime.now().toString().substring(0,10)).set({
    //     'winners' : winners,
    //     'losers' : losers,
    //   });
  }
}

Future<void> updateLeaderboards(game game, FirebaseFirestore firestore) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('leaderboard')
      .where('user', isEqualTo: game.challenged)
      .get();
  // Get data from the snapshot
  if (querySnapshot.size == 0) {
    await firestore.collection('leaderboard').doc(game.challenged).set({
      'user': game.challenged,
      'wins': 0,
      'losses': 0,
      'points': 0,
      'dailyChallenges': 0
    });
    querySnapshot = await firestore
        .collection('leaderboard')
        .where('user', isEqualTo: game.challenged)
        .get();
  }
  List<userLBInfo> userLBinfos = querySnapshot.docs.map((doc) {
    return userLBInfo(doc.get('user'), doc.get('wins'), doc.get('losses'),
        doc.get('points'), doc.get('dailyChallenges'));
  }).toList();
  userLBInfo current = userLBinfos[0];
  if (game.win) {
    current.wins++;
    switch (game.wlength) {
      case 4:
        current.points += 10;
        break;
      case 5:
        current.points += 15;
        break;
      case 6:
        current.points += 20;
        break;

        break;
      default:
    }
  } else {
    current.losses++;
    current.points += 1;
  }
  await firestore
      .collection('leaderboard')
      .doc(game.challenged)
      .set({'points': current.points});
}
