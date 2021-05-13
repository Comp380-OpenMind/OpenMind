import 'package:open_mind/widgets/navbar.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    String _chosenValue;
    dynamic color = Colors.blue;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
          child: DropdownButton(
        focusColor: Colors.white,
        value: _chosenValue,
        style: TextStyle(color: Colors.black),
        items: <String>['Red', 'Pink', 'Purple', 'Indigo', 'Blue']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(
          "Pick a color",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600),
        ),
        onChanged: (String value) {
          _chosenValue = value;
          if (value == 'Red') {
            color = Colors.red;
          } else if (value == 'Pink') {
            color = Colors.pink;
          } else if (value == 'Purple') {
            color = Colors.purple;
          } else if (value == 'Indigo') {
            color = Colors.indigo;
          } else if (value == 'Blue') {
            color = Colors.blue;
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp(color)));
        },
      )),
    );
  }
}
