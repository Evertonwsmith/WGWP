import 'package:flutter/material.dart';
import 'package:wordgamewithpals/dbAccess/load.dart';
import 'package:wordgamewithpals/model/userLeaderboard.dart';

class Profile extends StatefulWidget {
  final String user;

  Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  userLBInfo current = userLBInfo('', 0, 0, 0, 0);
  List<String> dataName = [
    'User:',
    'Wins:',
    'Losses:',
    'Points:',
    'Daily Challenges Won:'
  ];

  @override
  void initState() {
    super.initState();
    getLeaderboardUser(widget.user);
  }

  void getLeaderboardUser(String user) async {
    userLBInfo? res = await load().loadUser(user);
    if (res != null) {
      setState(() {
        current = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> data = [
      current.user,
      current.wins.toString(),
      current.losses.toString(),
      current.points.toString(),
      current.dailyChallenges.toString()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body:
        ListView.builder(
          itemCount: dataName.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(dataName[index]),
              subtitle: Text(data[index]),
            );
          },
        ),
    );
  }
}
