import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/widgets/navbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final image = NetworkImage(FirebaseAuth.instance.currentUser.photoURL);

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded),
            // we can add a link to an edit page here at another time
            // it could let a person change their about section
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: Ink.image(
                      image: image,
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                      child: InkWell(
                        // we can make it so it zooms the image in or makes it bigger like other apps
                        // but for now it'll be an empty onTap
                        onTap: () => {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              Text(
                FirebaseAuth.instance.currentUser.displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                FirebaseAuth.instance.currentUser.email,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // if we do implement a scoring system the first string can be replaced by a database element
              buildButton(context, '4.8', 'Conversation Rating'),
              Container(height: 48, child: VerticalDivider()),
              // a cool feature to implement in the future could be to keep track of how many chats a person has had
              buildButton(context, '35', 'Total Conversations'),
            ],
          ),
          const SizedBox(height: 48),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Just testing right now since I don\'t know what to type. '
                  'Just imagine that someone is describing themselves and their interests.',
                  style: TextStyle(fontSize: 16, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
