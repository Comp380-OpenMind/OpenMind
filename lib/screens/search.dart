// we should move the search bar to a page that the side bar links you to so we can clean up and add stuff to the home page
import 'package:open_mind/widgets/navbar.dart';
import 'package:flutter/material.dart';

class OpenMindSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("Search"),
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
