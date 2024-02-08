import 'package:flutter/material.dart';
import 'package:wordgamewithpals/BLoC/loginProcess.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();

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
                LoginProcess().signup(
                    context, _controller1.text, _controller2.text);
              },
              child: Text('SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}
