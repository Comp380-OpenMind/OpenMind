import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/helperfunctions/sharedpref_helper.dart';
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

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserbyUserName(searchUsernameEditingController.text);

    setState(() {});
  }

  // returns all the information for the person the user searched
  Widget searchListUserTile({String profileUrl, name, username, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username]
        };

        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              profileUrl,
              height: 30,
              width: 30,
            ),
          ),
          SizedBox(width: 12),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(name), Text(email)])
        ],
      ),
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
                      profileUrl: ds.data()["imgUrl"],
                      name: ds.data()["name"],
                      email: ds.data()["email"],
                      username: ds.data()["username"]);
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
                isSearching ? searchUsersList() : chatRoomsList(),

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
                          subtitle: Text(
                            'Gun Control info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Abortion info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Religious Freedom info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Animal Rights info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Vaccines info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Privacy Rights info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ExpansionTile(
                          trailing: SizedBox.shrink(),
                          title: Text('Global Climate Change',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(
                            'Global Climate Change info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Evolution info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Marriage Equality...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
                          subtitle: Text(
                            'Transgender Rights info...',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am for this topic',
                                  textAlign: TextAlign.center,
                                )),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                                onTap: () {},
                                title: Text(
                                  'I am against this topic',
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
