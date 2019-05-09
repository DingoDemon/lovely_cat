import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';

class BuildingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuildingsState();
  }
}

class BuildingsState extends State<BuildingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFB39DDB),
        appBar: AppBar(
          title: Text(""),
        ),
        body: Application.gameContext.buildings.isEmpty
            ? Center(
                child: Text("这里一片荒凉"),
              )
            : Column());
  }
}
