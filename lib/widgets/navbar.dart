import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/screens/home.dart';
import 'package:open_mind/services/auth.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/screens/settings.dart';
import 'package:open_mind/screens/profile.dart';
import 'package:open_mind/screens/search.dart';
import 'package:open_mind/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavBar extends StatelessWidget {
  userProfileImageGrabber() {
    if (Image.network(FirebaseAuth.instance.currentUser.photoURL) != null) {
      return Image.network(
        FirebaseAuth.instance.currentUser.photoURL,
        fit: BoxFit.cover,
        width: 90,
        height: 90,
      );
    } else {
      return Icon(Icons.account_circle, size: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(FirebaseAuth.instance.currentUser.displayName),
            accountEmail: Text(FirebaseAuth.instance.currentUser.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: userProfileImageGrabber()),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()))
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OpenMindProfile()))
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OpenMindSearch()))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OpenMindSettings()))
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              })
            },
          ),
        ],
      ),
    );
  }
}
