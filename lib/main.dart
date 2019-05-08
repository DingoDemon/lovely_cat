import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Const.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'dart:async';

import 'package:lovely_cats/view/WelComePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  WelcomePage welcomePage;

  @override
  Widget build(BuildContext context) {

    final router = new Router();

    Routes.configureRoutes(router);

    Application.router = router;


    welcomePage = new WelcomePage();

    return MaterialApp(
        title: "喵喵奇妙国",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: welcomePage);
  }


}
