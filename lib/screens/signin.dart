import 'package:flutter/material.dart';
import 'package:open_mind/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    // Scaffold is the banner thingy at the top
    return Scaffold(
        appBar: AppBar(title: Text("OpenMind")),
        // Provides the sign-in options
        body: Center(
          child: GestureDetector(
            onTap: () {
              AuthMethods().signInWithGoogle(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Color(0xffDB4437),
              ),
              // Padding makes it so that the button is centered
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text(
                "Sign in with google",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ));
  }
}
