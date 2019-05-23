import 'dart:collection';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/widget/Callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Engine {
  double _efficiencyCoefficient; //生产系数

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
      passTimes = 0;
    }
    _perPlanckTime();
    _callbacks.forEach((callback) {
      callback.callBack();
    });
  }

  /// 每秒进行一次
  void _perPlanckTime() {
    //如果喵子领导是leader，增加效率
    if (Application.gameContext.leader != null &&
        Application.gameContext.leader.type == CatJob.Leader) {
      _efficiencyCoefficient = Application.gameContext.leader.happinessOutput *
          _efficiencyCoefficient;
    }

    //人口是生产系数的重要影响部分
    if (Application.gameContext.cats.length > 0) {
      Application.gameContext.saturability = FuncUtil().saturability(
          Application.gameContext.cats.length,
          FuncUtil().happiness(Application.gameContext.expeditions));

      _efficiencyCoefficient = Arith().multiplication(
          _efficiencyCoefficient, Application.gameContext.saturability);
    }

    _checkSeason();
    _catmintOutput();
    _addBuilding();
    _checkEmptyForCat();
  }

  void _checkEmptyForCat() {
    if (Application.gameContext.cats.length <
            Application.gameContext.catsLimit &&
        FuncUtil().getRandom(20) == 1) {
      Cat cat = Cat(Application.gameContext.age);
      Application.gameContext.cats.add(cat);
    }
  }

  ///新增建筑
  void _addBuilding() {
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
      }
    }
  }

  ///切换季节
  void _checkSeason() {
    int now = DateUtil.getNowDateMs();
    int start = Application.gameContext.gameStartTime;
    int passed = (now - start) ~/ 1000;
    int lastDay = passed % 400;
    if (lastDay == 100 || lastDay == 200 || lastDay == 300 || lastDay == 0) {
      Application.gameContext.season =
          EnumCovert().getNextSeason(Application.gameContext.season);
    }
  }

  ///猫薄荷田总体输出
  void _catmintOutput() {
    if (Application.gameContext.season == Season.Winter) {
      Application.gameContext.wareHouse.receiveInfo[FoodResource.catmint] = 0;
      return;
    }

    LinkedHashMap building = Application.gameContext.buildings;

    double except = 0;
    //薄荷田
    if (building.containsKey(BuildingExample.catmintField) &&
        building[BuildingExample.catmintField] > 0) {
      except = CatmintFieldBuilder.instance.output(Application.gameContext);

      if (Application.gameContext.catProfession.containsKey(CatJob.Farmer) &&
          Application.gameContext.catProfession[CatJob.Farmer] > 0) {
        except += Arith().multiplication(
            4, Application.gameContext.catProfession[CatJob.Farmer] as double);

        if (Application.gameContext.season == Season.Fall) {
          except = Arith().multiplication(except, 1.5);
        }

        if (Application.gameContext.leader != null &&
            Application.gameContext.leader.type == CatJob.Farmer) {
          except = Application.gameContext.leader.agriculturalOutput * except;
        }

        Application.gameContext.wareHouse.receiveCatmint(except, false);
      }
    }
  }

  void _branchOutput() {}

  ///每10秒储存一次
  void _saveContext() async {
    String json = jsonEncode(Application.gameContext);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Const.CONTEXT, json);
  }

  ///手动操作，采一点猫薄荷
  double pickSomeCatmint() {
    double add = FuncUtil().getRandomDouble();
    Application.gameContext.wareHouse.receiveCatmint(add, true);
    return add;
  }

  ///手动操作，将猫薄荷转化成树枝
  bool makeCatmintToBranch() {
    if (Application.gameContext.wareHouse.foods[FoodResource.catmint] < 20) {
      return false;
    }
    Application.gameContext.wareHouse.foods[FoodResource.catmint] = Arith()
        .subtraction(
            Application.gameContext.wareHouse.foods[FoodResource.catmint], 20);
    Application.gameContext.wareHouse.receiveBranch(1.0, true);
    return true;
  }
}
