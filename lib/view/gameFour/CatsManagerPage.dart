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
    int lazy = Application.gameContext.cats.length -
        Application.gameContext.catProfession.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text("这里一共有$count只喵喵",
              style: TextStyle(
                  color: Colors.purple[200], fontSize: 20, fontFamily: 'Miao')),
        ),
        Text("$lazy只喵喵在睡懒觉，快把${lazy > 1 ? '它们' : '它'}叫醒",
            style: TextStyle(
                color: Colors.purple[200], fontSize: 14, fontFamily: 'Miao')),
        ListView.builder(itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
            height: 60,
            width: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: Row(
              children: <Widget>[

              ],
            ),
          );
        })
      ],
    );
  }
}
