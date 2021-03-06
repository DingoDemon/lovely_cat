import 'dart:collection';
import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/EnumCovert.dart';

import 'Arith.dart';

class FuncUtil {
  static final FuncUtil _singleton = new FuncUtil._internal();

  FuncUtil._internal();

  factory FuncUtil() {
    return _singleton;
  }

  int getRandom(int max) {
    Random random = new Random();
    return random.nextInt(max);
  }

  int getRandomWithMin(int max, int min) {
    Random random = new Random();
    int result = random.nextInt(max);
    return result < min ? getRandomWithMin(max, min) : result;
  }

  double getRandomDouble() {
    Random random = new Random();
    double result = random.nextDouble();
    result =
        result == 0 ? getRandomDouble() : Arith().multiplication(result, 3);
    return result;
  }

  BloodLines getCatBlood() {
    Random random = new Random();
    int i = random.nextInt(25);
    if (i <= 4) {
      return BloodLines.GardenCat;
    } else if (i > 4 && i <= 8) {
      return BloodLines.AmericanShorthair;
    } else if (i > 8 && i <= 11) {
      return BloodLines.BritishShorthair;
    } else if (i > 11 && i <= 15) {
      return BloodLines.ScottishFold;
    } else if (i > 15 && i <= 17) {
      return BloodLines.Siam;
    } else if (i > 17 && i <= 20) {
      return BloodLines.HairlessCat;
    } else if (i > 21 && i <= 23) {
      return BloodLines.HairlessCat;
    } else {
      return BloodLines.HairlessCat;
    }
  }

  List<CatJob> getCatJobs() {
    switch (Application.gameContext.age) {
      case Age.Chaos:
        return [CatJob.Sleeper, CatJob.Farmer, CatJob.Faller];
      case Age.Stone:
        return [
          CatJob.Sleeper,
          CatJob.Farmer,
          CatJob.Faller,
          CatJob.Miner,
          CatJob.Hunter
        ];
      case Age.Bronze:
        return [CatJob.Sleeper];
      case Age.Iron:
        return [CatJob.Sleeper];
      case Age.Feudal:
        return [CatJob.Sleeper];
      case Age.Industry:
        return [CatJob.Sleeper];
      case Age.Modern:
        return [CatJob.Sleeper];
      case Age.Space:
        return [CatJob.Sleeper];
    }
  }

  ///计算幸福度
  double saturability(int catsNum, double happinessResource) {
    double denominator = 100;
    double numerator = 100 - (catsNum * catsNum / 15) + happinessResource;
    if (numerator < 0) {
      return 0.01;
    } else {
      return double.parse((numerator / denominator).toStringAsFixed(2));
    }
  }

  double happiness(LinkedHashMap<ExpeditionResource, double> expeditions) {
    return 0;
  }

  String getGameTitle(Context c) {
    int now = c.gameEndTime;
    int start = c.gameStartTime;
    int passed = (now - start) ~/ 1000;
    int year = passed ~/ 400;
    int lastDay = passed % 400;
    return '第$year喵年,第$lastDay天,${EnumCovert().getSeasonName(c.season)}';
  }

  AbstractBuilder getBuilder(BuildingExample example) {
    switch (example) {
      case BuildingExample.catmintField:
        return CatmintFieldBuilder();
      case BuildingExample.refinery:
        return null;
      case BuildingExample.researchInstitute:
        return null;
      case BuildingExample.advancedCattery:
        return null;
      case BuildingExample.box:
        return null;
      case BuildingExample.cattery:
        return null;
      case BuildingExample.library:
        return null;
      case BuildingExample.college:
        return null;
      case BuildingExample.loggingCamp:
        return LoggingCampBuilder();
      case BuildingExample.researchInstitute:
        return null;
      case BuildingExample.refinery:
        return null;
      case BuildingExample.university:
        return null;
      case BuildingExample.mineField:
        return null;
      case BuildingExample.chickenCoop:
        return ChickenCoopBuilder();
      default:
        return null;
    }
  }
}
