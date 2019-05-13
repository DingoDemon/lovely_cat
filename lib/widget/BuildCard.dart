import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/gameFour/BuildingsPage.dart';

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
    List<MapEntry<Object, double>> list =
        builder.buildResource.entries.toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/we.png"),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(10))),
        Hero(
          tag: "Building",
          child: getBuildName(
              Application.gameContext.buildings.entries.toList()[index]),
        ),
        Container(
          child:
              ListView.builder(itemBuilder: (BuildContext context, int index) {
            return Text('${EnumCovert().getEnumName(list[index].key)}  ');
          }),
        )
      ],
    );
  }
}

Image getImage() {
  return Image.asset('/images/dafuerfu${FuncUtil().getRandom(2)}.png');
}
