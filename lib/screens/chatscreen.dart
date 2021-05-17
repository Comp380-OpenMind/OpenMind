import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/helperfunctions/sharedpref_helper.dart';
import 'package:open_mind/services/database.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, topic;
  ChatScreen(this.chatWithUsername, this.topic);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  Stream messageStream;
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      // keep track of the timestamps for each message for correct placement
      var lastMessageTs = DateTime.now();

      //create a map to store info for messages
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEditingController.text = "";

          //make message id blank to get regenerated on nextmessage sent
          messageId = "";
        }
      });
    }
  }

  //theres an issue here where messages are overflowing, delete this comment when fixed
  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(10) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(10),
                ),
                // makes it so that if its sent by me make it blue, otherwise make it another color
                color: sendByMe ? Theme.of(context).accentColor : Colors.grey,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds["message"], myUserName == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
    DatabaseMethods().removeUserFromTopic(myUserName);
  }

  popup(chatRoomId) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Center(child: Text('Rate')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Did this user abide by the rules and keep an open mind?",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                child: Icon(Icons.thumb_up),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }),
                            TextButton(
                                child: Icon(Icons.thumb_down),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }),
                          ]),
                      TextButton(
                          child: Text('Report',
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          }),
                    ],
                  )
                ],
              ),
            ),
        barrierDismissible: false);
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  Widget build(BuildContext context) {
    //removes the user from the queue if they leave the searching page
    return WillPopScope(
        onWillPop: () {
          return popup(chatRoomId);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.topic),
          ),
          body: Container(
            child: Stack(
              children: [
                chatMessages(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      // makes the widget an opaque black
                      color: Colors.black.withOpacity(0.8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                              // text the user inputs
                              child: TextField(
                            controller: messageTextEditingController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6))),
                          )),
                          GestureDetector(
                            onTap: () {
                              addMessage(true);
                            },
                            child: Icon(Icons.send, color: Colors.white),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
