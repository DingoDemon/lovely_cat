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

  BuildingsPage();
}

class BuildingsState extends State<BuildingsPage> with WidgetsBindingObserver {
  List<MapEntry<BuildingExample, int>> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('dingo: ${state}');
  }

  @override
  Widget build(BuildContext context) {
    list = Application.gameContext.buildings.entries.toList();

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Card(
        color: Colors.brown[50],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Container(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                : Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return MaterialButton(
                          elevation: 20,
                          onPressed: () {
                            Navigator.push(
                                context,
                                HeroDialogRoute(
                                  builder: (BuildContext context) => Center(
                                        child: Card(
                                            child: BuildingView(index),
                                            elevation: 20,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14.0)))),
                                      ),
                                ));
                          },
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 5, right: 5),
                              height: 60,
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  getBuildName(list[index], true),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${EnumCovert().getBuildingName(list[index].key)} ',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontFamily: 'Miao'),
                                      ),
                                    ),
                                    flex: 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                      ' (${list[index].value})',
                                      style: TextStyle(fontFamily: 'Miao'),
                                    ),
                                  )
                                ],
                              )),
                        );
                      },
                      itemCount: list.length,
                    ),
                  ),
          ),
        )),
      ),
    );
  }

  BuildingsState();
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
                    fit: BoxFit.contain,
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

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black38;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    FadeTransition transition = FadeTransition(
      opacity:
          new CurvedAnimation(parent: animation, curve: Curves.easeOutCirc),
      child: child,
    );
    return transition;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => null;
}
