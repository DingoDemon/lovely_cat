import 'dart:async';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/active/ActivePage.dart';
import 'package:lovely_cats/view/gameFour/BuildingsPage.dart';
import 'package:lovely_cats/view/gameFour/CatsManagerPage.dart';
import 'package:lovely_cats/widget/GamePageDragger.dart';
import 'package:lovely_cats/view/gameFour/InformationPage.dart';
import 'package:lovely_cats/widget/PageReveal.dart';
import 'package:lovely_cats/view/gameFour/WorkbenchPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class GamePage extends StatefulWidget {
  String firstPlay;

  GamePage(this.firstPlay);

  @override
  State<StatefulWidget> createState() {
    return GamePageStates();
  }
}

class GamePageStates extends State<GamePage> with TickerProviderStateMixin {
  int activeIndex = 0;
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;
  SlideDirection slideDirection = SlideDirection.none;
  int nextPageIndex = 0;
  int waitingNextPageIndex = -1;

  double slidePercent = 0.0;
  Widget currentPage;

  GamePageStates() {
    slideUpdateStream = new StreamController<SlideUpdate>();
    slideUpdateStream.stream.listen((SlideUpdate event) {
      if (mounted) {
        setState(() {
          if (event.updateType == UpdateType.dragging) {
            slideDirection = event.direction;
            slidePercent = event.slidePercent;

            if (slideDirection == SlideDirection.leftToRight) {
              nextPageIndex = activeIndex - 1;
            } else if (slideDirection == SlideDirection.rightToLeft) {
              nextPageIndex = activeIndex + 1;
            } else {
              nextPageIndex = activeIndex;
            }
          } else if (event.updateType == UpdateType.doneDragging) {
            if (slidePercent > 0.5) {
              animatedPageDragger = new AnimatedPageDragger(
                slideDirection: slideDirection,
                transitionGoal: TransitionGoal.open,
                slidePercent: slidePercent,
                slideUpdateStream: slideUpdateStream,
                vsync: this,
              );
            } else {
              animatedPageDragger = new AnimatedPageDragger(
                slideDirection: slideDirection,
                transitionGoal: TransitionGoal.close,
                slidePercent: slidePercent,
                slideUpdateStream: slideUpdateStream,
                vsync: this,
              );

              waitingNextPageIndex = activeIndex;
            }

            animatedPageDragger.run();
          } else if (event.updateType == UpdateType.animating) {
            slideDirection = event.direction;
            slidePercent = event.slidePercent;
          } else if (event.updateType == UpdateType.doneAnimating) {
            if (waitingNextPageIndex != -1) {
              nextPageIndex = waitingNextPageIndex;
              waitingNextPageIndex = -1;
            } else {
              activeIndex = nextPageIndex;
            }

            slideDirection = SlideDirection.none;
            slidePercent = 0.0;

            animatedPageDragger.dispose();
          }
          currentPage = getCurrentPage(activeIndex,false);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Application.mTimerUtil.setOnTimerTickCallback((int tick) {
      Engine().primed();
      setState(() {
        currentPage = getCurrentPage(activeIndex,false);
      });
    });
    Application.mTimerUtil.startTimer();
  }

  @override
  void dispose() {
    slideUpdateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Object> items = Application.gameContext.wareHouse.getItems();
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.showToast(
            msg: "back",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.amber,
        appBar: AppBar(
            title: Text(FuncUtil().getGameTitle(Application.gameContext)),
            leading: items.length > 0 ? null : Text(''),
            centerTitle: true),
        body: Stack(
          children: <Widget>[
            currentPage,
            PageReveal(
              revealPercent: slidePercent,
              child: getCurrentPage(nextPageIndex, true),
            ),
            PageDragger(
              canDragLeftToRight: activeIndex > 0,
              canDragRightToLeft: activeIndex < 3,
              slideUpdateStream: this.slideUpdateStream,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                HeroDialogRoute(
                    builder: (BuildContext context) => Center(
                          child: ActivePage(),
                        )));
          },
          child: getShareImage(true),
          elevation: 15,
          heroTag: "Active",
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('images/dafu_erfu.png'),
              Container(
                  height: 600,
                  child: ListView.builder(
                    addRepaintBoundaries: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(EnumCovert().getEnumName(items[index]),
                          style: TextStyle(
                              color:
                                  EnumCovert().getEnumShowColor(items[index])));
                    },
                    itemCount: items.length,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCurrentPage(int index, bool withoutHero) {
    switch (index) {
      case 0:
        return BuildingsPage(withoutHero);
      case 1:
        return CatsManagerPage();
      case 2:
        return WorkbenchPage();
      case 3:
        return InformationPage();
      default:
        return null;
    }
  }
}

Widget getShareImage(bool isFirstPage) {
  if (isFirstPage) {
    return Container(
        decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("images/we.png"),
        fit: BoxFit.cover,
      ),
      shape: BoxShape.circle,
    ));
  } else {
    return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/we.png"),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(10)));
  }
}

abstract class GamePageRefresh {
  void update();
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
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => null;
}
