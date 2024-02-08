import 'package:flutter/material.dart';
import 'package:wordgamewithpals/BLoC/loginProcess.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controller1 = new TextEditingController();

  TextEditingController _controller2 = new TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 30),
            TextField(
                controller: _controller2,
                // obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Passcode',

                )),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                LoginProcess().login(
                    context,_controller1.text, _controller2.text,

                );
              },
              //   LoginProcess().login(
              //       context, _controller1.text, _controller2.text);
              // },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
