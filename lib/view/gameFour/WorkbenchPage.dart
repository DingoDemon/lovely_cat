import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

class WorkbenchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WorkbenchState();
  }
}

class WorkbenchState extends State<WorkbenchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFBBDEFB),
        body: Application.gameContext.age == Age.Chaos
            ? Center(
                child: Text(
                  "喵喵的思想还在混沌中",
                  style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 24,
                      fontFamily: 'Miao'),
                ),
              )
            : Column());
  }
}
