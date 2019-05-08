import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:lovely_cats/main.dart';
import 'package:lovely_cats/view/GamePage.dart';


// app的首页
var homeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new MyApp();
  },
);

var categoryHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String firstPlay = params["firstPlay"]?.first;
    return new GamePage(firstPlay);
  },
);


