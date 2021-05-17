import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_mind/helperfunctions/sharedpref_helper.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/services/database.dart';
import 'package:open_mind/widgets/navbar.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  Stream usersStream;
  String myUserName;
  colorButton(color) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(Size(50, 50)),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp(color)));
      },
      elevation: 2.0,
      fillColor: color,
      padding: EdgeInsets.all(20),
      shape: CircleBorder(),
    );
  }

  colorRow(List colors) {
    final children = <Widget>[];
    for (var i = 0; i < colors.length; i++) {
      children.add(
        colorButton(colors[i]),
      );
      children.add(Divider(thickness: 2.5));
    }
    return new Row(
      children: children,
    );
  }

  colorWidget() {
    return AlertDialog(
        title: Center(child: Text('Change App Color')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorRow(
                    [Colors.red, Colors.pink, Colors.purple, Colors.deepPurple])
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorButton(Colors.indigo),
                colorButton(Colors.blue),
                colorButton(Colors.lightBlue),
                colorButton(Colors.cyan),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorButton(Colors.teal),
                colorButton(Colors.green),
                colorButton(Colors.lime),
                colorButton(Colors.yellow),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorButton(Colors.amber),
                colorButton(Colors.orange),
                colorButton(Colors.brown),
                colorButton(Colors.blueGrey),
              ],
            )
          ],
        ));
  }

  Widget deletePopup() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Warning!", textAlign: TextAlign.center),
              content: Text(
                "Are you sure you want to delete your account?",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("no")),
                TextButton(
                    onPressed: () {
                      String userID = FirebaseAuth.instance.currentUser.uid;
                      DatabaseMethods().removeUserFromDB(userID);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text("yes")),
              ],
              elevation: 24,
            ),
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    bool value = false;
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: 'Section',
              tiles: [
                SettingsTile(
                  title: 'Language',
                  subtitle: 'English',
                  leading: Icon(Icons.language),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: 'Information',
                  subtitle: 'View info',
                  leading: Icon(Icons.account_box),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Delete account',
                  leading: Icon(Icons.delete),
                  onPressed: (BuildContext context) {
                    deletePopup();
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Appearance',
              tiles: [
                SettingsTile(
                  title: 'Theme color',
                  subtitle: 'Change color',
                  leading: Icon(Icons.invert_colors),
                  onPressed: (BuildContext context) {
                    return showDialog(
                        context: context, builder: (ctx) => colorWidget());
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Dark mode',
                  leading: Icon(Icons.wb_incandescent),
                  switchValue: value,
                  onToggle: (bool value) {},
                ),
              ],
            ),
          ],
        ));
  }
}
