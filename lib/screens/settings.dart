import 'package:open_mind/widgets/navbar.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                          title: Center(child: Text('Change App Color')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  colorButton(Colors.red),
                                  colorButton(Colors.pink),
                                  colorButton(Colors.purple),
                                  colorButton(Colors.deepPurple)
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
                          )));
                },
                child: Text('Change App Color'))));
  }
}
