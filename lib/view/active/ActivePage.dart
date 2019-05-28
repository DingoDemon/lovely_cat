import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'ChaosActive.dart';
import 'StoneActive.dart';

class ActivePage extends AlertDialog {
  @override
  Widget build(BuildContext context) {
    return MyDialog();
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return getWidget(context);
  }

  Widget getWidget(BuildContext context) {
    switch (Application.gameContext.age) {
      case Age.Chaos:
        return ChaosDialog();
      case Age.Bronze:
        return Container();
      case Age.Feudal:
        return Container();
      case Age.Industry:
        return Container();
      case Age.Iron:
        return Container();
      case Age.Modern:
        return Container();
      case Age.Space:
        return Container();
      case Age.Stone:
        return StoneDialog();
      default:
        return Container();
    }
  }
}
