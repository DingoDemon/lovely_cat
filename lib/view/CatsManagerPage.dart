import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';

class CatsManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatsManagerState();
  }
}

class CatsManagerState extends State<CatsManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF9FA8DA),
        appBar: AppBar(
          title: Text(""),
        ),
        body: Application.gameContext.cats.isEmpty
            ? Center(
                child: Text("没有喵喵在此驻足"),
              )
            : Column());
  }
}
