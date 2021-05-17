import 'dart:async';
import 'package:flutter/material.dart';
import 'package:open_mind/helperfunctions/sharedpref_helper.dart';
import 'package:open_mind/screens/searching.dart';
import 'package:open_mind/services/database.dart';
import 'package:open_mind/widgets/navbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  Stream usersStream;
  String myName, myProfilePic, myUserName, myEmail;
  Map map2 = {
    'Gun Control': [
      'Guns should be restricted',
      'Guns should not be restricted'
    ],
    'Abortion': ['I am pro-choice', 'I am anti-abortion'],
    'Religious Freedom': [
      'I support freedom of religion',
      'I am against freedom of religion'
    ],
    'Animal Rights': [
      'I support animal rights',
      'I dont believe animals deserve rights'
    ],
    'Vaccines': [
      'I believe vaccines are safe and effective',
      'I believe vaccines are dangerous and ineffective'
    ],
    'Privacy Rights': [
      'I believe I have a right to privacy',
      'I do not think people should have a right to privacy'
    ],
    'Climate Change': [
      'I believe in man-made climate change',
      'I do not believe in man-made climate change'
    ],
    'Evolution': ['I believe in evolution', 'I do not believe in evolution'],
    'Marriage Equality': [
      'I support marriage equality',
      'I do not support marriage equality'
    ],
    'Transgender Rights': [
      'I support transgender rights',
      'I do not support transgender rights'
    ]
  };

  topicsColumn(Map map2) {
    final children = <Widget>[];
    for (var i = 0; i < map2.length; i++) {
      String topic = map2.keys.elementAt(i);
      List stances = map2[topic];
      children.add(
        topicTile(topic, stances[0], stances[1]),
      );
      children.add(Divider(thickness: 2.5));
    }
    return new Column(
      children: children,
    );
  }

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getMyInfoFromSharedPreference();
    super.initState();
  }

  topicTile(String topic, detailedStance1, detailedStance2) {
    return ExpansionTile(
      trailing: SizedBox.shrink(),
      title: Text(topic,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500)),
      children: [
        ListTile(
            onTap: () {
              String stance = 'for';
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Searching(topic, stance, myUserName)));
            },
            title: Text(
              detailedStance1,
              textAlign: TextAlign.center,
            )),
        Divider(
          thickness: 1.5,
        ),
        ListTile(
            onTap: () {
              String stance = 'against';
              DatabaseMethods().addUserToTopic(topic, stance, myUserName);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Searching(topic, stance, myUserName)));
            },
            title: Text(
              detailedStance2,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(title: Text("OpenMind"), actions: []),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                Container(
                  child: Card(
                    child: Column(
                      children: [
                        ExpansionTile(
                          leading: Icon(Icons.help_outline),
                          title: Text(
                              "Click here for a little help before you get started!"),
                          children: [
                            ListTile(
                                leading: Icon(Icons.check),
                                title: Text(
                                    "Click on a topic and then choose what stance you would like to take."),
                                trailing: SizedBox.shrink()),
                            ListTile(
                                leading: Icon(Icons.check),
                                title: Text(
                                    "Once you choose your stance on a topic you will wait in a queue until someone joins that has the opposite stance."),
                                trailing: SizedBox.shrink()),
                            ListTile(
                                leading: Icon(Icons.close_outlined),
                                title: Text(
                                    "When in a chatroom don't be rude or disrespectful."),
                                subtitle: Text(
                                    "Have civil conversations to make the experience better for everyone."),
                                trailing: SizedBox.shrink())
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // here are the topic widgets
                // there are ontap prompts on the ListTile sections
                // linking to new pages can be done there
                // there is also probably a more efficent way to do this with
                // the database but this should be fine for now
                new Container(
                  child: Card(
                    child: topicsColumn(map2),
                  ),
                )
              ],
            )));
  }
}
