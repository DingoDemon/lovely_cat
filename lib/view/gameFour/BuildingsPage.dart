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
                  return MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          HeroDialogRoute(
                              builder: (BuildContext context) => Center(
                                    child: BuildingView(index),
                                  )));
                    },
                    child: Container(
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            noHero
                                ? Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(EnumCovert()
                                              .getBuildIconPath(
                                                  list[index].key)),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)))
                                : getBuildName(list[index], true),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  '${EnumCovert().getBuildingName(list[index].key)} ',
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                              ),
                              flex: 5,
                            ),
                            Text(' (${list[index].value})')
                          ],
                        )),
                  );
                },
                itemCount: list.length,
              ));
  }
}

Hero getBuildName(MapEntry<BuildingExample, int> item, bool isFirstPage) {
  return Hero(
      tag: '${item.key}',
      child: isFirstPage
          ? Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(EnumCovert().getBuildIconPath(item.key)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10)))
          : Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(EnumCovert().getBuildIconPath(item.key)),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(10))));
}
