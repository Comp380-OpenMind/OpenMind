import 'package:flutter/material.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("OpenMind"), actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ]),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    // back arrow by the username search bar
                    isSearching
                        ? GestureDetector(
                            onTap: () {
                              isSearching = false;
                            },
                            child: Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.arrow_back)),
                          )
                        : Container(),
                    // username search bar
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "username"),
                            )),
                            GestureDetector(
                                onTap: () {
                                  isSearching = true;
                                  // setState makes it so that it's updated with the latest information
                                  setState(() {});
                                },
                                child: Icon(Icons.search))
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
