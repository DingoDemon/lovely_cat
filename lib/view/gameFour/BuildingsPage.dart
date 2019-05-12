import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

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
                  bool couldBuild = FuncUtil()
                      .getBuilder(list[index].key)
                      .couldBuild(Application.gameContext);
                  return MaterialButton(
                    onPressed: couldBuild
                        ? () {
                            FuncUtil()
                                .getBuilder(list[index].key)
                                .build(Application.gameContext);
                            setState(() {});
                          }
                        : null,
                    child: Text(
                        '${EnumCovert().getBuildingName(list[index].key)} (${list[index].value}) '),
                  );
                },
                itemCount: list.length,
              ));
  }
}
