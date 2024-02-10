import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'Settings (Currently Incative)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: 50),
            Text('Settings'),
            SizedBox(height: 20),
            Text('Currently inactive'),
            SizedBox(height: 50),
            Container(
              height: 50,
              width: MediaQuery.of(
                    context,
                  ).size.width *
                  .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(
                    context,
                  ).size.width *
                  .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.leaderboard_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.post_add_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
