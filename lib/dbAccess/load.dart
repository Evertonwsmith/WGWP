import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordgamewithpals/model/dailyGame.dart';
import 'package:wordgamewithpals/model/game.dart';
import 'package:wordgamewithpals/model/userLeaderboard.dart';

class load {
  Future<DocumentReference?> generalLoad(String collection,
      String document) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference newRef = firestore.collection(collection).doc(document);
    newRef.get().then((value) =>
        () {
      return value.get('user') == null ? null : value;
    });
  }

  Future<int> getGameCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('games')
        .get()
        .then((value) => value.docs.length);
  }

  Future<List<String>> getUsers() async {
    List<String> users = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();

      querySnapshot.docs.forEach((doc) {
        users.add(doc.get('username'));
      });

      print(users.toString());
    } catch (e) {
      print('Error fetching users: $e');
    }

    return users;
  }

  Future<List<game>> getGames(String user, bool status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('games')
          .where('challenged', isEqualTo: user)
          .where('active', isEqualTo: status)
          .get();

      List<game> games = querySnapshot.docs.map((doc) {
        // Convert each document to a Game object
        return game(
            doc.get('word'),
            doc.get('wlength'),
            doc.get('glength'),
            doc.get('gused'),
            doc.get('win'),
            doc.get('active'),
            doc.get('date'),
            doc.get('challenged'),
            doc.get('creator'),
            doc.get('guesses'));
      }).toList();

      return games;
    } catch (e) {
      print('Error getting games: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  getIds(String user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('games')
          .where('challenged', isEqualTo: user)
          .where('active', isEqualTo: true)
          .get();

      List<int> ids = querySnapshot.docs.map((doc) {
        print("id: " + doc.id);
        return int.parse(doc.id);
      }).toList();

      return ids;
    } catch (e) {
      print('Error getting games: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<List<game>> getChallenges(String user, bool status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('games')
          .where('creator', isEqualTo: user)
          .where('active', isEqualTo: status)
          .get();

      List<game> games = querySnapshot.docs.map((doc) {
        // Convert each document to a Game object
        return game(
            doc.get('word'),
            doc.get('wlength'),
            doc.get('glength'),
            doc.get('gused'),
            doc.get('win'),
            doc.get('active'),
            doc.get('date'),
            doc.get('challenged'),
            doc.get('creator'),
            doc.get('guesses'));
      }).toList();

      return games;
    } catch (e) {
      print('Error getting games: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<userLBInfo?> loadUser(user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference newRef = firestore.collection('leaderboard').doc(user);

    try {
      DocumentSnapshot snapshot = await newRef.get();
      if (snapshot.exists) {
        return userLBInfo(
          snapshot.get('user'),
          snapshot.get('wins'),
          snapshot.get('losses'),
          snapshot.get('points'),
          snapshot.get('dailyChallenges'),
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }


  Future<dailyGame?> getDailyGame() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print("*********************"+DateTime.now().toString().substring(0,10));
    DocumentReference newRef = firestore.collection('dailyChallenge').doc(DateTime.now().toString().substring(0,10));

    try {
      DocumentSnapshot doc = await newRef.get();
      if (doc.exists) {
        return dailyGame(
            doc.get('word'),
            doc.get('winners'),
            doc.get('losers'),
        doc.get('guesses'));
      } else {
        return null;
      }
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }
}