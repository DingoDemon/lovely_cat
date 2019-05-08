import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Const.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:gif_ani/gif_ani.dart';
import 'package:lovely_cats/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelComeStates();
  }
}

class WelComeStates extends State<WelcomePage> with TickerProviderStateMixin {
  GifController gifController;
  AnimationController gifAnimationController;
  AnimationController buttonController;
  AnimationController buttonStyleController;
  Animation<double> alphaAnimation;
  Animation<double> scaleAnimation;
  Animation<double> buttonTextScaleAnimation;
  Animation<Color> colorTween;

  bool hasFile;
  Step step;

  Widget current;

  @override
  void initState() {
    super.initState();
    gifController = GifController(
        vsync: this, frameCount: 12, duration: Duration(milliseconds: 930));
    gifAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    buttonController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    buttonStyleController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    alphaAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(gifAnimationController);
    startWelcomeGif();
    Future.delayed(Duration(seconds: 2), () {
      getContext();
    });

    step = Step.One;

    scaleAnimation = Tween(begin: 120.0, end: 0.0).animate(buttonController);

    scaleAnimation.addListener(() {
      setState(() {});
    });

    scaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Context game = new Context();
        Application.gameContext = game;
        Navigator.pop(context);
        Application.router.navigateTo(context, Routes.page2,
            transition: TransitionType.nativeModal,transitionDuration: Duration(seconds: 2));
      }
    });

    buttonTextScaleAnimation =
        Tween(begin: 14.0, end: 0.0).animate(buttonStyleController);
    colorTween = ColorTween(
      begin: Colors.white,
      end: Colors.blue,
    ).animate(buttonStyleController);

    buttonTextScaleAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    gifController.dispose();
    gifAnimationController.dispose();
    buttonController.dispose();
    buttonStyleController.dispose();
    super.dispose();
  }

  void changePage(bool b) {
    setState(() {
      this.step = Step.Two;
      this.hasFile = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (step == Step.One) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: GifAnimation(
            image: AssetImage("images/welcome.gif"),
            controller: gifController,
          ),
        ),
      );
    } else {
      if (hasFile) {
        return Text("");
      } else {
        gifAnimationController.forward();
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("喵唔，糟糕！"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  width: 1,
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: alphaAnimation,
                    child: GifAnimation(
                      image: AssetImage("images/doubt.gif"),
                      controller: gifController,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      "喵喵好像没有找到存档，是否开始新一轮的喵喵纪元",
                      style: TextStyle(fontFamily: 'Miao', fontSize: 24),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: new Container(
                      height: scaleAnimation.value,
                      width: scaleAnimation.value,
                      child: RaisedButton(
                        child: Text('  当然喵！\n (=￣ω￣=)',
                            style: TextStyle(
                                fontFamily: 'Miao',
                                fontSize: buttonTextScaleAnimation.value)),
                        color: Theme.of(context).accentColor,
                        elevation: 4.0,
                        textColor: colorTween.value,
                        splashColor: Colors.blueGrey,
                        onPressed: () {
                          buttonStyleController.forward();
                          buttonController.forward();
                        },
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 1,
                )
              ],
            ));
      }
    }
  }

  void startWelcomeGif() {
    gifController.repeat(period: Duration(milliseconds: 930));
  }

  void getContext() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.get(Const.CONTEXT);
    if (json == null) {
      changePage(false);
    } else {
      try {
        Context context = jsonDecode(json) as Context;
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
