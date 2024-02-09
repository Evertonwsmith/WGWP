import 'package:flutter/material.dart';
import 'package:wordgamewithpals/model/game.dart';

class InactiveGames extends StatelessWidget {
  final List<game> oldgames;
  final List<game> oldchallenges;
  InactiveGames({super.key, required this.oldgames, required this.oldchallenges});

  @override
  Widget build(BuildContext context) {
    Widget oldgms = ListView.builder(
      itemCount: oldgames.length,
      itemBuilder: (context, index) {
        String wl = oldgames[index].win ? "Win" : "Loss";
        return ListTile(
          title: Text(oldgames[index].creator+ " challenged you!"),
          subtitle: Text("Word: " + oldgames[index].word + "  W/L: " + wl),
          leading: Icon(
            Icons.catching_pokemon_outlined,
            color: oldgames[index].win ? Colors.green : Colors.red,
          ),
        );
      },
    );

    Widget olchlgs = ListView.builder(
      itemCount: oldchallenges.length,
      itemBuilder: (context, index) {
        String wl = oldchallenges[index].win ? "Win" : "Loss";
        return ListTile(
          title: Text("You challenged ${oldchallenges[index].challenged}"),
          subtitle: Text("Word: " + oldchallenges[index].word + "  Result: " + wl),
          leading: Icon(
            Icons.rocket_launch_outlined,
            color: oldchallenges[index].win ? Colors.green : Colors.red,
          ),
        );
      },
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
        title: Text('Inactive Games'),
        bottom: TabBar(
          tabs: [
            Tab(text: 'Inctive'),
            Tab(text: 'Your Challenges'),
          ],

        ),
      ),
      body: TabBarView(
        children: [oldgms,olchlgs]
      )
      // body: ListView.builder(
      //   itemCount: games.length,
      //   itemBuilder: (context, index) {
      //     String wl = games[index].win ? "Win" : "Loss";
      //     return ListTile(
      //       title: Text(games[index].creator+ " challenged you!"),
      //       subtitle: Text("Word: " + games[index].word + "  W/L: " + wl),
      //       leading: Icon(
      //         Icons.play_circle_filled,
      //         color: Colors.red,
      //       ),
      //     );
      //   },
      // ),
    ));
  }
}
