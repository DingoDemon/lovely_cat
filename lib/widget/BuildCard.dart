import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/gameFour/BuildingsPage.dart';

import 'Callback.dart';

// ignore: must_be_immutable
class BuildingView extends Dialog {
  int index;

  BuildingView(this.index);

  @override
  Widget build(BuildContext context) {
    return BuildCard(index);
  }
}

class BuildCard extends StatefulWidget {
  int index;

  @override
  State<StatefulWidget> createState() {
    return _BuildCardStates(index);
  }

  BuildCard(this.index);
}

class _BuildCardStates extends State<BuildCard> implements Callback {
  int index;
  AbstractBuilder builder;

  _BuildCardStates(this.index);

  @override
  void initState() {
    Engine().registerCallback(this);
    super.initState();
  }

  @override
  void dispose() {
    Engine().unregisterCallback(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AbstractBuilder builder = FuncUtil().getBuilder(
        Application.gameContext.buildings.entries.toList()[index].key);

    ///所需资源
    List<MapEntry<Object, double>> list =
        builder.buildNeedResource(Application.gameContext).entries.toList();
    return Material(
      elevation: 5,
      type: MaterialType.transparency,
      child: Container(
        color: Colors.white,
        width: 300,
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getBuildName(
                Application.gameContext.buildings.entries.toList()[index]),
            Container(
              child: Text(
                builder.getDescribe(),
                style: TextStyle(fontFamily: 'Miao', fontSize: 16),
              ),
              margin: EdgeInsets.only(top: 20, left: 15, right: 15),
              width: double.infinity,
            ),
            Container(
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    child: Text(
                      '${EnumCovert().getEnumName(list[index].key)} :'
                      ' ${Application.gameContext.wareHouse.getItemReserves(list[index].key)} / '
                      '${builder.buildNeedResource(Application.gameContext)[list[index].key]}',
                      style: TextStyle(
                          color: EnumCovert().getEnumShowColor(list[index].key),
                          fontSize: 14,
                          fontFamily: 'Miao'),
                    ),
                  );
                },
                itemCount: list.length,
              ).build(context),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: MaterialButton(
                color: builder.couldBuild(Application.gameContext)
                    ? Colors.blue
                    : Colors.grey[500],
                onPressed: builder.couldBuild(Application.gameContext)
                    ? () {
                        builder.build(Application.gameContext);
                        setState(() {});
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    builder.couldBuild(Application.gameContext)
                        ? "建造"
                        : "资源还不够呢，加油收集吧",
                    style: TextStyle(
                        fontFamily: 'Miao',
                        fontSize: 20,
                        color: builder.couldBuild(Application.gameContext)
                            ? Colors.grey[50]
                            : Colors.deepOrange[600]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void callBack() {
    setState(() {});
  }

  @override
  void receiveACat(Cat c) {}

  @override
  void catLeave(Cat c) {
  }
}
