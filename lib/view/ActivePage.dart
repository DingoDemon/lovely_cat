import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';

import 'GamePage.dart';

class ActivePage extends AlertDialog {
  String tip;


  @override
  Widget build(BuildContext context) {
    if (!Application.gameContext.buildings
        .containsKey(BuildingExample.catmintField)) {
      tip = '去林子里采点猫薄荷回来吧';
    } else if (!Application.gameContext.buildings
        .containsKey(BuildingExample.chickenCoop)) {
      tip = '树枝制成的鸡窝，深受喵婊贝喜欢';
    }
    return AlertDialog(
      content: getWidget(context),
    );
  }

  Widget getWidget(BuildContext context) {
    switch (Application.gameContext.age) {
      case Age.Chaos:
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
                Container(
                  margin: EdgeInsets.only(top: 40, left: 15, right: 15),
                  child: RaisedButton(
                    child: Text("采集猫薄荷",
                        style: TextStyle(
                          fontFamily: 'Miao',
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    onPressed: () {
                      double value = Engine().pickSomeCatmint();
                      Fluttertoast.showToast(
                          msg:
                              "从林子里采集到里$value猫薄荷,${CatmintFieldBuilder.instance.getNecessaryTip(Application.gameContext)}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.tealAccent[700],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    color: Theme.of(context).accentColor,
                    splashColor: Colors.blueGrey,
                  ),
                )
              ],
            ),
          ),
        );
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
        return Container();
      default:
        return Container();
    }
  }
}
