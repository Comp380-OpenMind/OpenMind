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
  bool isFound = false;
  Stream userStream;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  //constantly checks for another user looking for the same convo
  getOtherUser() async {
    String opposingStance = "for";
    if (widget.stance == 'for') {
      opposingStance = "against";
    }
    opposingStance = widget.topic + ' - ' + opposingStance;
    isSearching = true;
    setState(() {});
    userStream = await DatabaseMethods().getUserbyTopic(opposingStance);
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
              builder: (context) => ChatScreen(matchedUser, widget.topic)));
      // Add Your Code here.
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    DatabaseMethods()
        .addUserToTopic(widget.topic, widget.stance, widget.myUserName);
    getOtherUser();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) return;

    final isDetached = state == AppLifecycleState.detached;

    if (isDetached) {
      DatabaseMethods().removeUserFromTopic(widget.myUserName);
    }
  }

  @override
  Widget build(BuildContext context) {
    //removes the user from the queue if they leave the searching page
    return WillPopScope(
        onWillPop: () async {
          CollectionReference system =
              FirebaseFirestore.instance.collection('pairing_system');
          system
              .doc(widget.myUserName)
              .delete()
              .then((value) => print("User Deleted"))
              .catchError((error) => print("Failed to delete user: $error"));
          return true;
        },
        child: Stack(children: [
          Scaffold(
              appBar: AppBar(title: Text("Searching")),
              body: Container(
                  //Streams data from the database to find a match
                  child: Center(child: CircularProgressIndicator()))),
          //constantly check database for users looking for the same convo
          StreamBuilder(
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
                  : Center();
            },
          )
        ]));
  }
}
