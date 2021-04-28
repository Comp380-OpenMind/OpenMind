import 'package:open_mind/screens/home.dart';
import 'package:open_mind/widgets/navbar.dart';
import 'package:flutter/material.dart';

class OpenMindSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          child: Text('WIP please go back'),
        ),
      ),
    );
  }
}
