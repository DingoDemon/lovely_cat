import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

import '../GamePage.dart';

class WorkbenchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WorkbenchState();
  }
}

class WorkbenchState extends State<WorkbenchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: Card(
            color: Color(0xffc7ffff),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Container(
                child: Application.gameContext.age == Age.Chaos
                    ? Center(
                        child: Text(
                          "喵喵的思想还在混沌中",
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 24,
                              fontFamily: 'Miao'),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "${EnumCovert().getAgeName(Application.gameContext.age)}",
                              style: TextStyle(
                                  color: Colors.lime[300],
                                  fontSize: 20,
                                  fontFamily: 'Miao'))
                        ],
                      ))));
  }
}
