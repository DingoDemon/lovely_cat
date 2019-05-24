import 'dart:collection';

import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'dart:math' as math;

import 'Engine.dart';

class CatmintOutputMachine extends PartOutputMachine {
  @override
  Map<Object, double> computeBuildOutput() {
    Map<Object, double> output = {FoodResource.catmint: 0};
    if (Application.gameContext.season == Season.Winter) {
      return output;
    } else {
      LinkedHashMap building = Application.gameContext.buildings;
      double except = 0;
      //薄荷田
      if (building.containsKey(BuildingExample.catmintField) &&
          building[BuildingExample.catmintField] > 0) {
        except += CatmintFieldBuilder.instance
            .output(Application.gameContext)[FoodResource.catmint];
      }
      if (Application.gameContext.season == Season.Fall) {
        except = Arith().multiplication(except, 1.5);
      }
      return {FoodResource.catmint: except};
    }
  }

  @override
  Map<Object, double> computeCatOutput() {
    double except = 0;
    if (Application.gameContext.catProfession.containsKey(CatJob.Farmer) &&
        Application.gameContext.catProfession[CatJob.Farmer] > 0) {
      except += Arith().multiplication(
          7.5, Application.gameContext.catProfession[CatJob.Farmer].toDouble());
    }
    if (Application.gameContext.leader != null &&
        Application.gameContext.leader.type == CatJob.Farmer) {
      double leaderCoefficient =
          math.pow(1.15, Application.gameContext.leader.level);
      except = Arith().multiplication(except, leaderCoefficient);
    }
    return {FoodResource.catmint: except};
  }

  @override
  Map<Object, double> mixTotalOutput(
      Map<Object, double> build, Map<Object, double> cats) {
    double total =
        Arith().add(build[FoodResource.catmint], cats[FoodResource.catmint]);
    total = Arith().multiplication(total, efficiencyCoefficient);
    Application.gameContext.wareHouse.receiveInfo[FoodResource.catmint] = total;
    return {FoodResource.catmint: total};
  }
}
