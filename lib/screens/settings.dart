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
        body: Column(
          children: [
            DropdownButton(
              focusColor: Colors.white,
              value: _chosenValue,
              style: TextStyle(color: Colors.black),
              items: <String>[
                'Red',
                'Pink',
                'Purple',
                'Indigo',
                'Blue',
                'Light Blue',
                'Cyan',
                'Teal',
                'Green',
                'Light Green',
                'Lime',
                'Yellow',
                'Amber',
                'Orange',
                'Deep Orange',
                'Brown',
                'Blue Gray'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text(
                "Pick a color",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
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
                } else if (value == 'Light Blue') {
                  color = Colors.lightBlue;
                } else if (value == 'Cyan') {
                  color = Colors.cyan;
                } else if (value == 'Teal') {
                  color = Colors.teal;
                } else if (value == 'Green') {
                  color = Colors.green;
                } else if (value == 'Light Green') {
                  color = Colors.lightGreen;
                } else if (value == 'Lime') {
                  color = Colors.lime;
                } else if (value == 'Yellow') {
                  color = Colors.yellow;
                } else if (value == 'Amber') {
                  color = Colors.amber;
                } else if (value == 'Orange') {
                  color = Colors.orange;
                } else if (value == 'Deep Orange') {
                  color = Colors.deepOrange;
                } else if (value == 'Brown') {
                  color = Colors.brown;
                } else if (value == 'Blue Grey') {
                  color = Colors.blueGrey;
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp(color)));
              },
            ),
          ],
        ));
  }
}
