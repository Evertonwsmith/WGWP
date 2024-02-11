import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:wordgamewithpals/model/game.dart';

class save {
  Future<void> generalSave(String document, Map<String, dynamic> data) async {
    print('saving');
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<String> path = document.split('/');
    print('path: ' + path.toString());
    print('data: ' + data.toString());
    if (path.length == 1) {
      db.collection(document).add(data);
      print('saved 1');
    } else {
      try {
        db.collection(path[0]).doc(path[1]).update(data);
        print('saved 2');
      } catch (e) {
        db.collection(path[0]).doc(path[1]).set(data);
        print('saved 3');
      }
    }
  }

  Future<void> generalUpdate(String document, Map<String, dynamic> data) async {
    print("updating");
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<String> list = document.split('/');
    print(list.toString());

    print(data.toString());
    await db.collection(list[0]).doc(list[1]).update(data);
    print("updated");
  }

  Future<void> saveGame(game game, int gamenum) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int gameCount = await load().getGameCount();
    if (gamenum == -1) {
      gamenum = gameCount;
    }
    print('saving game');
    if (!game.active) {
      updateLeaderboards(game);
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

  void saveDaily(game sv, String challenged) {
    Map<String,dynamic> data = {
      'word': sv.word,
      'wlength': sv.wlength,
      'glength': sv.glength,
      'gused': sv.gused,
      'win': sv.win,
      'active': sv.active,
      'date': sv.date,
      'challenged': sv.challenged,
      'creator': sv.creator,
      'guesses': sv.guesses

    };
    generalSave('dailyChallenge/'+DateTime.now().toString().substring(0,10)+'/${sv.challenged}', data);
  }



Future<void> updateLeaderboards(game game) async {
  print('updating leaderboards');
  try {
    Map<String, dynamic>? current =
        await load().generalLoad('leaderboard/' + game.challenged);
    print('current: ' + current.toString());

    if (current != null) {
      // Update if loss
      if (!game.win) {
        print('loss');
        int losses = current['losses'] ?? 0;
        int points = current['points'] ?? 0;
        save().generalUpdate('leaderboard/' + game.challenged,
            {'losses': losses + 1, 'points': points + 1});
      }
      // Update if win
      else {
        print('win');
        int wins = current['wins'] ?? 0;
        int points = current['points'] ?? 0;
        save().generalUpdate('leaderboard/' + game.challenged,
            {'wins': wins + 1, 'points': points + 10});
      }
    } else {
      print('Document not found');
    }
  } catch (e) {
    print('Error updating leaderboards: $e');
  }
}}
