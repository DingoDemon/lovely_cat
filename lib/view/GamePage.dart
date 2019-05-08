import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GamePageStates();
  }
}

class GamePageStates extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.showToast(
            msg: "back",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Text("123"),
      ),
    );
  }
}
