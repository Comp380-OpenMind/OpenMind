import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/screens/home.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/services/auth.dart';

void main() async {
  dynamic color = Colors.indigo;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(color));
}

class MyApp extends StatefulWidget {
  final color;
  MyApp(this.color);
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //sets the main color of the whole application
        primarySwatch: widget.color,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          // if the user is already signed in then go straight to home, else have them sign in
          if (snapshot.hasData) {
            return Home();
          } else {
            return SignIn();
          }
        },
      ),
    );
  }
}
