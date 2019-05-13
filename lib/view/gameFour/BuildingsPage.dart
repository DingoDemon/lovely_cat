import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/widget/BuildCard.dart';

import '../GamePage.dart';

class BuildingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuildingsState();
  }
}

class BuildingsState extends State<BuildingsPage> {
  List<MapEntry<BuildingExample, int>> list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    list = Application.gameContext.buildings.entries.toList();

    return Scaffold(
        backgroundColor: Color(0xFFFFF59D),
        body: Application.gameContext.buildings.isEmpty
            ? Center(
                child: Text(
                  "这里一片荒凉",
                  style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 24,
                      fontFamily: 'Miao'),
                ),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 44,
                    width: 80,
                    child: Center(
                      child: MaterialButton(
                        color: Colors.lightBlueAccent[400],
                        elevation: 8,
                        onPressed: () {
                          Navigator.push(
                              context,
                              HeroDialogRoute(
                                  builder: (BuildContext context) => Center(
                                        child: BuildCard(index),
                                      )));
                        },
                        child: getBuildName(list[index]),
                      ),
                    ),
                  );
                },
                itemCount: list.length,
              ));
  }
}

Text getBuildName(MapEntry<BuildingExample, int> item) {
  return Text('${EnumCovert().getBuildingName(item.key)} (${item.value}) ');
}
