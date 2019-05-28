import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';

import '../GamePage.dart';

class StoneDialog extends StatefulWidget {
  @override
  _StoneDialogState createState() => new _StoneDialogState();
}

class _StoneDialogState extends State<StoneDialog> {
  String tip;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: getWidget(context),
    );
  }

  Widget getWidget(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: double.infinity,
        height: 500,
        margin: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "Active",
              child: getShareImage(false),
            ),
            Container(
              margin: EdgeInsets.only(top: 60, left: 15, right: 15),
              child: Text(
                tip,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontFamily: 'Simple'),
              ),
            ),
            getChildren(),
          ],
        ),
      ),
    );
  }

  Widget getChildren() {}
}
