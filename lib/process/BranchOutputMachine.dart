import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'dart:math' as math;

import '../application.dart';
import 'Engine.dart';

class BranchOutputMachine extends PartOutputMachine {
  @override
  Map<Object, double> computeBuildOutput() {
    return {BuildingResource.branch: 0};
  }

  @override
  Map<Object, double> computeCatOutput() {
    double except = 0;
    if (Application.gameContext.catProfession.containsKey(CatJob.Faller) &&
        Application.gameContext.catProfession[CatJob.Faller] > 0) {
      except += Arith().multiplication(0.225,
          Application.gameContext.catProfession[CatJob.Faller].toDouble());
    }
    if (Application.gameContext.leader != null &&
        Application.gameContext.leader.originType == CatJob.Faller) {
      double leaderCoefficient =
          math.pow(1.15, Application.gameContext.leader.level);
      except = Arith().multiplication(except, leaderCoefficient);
    }
    if (Application.gameContext.buildings
            .containsKey(BuildingExample.loggingCamp) &&
        Application.gameContext.buildings[BuildingExample.loggingCamp] > 0) {
      except = Arith().multiplication(except,
          1.1 * Application.gameContext.buildings[BuildingExample.loggingCamp]);
    }
    return {BuildingResource.branch: except};
  }

  @override
  Map<Object, double> mixTotalOutput(
      Map<Object, double> build, Map<Object, double> cats) {
    double total = Arith()
        .add(build[BuildingResource.branch], cats[BuildingResource.branch]);
    total = Arith().multiplication(total, efficiencyCoefficient);
    if (total > 0)
      Application.gameContext.wareHouse.receiveInfo[BuildingResource.branch] =
          total;
    return {BuildingResource.branch: total};
  }
}
