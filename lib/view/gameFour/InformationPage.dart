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
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: Card(
            color: Colors.cyan[50],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Container(
                child: true
                    ? Center(
                        child: Text("今日无事",
                            style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: 24,
                                fontFamily: 'Miao')),
                      )
                    : Column())));
  }
}
