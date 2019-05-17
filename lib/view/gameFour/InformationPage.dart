import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

import '../GamePage.dart';

class InformationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InformationState();
  }

  InformationPage();
}

class InformationState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.yellow[50],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Container(
            color: Colors.teal[100],
            child: Application.gameContext.events.isEmpty
                ? Center(
                    child: Text("今日无事",
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 24,
                            fontFamily: 'Miao')),
                  )
                : Column()));
  }
}
