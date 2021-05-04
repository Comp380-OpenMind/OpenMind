import 'package:flutter/material.dart';
import 'package:open_mind/services/database.dart';

class OpenMindSearching extends StatelessWidget {
  final topic;
  final stance;
  final email;
  OpenMindSearching({Key key, this.topic, this.stance, this.email})
      : super(key: key);

  Widget build(BuildContext context) {
    // if the user leaves the page, this removes them from the database since they are no longer searching
    return WillPopScope(
        onWillPop: () async {
          DatabaseMethods().removeUserFromTopic(topic, stance, email);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Searching"),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ) // Your Scaffold goes here.
        );
  }
}
