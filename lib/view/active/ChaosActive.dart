import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';

import '../GamePage.dart';

class ChaosDialog extends StatefulWidget {
  @override
  _ChaosDialogState createState() => new _ChaosDialogState();
}

class _ChaosDialogState extends State<ChaosDialog> {
  String tip;
  ChaosStep chaosStep;
  bool makeBranchEnable;

  @override
  Widget build(BuildContext context) {
    makeBranchEnable = Application.gameContext.wareHouse
        .resourcesEnough({FoodResource.catmint: 20});
    if (!Application.gameContext.buildings
        .containsKey(BuildingExample.catmintField)) {
      tip = '去林子里采点猫薄荷回来吧';
      chaosStep = ChaosStep.one;
    } else if (Application.gameContext.buildings
            .containsKey(BuildingExample.catmintField) &&
        (!Application.gameContext.buildings
                .containsKey(BuildingExample.chickenCoop) ||
            Application.gameContext.buildings[BuildingExample.chickenCoop] ==
                0)) {
      tip = '做一点鸡窝把,树枝制成的鸡窝，能吸引新的喵宝贝';
      chaosStep = ChaosStep.two;
    } else {
      tip = '建造更多的鸡窝,吸引更多的喵喵';
      chaosStep = ChaosStep.three;
    }
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
            getChildren(chaosStep),
          ],
        ),
      ),
    );
  }

  Widget getChildren(ChaosStep s) {
    if (s == ChaosStep.one) {
      return Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
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
                msg: "从林子里采集到里$value猫薄荷",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.tealAccent[700],
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          },
          color: Theme.of(context).accentColor,
          splashColor: Colors.blueGrey,
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
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
                    msg: "从林子里采集到里$value猫薄荷",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.tealAccent[700],
                    textColor: Colors.white,
                    fontSize: 16.0);
                setState(() {});
              },
              color: Theme.of(context).accentColor,
              splashColor: Colors.blueGrey,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
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
                      setState(() {});
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

enum ChaosStep { one, two, three }
