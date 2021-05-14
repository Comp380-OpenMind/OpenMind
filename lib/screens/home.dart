import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/helperfunctions/sharedpref_helper.dart';
import 'package:open_mind/screens/searching.dart';
import 'package:open_mind/services/database.dart';
import 'package:open_mind/widgets/navbar.dart';
import 'chatscreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  Stream usersStream;
  String myName, myProfilePic, myUserName, myEmail;

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
                    child: Column(
                      children: [
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Gun Control',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Gun Control';
                                  String stance = 'for';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'Guns should be restricted',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Gun Control';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'Guns should not be restricted',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Abortion',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Abortion';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I am pro-choice',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Abortion';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I am anti-abortion',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Religious Freedom',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Religious Freedom';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I support religious freedom',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Religious Freedom';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I am against religious freedom',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Animal Rights',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Animal Rights';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I support animal rights',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Animal Rights';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I am against animal rights',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Vaccines',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Vaccines';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I think everyone should be vaccinated',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Vaccines';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I believe vaccines are dangerous',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Privacy Rights',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Privacy Rights';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I support our right to privacy',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Privacy Rights';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I dont believe we have a right to privacy',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Climate Change',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Climate Change';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I believe in climate change',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Climate Change';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I dont believe in climate change',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Evolution',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Evolution';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I believe in evolution',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Evolution';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I dont believe in evolution',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Marriage Equality',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Marriage Equality';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I support marriage equality',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against marriage equality',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Transgender Rights',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          children: [
                            ListTile(
                                onTap: () {
                                  String topic = 'Transgender Rights';
                                  String stance = 'for';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I support transgender rights',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {
                                  String topic = 'Transgender Rights';
                                  String stance = 'against';
                                  DatabaseMethods().addUserToTopic(
                                      topic, stance, myUserName);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Searching(
                                              topic, stance, myUserName)));
                                },
                                title: Text(
                                  'I am against transgender rights',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
