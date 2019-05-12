import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

class InformationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InformationState();
  }
}

class InformationState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF80DEEA),
        body: Application.gameContext.events.isEmpty
            ? Center(
                child: Text("今日无事",
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 24,
                        fontFamily: 'Miao')),
              )
            : Column());
  }
}
