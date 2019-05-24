import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/GamePage.dart';

class CatsManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatsManagerState();
  }

  CatsManagerPage();
}

class CatsManagerState extends State<CatsManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Card(
          color: Colors.yellow[50],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Container(
              padding: EdgeInsets.all(8),
              child: Application.gameContext.cats.isEmpty
                  ? Center(
                      child: Text(
                      "没有喵喵在此驻足",
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 24,
                          fontFamily: 'Miao'),
                    ))
                  : Container(
                      child: getWidget(),
                    ))),
    );
  }

  Widget getWidget() {
    int count = Application.gameContext.cats.length;
    if (Application.gameContext.age == Age.Chaos) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("农夫喵"),
        ],
      );
    } else {
      return Text("");
    }
  }
}
