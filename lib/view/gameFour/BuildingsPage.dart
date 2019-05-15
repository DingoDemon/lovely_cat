import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/widget/BuildCard.dart';

import '../GamePage.dart';

class BuildingsPage extends StatefulWidget {
  bool noHero;

  @override
  State<StatefulWidget> createState() {
    return BuildingsState(noHero);
  }

  BuildingsPage(this.noHero);
}

class BuildingsState extends State<BuildingsPage> {
  bool noHero;

  BuildingsState(this.noHero);

  List<MapEntry<BuildingExample, int>> list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    list = Application.gameContext.buildings.entries.toList();

    return Container(
        color: Color(0xFFFFF59D),
        child: list.isEmpty
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
                          _navigateToBuildCard(context, index);
                        },
                        child: noHero
                            ? Text(
                                '${EnumCovert().getBuildingName(list[index].key)} (${list[index].value}) ')
                            : getBuildName(list[index]),
                      ),
                    ),
                  );
                },
                itemCount: list.length,
              ));
  }

  void _navigateToBuildCard(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder<BuildingView>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return BuildingView(index);
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

Hero getBuildName(MapEntry<BuildingExample, int> item) {
  return Hero(
    child: Text('${EnumCovert().getBuildingName(item.key)} (${item.value}) '),
    tag: '${item.key}',
  );
}
