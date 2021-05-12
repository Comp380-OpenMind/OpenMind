import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/screens/chatscreen.dart';
import 'package:open_mind/services/database.dart';

class Searching extends StatefulWidget {
  final String topic, stance, myUserName;
  Searching(this.topic, this.stance, this.myUserName);
  @override
  _Searching createState() => _Searching();
}

class _Searching extends State<Searching> with WidgetsBindingObserver {
  bool isSearching = false;
  Stream userStream;
  String myName, myProfilePic, myUserName, myEmail;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getOtherUser(String opposing) async {
    isSearching = true;
    setState(() {});
    userStream = await DatabaseMethods().getUserbyTopic(opposing);
    setState(() {});
  }

  goToChat(String matchedUser) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var chatRoomId = getChatRoomIdByUsernames(matchedUser, matchedUser);
      Map<String, dynamic> chatRoomInfoMap = {
        "users": [widget.myUserName, matchedUser]
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(matchedUser, matchedUser)));
      // Add Your Code here.
    });
  }

  Widget connectUsers() {
    String opposingStance = "for";
    if (widget.stance == 'for') {
      opposingStance = "against";
    }
    opposingStance = widget.topic + ' - ' + opposingStance;
    DatabaseMethods()
        .addUserToTopic(widget.topic, widget.stance, widget.myUserName);
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // A DocumentSnapshot contains data read from a document in your Cloud Firestore database
                  DocumentSnapshot ds = snapshot.data.docs[0];
                  String matchedUser = ds.id;
                  return goToChat(matchedUser);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget chatRoomsList() {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String opposingStance = "for";
    if (widget.stance == 'for') {
      opposingStance = "against";
    }
    opposingStance = widget.topic + ' - ' + opposingStance;
    return Scaffold(
        appBar: AppBar(
          title: Text("Searching"),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: ListView(children: [
              ElevatedButton(
                  onPressed: () {
                    getOtherUser(opposingStance);
                  },
                  child: Text('Search')),
              isSearching ? connectUsers() : chatRoomsList()
            ])));
  }
}
