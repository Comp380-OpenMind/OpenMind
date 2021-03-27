import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/services/auth.dart';
import 'package:open_mind/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  Stream usersStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserbyUserName(searchUsernameEditingController.text);
    setState(() {});
  }

  // returns all the information for the person the user searched
  Widget searchListUserTile(String profileUrl, name, email) {
    return Row(
      children: [
        Image.network(
          profileUrl,
          height: 30,
          width: 30,
        ),
        SizedBox(width: 12),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(name), Text(email)])
      ],
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // A DocumentSnapshot contains data read from a document in your Cloud Firestore database
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchListUserTile(
                      ds["imgUrl"], ds["name"], ds["email"]);
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
                            // on back button tap
                            onTap: () {
                              // makes the back arrow disappear when not searching, and clears text box when arrow is pressed
                              isSearching = false;
                              searchUsernameEditingController.text = "";
                              // setState makes it so that it's updated with the latest information
                              setState(() {});
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
                              controller: searchUsernameEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "username"),
                            )),
                            GestureDetector(
                                //when the search button is tapped
                                onTap: () {
                                  // will only execute if there is text in the search bar
                                  if (searchUsernameEditingController.text !=
                                      "") {
                                    onSearchBtnClick();
                                  }
                                },
                                child: Icon(Icons.search))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // if the user is searching show the users list, if not then show the chat rooms list
                isSearching ? searchUsersList() : chatRoomsList()
              ],
            )));
  }
}
