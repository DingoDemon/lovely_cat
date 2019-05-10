import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';

class ActivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getWidget();
  }

  Widget getWidget() {
    switch (Application.gameContext.age) {
      case Age.Chaos:
        return Hero(
          tag: "Active",
          child: Container(
            width: Application.size.width,
            height: Application.size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/dafu_erfu.png"), fit: BoxFit.cover)),
          ),
        );
      case Age.Bronze:
        return Container();
      case Age.Feudal:
        return Container();
      case Age.Industry:
        return Container();
      case Age.Iron:
        return Container();
      case Age.Modern:
        return Container();
      case Age.Space:
        return Container();
      case Age.Stone:
        return Container();
      default:
        return Container();
    }
  }
}
