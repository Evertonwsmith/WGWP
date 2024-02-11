import 'package:flutter/material.dart';
import 'package:wordgamewithpals/UI/gameScreen.dart';
import 'package:wordgamewithpals/model/game.dart';

class ActiveGames extends StatelessWidget {
  final List<game> games;
  final List<int> ids;

  const ActiveGames({super.key, required this.games, required this.ids});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Games'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(games[index].creator+ " challenged you!"),
            subtitle: Text("Word length: " + games[index].wlength.toString() + "  Guesses Left: " +
                (games[index].glength - games[index].gused).toString() +
                "/" +
                games[index].glength.toString()),
            leading: IconButton(icon: Icon(Icons.stars_outlined), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => gameScreen(currentGame: games[index], id: ids[index],daily: false)));
            },),
          );
        },
      ),
    );
  }
}
