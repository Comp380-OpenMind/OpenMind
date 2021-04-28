import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:open_mind/screens/home.dart';
import 'package:open_mind/screens/signin.dart';
import 'package:open_mind/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //sets the main color of the whole application
        primarySwatch: Colors.indigo,
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
