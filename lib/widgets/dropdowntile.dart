// this was the example I used for the drop down stuff on the homepage
// if we dont want those on the homepage I'll probably move everything over here
// at the moment though this is not in use

import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Expansion Tile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            ExpansionTile(
              title: Text(
                "Title",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ExpansionTile(
                  title: Text(
                    'Sub title',
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text('this is the listtile'),
                    )
                  ],
                ),
                ListTile(
                  title: Text('this is the listtile'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
