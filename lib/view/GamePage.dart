import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'package:lovely_cats/view/gameFour/BuildingsPage.dart';
import 'package:lovely_cats/view/gameFour/CatsManagerPage.dart';
import 'package:lovely_cats/widget/GamePageDragger.dart';
import 'package:lovely_cats/view/gameFour/InformationPage.dart';
import 'package:lovely_cats/widget/PageReveal.dart';
import 'package:lovely_cats/view/gameFour/WorkbenchPage.dart';

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
    currentPage = getCurrentPage(activeIndex);
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
          currentPage = getCurrentPage(activeIndex);
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
        currentPage = getCurrentPage(activeIndex);
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
    print(currentPage.toString());
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.showToast(
            msg: "back",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Stack(
          children: <Widget>[
            currentPage,
            PageReveal(
              revealPercent: slidePercent,
              child: getCurrentPage(nextPageIndex),
            ),
            PageDragger(
              canDragLeftToRight: activeIndex > 0,
              canDragRightToLeft: activeIndex < 3,
              slideUpdateStream: this.slideUpdateStream,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {}),
      ),
    );
  }

  Widget getCurrentPage(int index) {
    switch (index) {
      case 0:
        return BuildingsPage();
      case 1:
        return CatsManagerPage();
      case 2:
        return WorkbenchPage();
      case 3:
        return InformationPage();
    }
  }
}

abstract class GamePageRefresh {

  void update();
}
