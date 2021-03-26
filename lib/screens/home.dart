import 'package:flutter/material.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OpenMind"), actions: [
        InkWell(
          onTap: () {
            AuthMethods().signOut().then((s) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app)),
        )
      ]),
    );
  }
}
