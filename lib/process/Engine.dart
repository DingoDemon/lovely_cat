import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/RandomEvent.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/util/shared_preferences.dart';
import 'package:lovely_cats/Callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BranchOutputMachine.dart';
import 'CatmintOutputMachine.dart';

class Engine {
  static final Engine _singleton = new Engine._internal();

  factory Engine() {
    return _singleton;
  }

  Engine._internal();

  int passTimes = 0;

  List<Callback> _callbacks = [];

  void registerCallback(Callback callback) {
    _callbacks.add(callback);
  }

  void unregisterCallback(Callback callback) {
    _callbacks.remove(callback);
  }

  void primed() {
    ///检查代码在初始化Application.gameApplication.gameContext之前就开始运行
    assert(Application.gameContext != null);

    if (passTimes < Const.PASS_TIME_COUNT) {
      passTimes++;
    } else {
      _saveContext();
      passTimes = 0;
    }
    _perPlanckTime();
    _callbacks.forEach((callback) {
      callback.callBack();
    });
  }

  /// 每秒进行一次
  void _perPlanckTime() {
    _checkSeason();
    _addShouldShowBuilding();
    _checkEmptyForCat();
    _machineOutput();
    _catConsume();
    _catLeaderGrowUp();
    _randomEvent();
    Application.gameContext.gameEndTime += 1000;
  }

  ///随机事件
  void _randomEvent() {
    RandomEvent().makeCatEventOneIfNone();
  }

  ///计算各种产出
  void _machineOutput() {
    CatmintOutputMachine().process();
    BranchOutputMachine().process();
  }

  void _catLeaderGrowUp() {
    if (Application.gameContext.leader != null) {
      print("dingo ${Application.gameContext.leader.exp}");
      Application.gameContext.leader.expAdd();
    }
  }

  ///猫猫吃猫粮
  void _catConsume() {
    if (Application.gameContext.cats == null) {
      return;
    }
    double need = Arith()
        .multiplication(Application.gameContext.cats.length.toDouble(), 4.5);
    if (Application.gameContext.wareHouse
        .resourcesEnough({FoodResource.catmint: need})) {
      Application.gameContext.wareHouse
          .consumeResource(FoodResource.catmint, need);
    } else {
      Random random = new Random();
      Cat removed = Application.gameContext.cats
          .removeAt(random.nextInt(Application.gameContext.cats.length));
      Application.gameContext.catProfession[removed.arrange] -= 1;
      for (Callback callback in _callbacks) {
        callback.catLeave(removed);
      }
    }
  }

  ///是否有空位容纳新猫
  void _checkEmptyForCat() {
    if (Application.gameContext.cats.length <
            Application.gameContext.catsLimit &&
        FuncUtil().getRandom(4 * Application.gameContext.catsLimit) == 1) {
      Cat cat = createOneCat(Application.gameContext.age);
      Application.gameContext.cats.add(cat);
      Application.gameContext.receiveAMessage('来了一只小喵喵:${cat.dec}');
      if (Application.gameContext.catProfession.isNotEmpty) {
        Application.gameContext.catProfession[CatJob.Sleeper] += 1;
      } else {
        Application.gameContext.catProfession[CatJob.Sleeper] = 1;
      }
      for (Callback callback in _callbacks) {
        callback.receiveACat(cat);
      }
    }
  }

  ///新增建筑
  void _addShouldShowBuilding() {
    print(('dingo${Application.gameContext.buildings}'));
    for (BuildingExample example in BuildingExample.values) {
      switch (example) {
        case BuildingExample.catmintField:
          if (!Application.gameContext.buildings
                  .containsKey(BuildingExample.catmintField) &&
              CatmintFieldBuilder.instance.couldShow(Application.gameContext)) {
            Application.gameContext.buildings[BuildingExample.catmintField] = 0;
          }
          break;
        case BuildingExample.chickenCoop:
          if (!Application.gameContext.buildings
                  .containsKey(BuildingExample.chickenCoop) &&
              ChickenCoopBuilder.instance.couldShow(Application.gameContext)) {
            Application.gameContext.buildings[BuildingExample.chickenCoop] = 0;
          }
          break;
        case BuildingExample.advancedCattery:
          break;
        case BuildingExample.box:
          break;
        case BuildingExample.cattery:
          break;
        case BuildingExample.library:
          break;
        case BuildingExample.college:
          break;
        case BuildingExample.loggingCamp:
          if (!Application.gameContext.buildings
                  .containsKey(BuildingExample.loggingCamp) &&
              ChickenCoopBuilder.instance.couldShow(Application.gameContext)) {
            Application.gameContext.buildings[BuildingExample.loggingCamp] = 0;
          }
          break;
        case BuildingExample.researchInstitute:
          break;
        case BuildingExample.refinery:
          break;
        case BuildingExample.university:
          break;
        case BuildingExample.mineField:
          break;
        case BuildingExample.warehouse:
          break;
        case BuildingExample.coalMine:
          break;
        case BuildingExample.workbench:
          break;
      }
    }
  }

  ///切换季节
  void _checkSeason() {
    int now = Application.gameContext.gameEndTime;
    int start = Application.gameContext.gameStartTime;
    int passed = (now - start) ~/ 1000;
    int lastDay = passed % 400;
    if (lastDay == 100 || lastDay == 200 || lastDay == 300 || lastDay == 0) {
      Application.gameContext.season =
          EnumCovert().getNextSeason(Application.gameContext.season);
    }
  }

  ///每10秒储存一次
  void _saveContext() async {
    String json = jsonEncode(Application.gameContext.toJson());
    SpUtil sp = await SpUtil.getInstance();
    sp.putString(Const.CONTEXT, json);
  }

  ///手动操作，采一点猫薄荷
  double pickSomeCatmint() {
    double add = FuncUtil().getRandomDouble();
    Application.gameContext.wareHouse.receiveCatmint(add, true);
    return add;
  }

  ///手动操作，将猫薄荷转化成树枝
  bool makeCatmintToBranch() {
    if (Application.gameContext.wareHouse
        .resourcesEnough({FoodResource.catmint: 20})) {
      return false;
    }
    Application.gameContext.wareHouse.consumeResource(FoodResource.catmint, 20);
    Application.gameContext.wareHouse.receiveBranch(1.0, true);
    return true;
  }
}

abstract class PartOutputMachine {
  Map<Object, double> computeBuildOutput();

  Map<Object, double> computeCatOutput();

  Map<Object, double> mixTotalOutput(
      Map<Object, double> build, Map<Object, double> cats);

  double efficiencyCoefficient = 1; //生产系数

  void process() {
    //如果喵子领导是演员，增加整体效率
    if (Application.gameContext.leader != null &&
        Application.gameContext.leader.originType == CatJob.Actor) {
      double leaderCoefficient =
          math.pow(1.1, Application.gameContext.leader.level);
      efficiencyCoefficient =
          Arith().multiplication(efficiencyCoefficient, leaderCoefficient);
    }

    //人口是生产系数的重要影响部分
    if (Application.gameContext.cats.length > 0) {
      Application.gameContext.saturability = FuncUtil().saturability(
          Application.gameContext.cats.length,
          FuncUtil().happiness(Application.gameContext.expeditions));

      efficiencyCoefficient = Arith().multiplication(
          efficiencyCoefficient, Application.gameContext.saturability);
    }

    Map<Object, double> buildOutput = computeBuildOutput();
    Map<Object, double> catOutput = computeCatOutput();
    mixTotalOutput(buildOutput, catOutput).forEach((object, double) {
      Application.gameContext.wareHouse.receiveObject(object, double);
    });
  }
}
