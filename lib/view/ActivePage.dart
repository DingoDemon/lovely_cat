import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';

import 'GamePage.dart';

class ActivePage extends AlertDialog {
  String tip;

  @override
  Widget build(BuildContext context) {
    if (!Application.gameContext.buildings
        .containsKey(BuildingExample.catmintField)) {
      tip = '去林子里采点猫薄荷回来吧,只要采到足够的猫薄荷,就能种一片猫薄荷田';
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
                  margin: EdgeInsets.only(top: 40, left: 15, right: 15),
                  child: Text(
                    tip,
                    style: TextStyle(fontSize: 18, color: Colors.grey[800],fontFamily: 'Simple'),
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
