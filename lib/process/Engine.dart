import 'dart:collection';
import 'dart:convert';

import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Engine {
  Context context;

  double efficiencyCoefficient; //生产系数

  static final Engine _singleton = new Engine._internal();

  factory Engine() {
    return _singleton;
  }

  Engine._internal();

  void setContext(Context c) {
    this.context = c;
  }

  int passTimes = 0;

  void primed(BigInt timeStamp) {
    if (passTimes < Const.PASS_TIME_COUNT) {
      passTimes++;
    } else {
      passTimes = 0;
    }
    perPlanckTime(timeStamp);
  }

// 每秒进行一次
  void perPlanckTime(BigInt timeStamp) {
    //如果喵子领导是leader，增加效率
    if (context.leader.type == CatType.Leader) {
      efficiencyCoefficient =
          context.leader.happinessOutput * efficiencyCoefficient;
    }

    //人口是生产系数的重要影响部分
    efficiencyCoefficient = efficiencyCoefficient *
        FuncUtil().saturability(
            context.cats.length, FuncUtil().happiness(context.expeditions));

    catmintOutput();
    catOutput();
  }

  void catmintOutput() {
    LinkedHashMap building = context.buildings;
    if (building.containsKey(BuildingExample.catmintField)) {
      double except = CatmintFieldBuilder.instance.output(context);

      if (context.season == Season.Winter) {
        return;
      }
      if (context.leader.type == CatType.Farmer) {}

      if (context.leader.type == CatType.Farmer) {
        except = context.leader.agriculturalOutput * except;
      }

      context.wareHouse.receiveCatmint(except);
    }
  }

  void catOutput() {
    HashMap<CatJob, int> cats = context.catProfession;
    cats.forEach((job, int) {
      switch (job) {
        case CatJob.Farmer:
          context.wareHouse.receiveCatmint(efficiencyCoefficient * int * 5);
          break;
        case CatJob.Craftsman:
          context.wareHouse.receiveCatmint(efficiencyCoefficient * int * 3);
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
  void saveContext() async {
    String json = jsonEncode(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Const.CONTEXT, json);
  }

  double pickSomeCatmint(){
    double add =FuncUtil().getRandomDouble();
    context.wareHouse.receiveCatmint(add);
    return add;
  }
}
