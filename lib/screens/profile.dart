import 'package:open_mind/widgets/navbar.dart';
import 'package:flutter/material.dart';

class OpenMindProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('WIP please go back'),
        ),
      ),
    );
  }
}
