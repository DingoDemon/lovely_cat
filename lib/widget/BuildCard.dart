import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/gameFour/BuildingsPage.dart';

class BuildingView extends AlertDialog {
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

class _BuildCardStates extends State<BuildCard> {
  int index;
  AbstractBuilder builder;

  _BuildCardStates(this.index);

  @override
  Widget build(BuildContext context) {
    AbstractBuilder builder = FuncUtil().getBuilder(
        Application.gameContext.buildings.entries.toList()[index].key);

    ///所需资源
    List<MapEntry<Object, double>> list =
        builder.buildResource.entries.toList();
    return Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: getImage(),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(10))),
              Hero(
                  tag: '${Application.gameContext.buildings.entries
                      .toList()[index].key}',
                  child: getBuildName(Application.gameContext.buildings.entries
                      .toList()[index])),
              Container(
                child: Text(
                  builder.getDescribe(),
                  style: TextStyle(fontFamily: 'Simple', fontSize: 16),
                ),
                margin: EdgeInsets.all(20),
                width: 180,
              ),
              Container(
                width: 180,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      '${EnumCovert().getEnumName(list[index].key)} :'
                      ' ${Application.gameContext.wareHouse.getItemReserves(list[index].key)} / '
                      '${builder.buildResource[list[index].key]}',
                      style: TextStyle(
                          color: EnumCovert().getEnumShowColor(list[index].key),
                          fontSize: 14),
                    );
                  },
                  itemCount: list.length,
                ).build(context),
              )
            ],
          ),
        ));
  }
}

AssetImage getImage() {
  return AssetImage('images/dafu_erfu${FuncUtil().getRandom(2)}.png');
}
