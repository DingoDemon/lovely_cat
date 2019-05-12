import 'dart:collection';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Engine {
  double efficiencyCoefficient; //生产系数

  static final Engine _singleton = new Engine._internal();

  factory Engine() {
    return _singleton;
  }

  Engine._internal();

  int passTimes = 0;

  void primed() {
    //如果抛出异常，检查代码在初始化Application.gameApplication.gameContext之前就开始运行
    assert(Application.gameContext != null);

    if (passTimes < Const.PASS_TIME_COUNT) {
      passTimes++;
    } else {
      passTimes = 0;
    }
    _perPlanckTime();
  }

// 每秒进行一次
  void _perPlanckTime() {
    //如果喵子领导是leader，增加效率
    if (Application.gameContext.leader != null &&
        Application.gameContext.leader.type == CatType.Leader) {
      efficiencyCoefficient = Application.gameContext.leader.happinessOutput *
          efficiencyCoefficient;
    }

    //人口是生产系数的重要影响部分
    if (Application.gameContext.cats.length > 1) {
      efficiencyCoefficient = efficiencyCoefficient *
          FuncUtil().saturability(Application.gameContext.cats.length,
              FuncUtil().happiness(Application.gameContext.expeditions));
    }

    _checkSeason();
    _catmintOutput();
    _catOutput();
    _addBuilding();
  }

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
        case BuildingExample.logCabin:
          break;
        case BuildingExample.loggingCamp:
          break;
        case BuildingExample.researchInstitute:
          break;
        case BuildingExample.tent:
          break;
        case BuildingExample.university:
          break;
        case BuildingExample.mineField:
          break;
      }
    }
  }

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

  void _catmintOutput() {
    LinkedHashMap building = Application.gameContext.buildings;
    if (building.containsKey(BuildingExample.catmintField) &&
        building[BuildingExample.catmintField] > 0) {
      double except =
          CatmintFieldBuilder.instance.output(Application.gameContext);

      if (Application.gameContext.season == Season.Winter) {
        return;
      }
      if (Application.gameContext.leader.type == CatType.Farmer) {}

      if (Application.gameContext.leader.type == CatType.Farmer) {
        except = Application.gameContext.leader.agriculturalOutput * except;
      }

      Application.gameContext.wareHouse.receiveCatmint(except);
    }
  }

  void _catOutput() {
    HashMap<CatJob, int> cats = Application.gameContext.catProfession;
    cats.forEach((job, int) {
      switch (job) {
        case CatJob.Farmer:
          Application.gameContext.wareHouse
              .receiveCatmint(efficiencyCoefficient * int * 5);
          break;
        case CatJob.Craftsman:
          Application.gameContext.wareHouse
              .receiveCatmint(efficiencyCoefficient * int * 3);
          break;
        case CatJob.Hunter:
          break;
        case CatJob.Oracle:
          break;
        case CatJob.Scholar:
          break;
      }
    });
  }

  //每10秒储存一次
  void _saveContext() async {
    String json = jsonEncode(Application.gameContext);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Const.CONTEXT, json);
  }

  double pickSomeCatmint() {
    double add = FuncUtil().getRandomDouble();
    Application.gameContext.wareHouse.receiveCatmint(add);
    return add;
  }

  bool makeCatmintToBranch() {
    if (Application.gameContext.wareHouse.foods[FoodResource.catmint] < 20) {
      return false;
    }
    Application.gameContext.wareHouse.foods[FoodResource.catmint] =
        Application.gameContext.wareHouse.foods[FoodResource.catmint] - 20;
    Application.gameContext.wareHouse.receiveBranch(1.0);
    return true;
  }
}
