import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/active/ActivePage.dart';
import 'package:lovely_cats/view/gameFour/BuildingsPage.dart';
import 'package:lovely_cats/view/gameFour/CatsManagerPage.dart';
import 'package:lovely_cats/Callback.dart';
import 'package:lovely_cats/view/gameFour/InformationPage.dart';
import 'package:lovely_cats/view/gameFour/WorkbenchPage.dart';

class GamePage extends StatefulWidget {
  String firstPlay;

  GamePage(this.firstPlay);

  @override
  State<StatefulWidget> createState() {
    return GamePageStates();
  }
}

class GamePageStates extends State<GamePage>
    with TickerProviderStateMixin
    implements Callback {
  Widget pages;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Application.mTimerUtil.setOnTimerTickCallback((int tick) {
      Engine().primed();
    });
    pages = GamePageRow();
    Application.mTimerUtil.startTimer();
    Engine().registerCallback(this);
  }

  @override
  void dispose() {
    Engine().unregisterCallback(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Object> items = Application.gameContext.wareHouse.getShowItems();
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
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(FuncUtil().getGameTitle(Application.gameContext)),
            leading: items.length > 0 ? null : Text(''),
            centerTitle: true),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: pages,
          ),
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
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('images/dafu_erfu.png'),
                Container(
                    height: 600,
                    child: ListView.builder(
                      addRepaintBoundaries: true,
                      itemBuilder: (BuildContext context, int index) {
                        bool plus = Application.gameContext.wareHouse
                                .receiveInfo[items[index]] >=
                            0;
                        return Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                  EnumCovert().getEnumName(items[index]),
                                  style: TextStyle(
                                      color: EnumCovert()
                                          .getEnumShowColor(items[index]),
                                      fontFamily: 'Miao',
                                      fontSize: 16)),
                              alignment: Alignment.centerLeft,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    EnumCovert()
                                        .getResourceReceiveInfo(items[index]),
                                    style: TextStyle(
                                        color: EnumCovert()
                                            .getEnumShowColor(items[index]),
                                        fontFamily: 'Simple',
                                        fontSize: 16)),
                                Application.gameContext.wareHouse.receiveInfo
                                        .containsKey(items[index])
                                    ? Text(
                                        ' ${plus ? '+' : ''} ${Application.gameContext.wareHouse.receiveInfo[items[index]]} '
                                        '/s',
                                        style: TextStyle(
                                            color: EnumCovert()
                                                .getEnumShowColor(items[index]),
                                            fontFamily: 'Simple',
                                            fontSize: 16))
                                    : Text("")
                              ],
                            )
                          ],
                        );
                      },
                      itemCount: items.length,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void callBack() {
    setState(() {
      pages = GamePageRow();
    });
  }

  @override
  void receiveACat(Cat c) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('来了一只小喵喵:${c.dec}'),
      duration: Duration(seconds: 5),
    ));
  }

  @override
  void catLeave(Cat c) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('因为没有足够的猫薄荷${c.name} 离开了这里'),
      duration: Duration(seconds: 5),
    ));
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

class GamePageRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GamePageRowState();
  }
}

class GamePageRowState extends State<GamePageRow>
    with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag; //drag开始的offset
  double startDragPercentScroll; //开始拖动时候的值
  double finishDragScrollStart;
  double finishDragScrollEnd;
  AnimationController finishScrollController;
  Direction direction = Direction.LEFT;

  @override
  void initState() {
    super.initState();
    finishScrollController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(finishDragScrollStart, finishDragScrollEnd,
              finishScrollController.value);
        });
      });
  }

  @override
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _hStart,
      onHorizontalDragUpdate: _hUpdate,
      onHorizontalDragEnd: _hEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: getCards(),
        fit: StackFit.expand,
      ),
    );
  }

  getCard(int currentIndex, int cardsCount, double scrollPercent) {
    final double singleCardScrollPercent = scrollPercent / (1 / cardsCount);
    return FractionalTranslation(
      translation: Offset(currentIndex - singleCardScrollPercent, 0.0),
      child: getPage(currentIndex),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return BuildingsPage();
      case 1:
        return CatsManagerPage();
      case 2:
        return WorkbenchPage();
      case 3:
        return InformationPage();
      default:
        return Text("");
    }
  }

  List<Widget> getCards() {
    return [
      getCard(0, 4, scrollPercent),
      getCard(1, 4, scrollPercent),
      getCard(2, 4, scrollPercent),
      getCard(3, 4, scrollPercent)
    ];
  }

  _hStart(DragStartDetails startDetail) {
    startDrag = startDetail.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  _hUpdate(DragUpdateDetails updateDetail) {
    final Offset curDrag = updateDetail.globalPosition;
    final double dragTotal = curDrag.dx - startDrag.dx;
    final double singleCardPercent = dragTotal / context.size.width;
    if (dragTotal > 0) {
      direction = Direction.LEFT;
    } else {
      direction = Direction.RIGHT;
    }
    setState(() {
      scrollPercent = (startDragPercentScroll +
              (-singleCardPercent / Const.TOTAL_GAME_PAGE))
          .clamp(0.0, 1.0 - (1 / Const.TOTAL_GAME_PAGE));
    });
  }

  _hEnd(DragEndDetails endDetail) {
    finishDragScrollStart = scrollPercent;
    if (direction == Direction.LEFT) {
      finishDragScrollEnd = (scrollPercent * Const.TOTAL_GAME_PAGE).floor() /
          Const.TOTAL_GAME_PAGE;
    } else {
      finishDragScrollEnd = (scrollPercent * Const.TOTAL_GAME_PAGE).ceil() /
          Const.TOTAL_GAME_PAGE;
    }
    finishScrollController.forward(from: 0.0);
    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }
}

enum Direction { LEFT, RIGHT }
