import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/process/Engine.dart';

import 'package:common_utils/common_utils.dart';

class Application {
  static Router router;
  static TabController controller;
  static Context gameContext;
  static const Duration one_second = Duration(seconds: 1);
  static TimerUtil mTimerUtil = TimerUtil();
  static Size size;
}
