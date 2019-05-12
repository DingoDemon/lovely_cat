import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';

import 'GamePage.dart';

class ActivePage extends AlertDialog {
  String tip;
  ChaosStep chaosStep;

  @override
  Widget build(BuildContext context) {
    switch (Application.gameContext.age) {
      case Age.Chaos:
        if (!Application.gameContext.buildings
            .containsKey(BuildingExample.catmintField)) {
          tip = '去林子里采点猫薄荷回来吧';
          chaosStep = ChaosStep.one;
        } else if (Application.gameContext.buildings
                .containsKey(BuildingExample.catmintField) &&
            !Application.gameContext.buildings
                .containsKey(BuildingExample.chickenCoop)) {
          tip = '树枝制成的鸡窝，能吸引新的喵婊贝';
          chaosStep = ChaosStep.two;
        }
        break;
      case Age.Bronze:
        break;
      case Age.Feudal:
        break;
      case Age.Industry:
        break;
      case Age.Iron:
        break;
      case Age.Modern:
        break;
      case Age.Space:
        break;
      case Age.Stone:
        break;
      default:
        break;
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
                getChaosActive(context, chaosStep)
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

  Widget getChaosActive(BuildContext context, ChaosStep step) {
    if (step == ChaosStep.one) {
      return Container(
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
      );
    } else {
      bool makeBranchEnable =
          Application.gameContext.wareHouse.foods[FoodResource.catmint] >= 20;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
          ),
          Container(
            margin: EdgeInsets.only(top: 40, left: 15, right: 15),
            child: RaisedButton(
              child: Text("将20个猫薄荷碾成树枝",
                  style: TextStyle(
                    fontFamily: 'Miao',
                    fontSize: 14,
                    color: Colors.white,
                  )),
              onPressed: makeBranchEnable
                  ? () {
                bool success = Engine().makeCatmintToBranch();
                Fluttertoast.showToast(
                    msg: success ? "碾压完成，注意余粮哦" : "碾压失败",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.tealAccent[700],
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
                  : null,
              color: Theme.of(context).accentColor,
              splashColor: Colors.blueGrey,
            ),
          )
        ],
      );
    }
  }
}

enum ChaosStep { one, two }

