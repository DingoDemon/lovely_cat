import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'package:lovely_cats/route/routes.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelComeStates();
  }
}

class WelComeStates extends State<WelcomePage> with TickerProviderStateMixin {
  AnimationController gifAnimationController;
  AnimationController buttonController;

  Animation<double> alphaAnimation;
  Animation<double> scaleAnimation;
  Animation<double> buttonTextScaleAnimation;
  Animation<Color> colorTween;

  bool hasFile;
  Step step;

  Widget current;

  String buttonText = "  当然喵！\n (=￣ω￣=)'";

  @override
  void initState() {
    super.initState();
    gifAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    buttonController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    alphaAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(gifAnimationController);
    Future.delayed(Duration(seconds: 2), () {
      getContext();
    });

    step = Step.One;

    final Animation curve =
        new CurvedAnimation(parent: buttonController, curve: ShakeCurve());

    scaleAnimation = Tween(begin: 120.0, end: 0.0).animate(curve);

    scaleAnimation.addListener(() {
      setState(() {
        if (scaleAnimation.value > 130) {
          buttonText = "那么，开始了 \n (*˘︶˘*).。.:*♡";
        }
      });
    });

    scaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (Application.gameContext == null) {
          Context game = new Context();
          Application.gameContext = game;
        }
        Navigator.pop(context);
        Application.router.navigateTo(
          context,
          '/game/true',
          transition: TransitionType.fadeIn,
          transitionDuration: Const.oneSec,
        );
      }
    });

    final Animation textSizeAni = new CurvedAnimation(
        parent: buttonController, curve: Curves.bounceInOut);

    buttonTextScaleAnimation =
        Tween(begin: 14.0, end: 0.0).animate(textSizeAni);
    colorTween = ColorTween(
      begin: Colors.white,
      end: Colors.blue,
    ).animate(buttonController);

    buttonTextScaleAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    gifAnimationController.dispose();
    buttonController.dispose();
    super.dispose();
  }

  void changePage(bool b) {
    setState(() {
      buttonText = "  继续喵！\n ヾ(^▽^*)))'";
      this.step = Step.Two;
      this.hasFile = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    Application.size = MediaQuery.of(context).size;

    if (step == Step.One) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Image(
            image: AssetImage("images/welcome.gif"),
          ),
        ),
      );
    } else {
      if (hasFile) {
        gifAnimationController.forward();
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("喵唔，你回来啦"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.all(30),
                  child: FadeTransition(
                    opacity: alphaAnimation,
                    child: Image(
                      image: AssetImage("images/doubt.gif"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      '${FuncUtil().getGameTitle(Application.gameContext)},${Application.gameContext.cats.length} 只小猫',
                      style: TextStyle(fontFamily: 'Miao', fontSize: 24),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: new Container(
                      margin: EdgeInsets.only(bottom: 30),
                      height:
                          scaleAnimation.value < 0 ? 0 : scaleAnimation.value,
                      width:
                          scaleAnimation.value < 0 ? 0 : scaleAnimation.value,
                      child: RaisedButton(
                        child: Text(buttonText,
                            style: TextStyle(
                                fontFamily: 'Miao',
                                fontSize: buttonTextScaleAnimation.value)),
                        color: Theme.of(context).accentColor,
                        elevation: 4.0,
                        textColor: Colors.white,
                        splashColor: Colors.blueGrey,
                        onPressed: () {
                          buttonController.forward();
                        },
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      } else {
        gifAnimationController.forward();
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("喵唔，糟糕！"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.all(30),
                  child: FadeTransition(
                    opacity: alphaAnimation,
                    child: Image(
                      image: AssetImage("images/doubt.gif"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      '喵喵好像没有找到存档，是否开始新一轮的喵喵纪元',
                      style: TextStyle(fontFamily: 'Miao', fontSize: 24),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: new Container(
                      margin: EdgeInsets.only(bottom: 30),
                      height:
                          scaleAnimation.value < 0 ? 0 : scaleAnimation.value,
                      width:
                          scaleAnimation.value < 0 ? 0 : scaleAnimation.value,
                      child: RaisedButton(
                        child: Text(buttonText,
                            style: TextStyle(
                                fontFamily: 'Miao',
                                fontSize: buttonTextScaleAnimation.value)),
                        color: Theme.of(context).accentColor,
                        elevation: 4.0,
                        textColor: Colors.white,
                        splashColor: Colors.blueGrey,
                        onPressed: () {
                          buttonController.forward();
                        },
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      }
    }
  }

  void getContext() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.get(Const.CONTEXT);
    if (json == null) {
      changePage(false);
    } else {
      try {
        Context context = Context.fromJSON(jsonDecode(json));
        Application.gameContext = context;
        changePage(context != null);
      } on Exception {
        return null;
      }
    }
  }
}

enum Step { One, Two }

SlideTransition createTransition(Animation<double> animation, Widget child) {
  return new SlideTransition(
    position: new Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation),
    child: child,
  );
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.6) {
      return 2.5 * math.pow((t - 0.6), 2) - 0.9;
    } else {
      return 11.875 * math.pow((t - 0.6), 2) - 0.9;
    }
  }
}
