import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordgamewithpals/model/game.dart';

class load {
  Future<DocumentReference?> generalLoad(
      String collection, String document, String identifier) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference newRef = firestore.collection(collection).doc(document);
    newRef.get().then((value) => () {
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

  Future<List<game>> getGames(String user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('games')
          .where('challenged', isEqualTo: user)
          .where('active', isEqualTo: true)
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
}
