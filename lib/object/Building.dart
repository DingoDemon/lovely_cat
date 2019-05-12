import 'dart:collection';

import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'dart:math' as math;

import '../application.dart';

abstract class abstractBuildier {
  bool couldShow(Context c);

  bool couldBuild(Context c);

  void build(Context c);

  double output(Context c);

  void change(Context c);
}

//对Context只处理一次，例如:人口建筑
abstract class StaticBuilder extends abstractBuildier {
  @override
  double output(Context c) {
    return double.minPositive;
  }
}

//对Context每次都要处理，例如:产出建筑
abstract class OperativeBuilder extends abstractBuildier {
  @override
  void change(Context c) {}
}

class CatmintFieldBuilder extends OperativeBuilder {
  double catmintNecessary = -1;

  static final CatmintFieldBuilder instance = new CatmintFieldBuilder.create();

  factory CatmintFieldBuilder() {
    return instance;
  }

  CatmintFieldBuilder.create() {
    if (Application.gameContext == null) {
      throw StateError("Application.gameContext ==null");
    }

    LinkedHashMap buildings = Application.gameContext.buildings;

    if (!buildings.containsKey(BuildingExample.catmintField)) {
      catmintNecessary = Const.FIRST_BUILD_CATMINT_FIELD_NEED;
    } else {
      catmintNecessary = Const.FIRST_BUILD_CATMINT_FIELD_NEED *
          math.pow(Const.CATMINT_FIELD_BUILD_SEED,
              buildings[BuildingExample.catmintField]);
    }
  }

  @override
  void build(Context c) {
    //造一片猫薄荷田
    if (catmintNecessary == -1) {
      throw new ArgumentError.notNull("未检查couldBuild,请检查UI层代码");
    } else {
      c.wareHouse.foods[FoodResource.catmint] -= catmintNecessary;
      c.buildings[BuildingExample.catmintField] =
          c.buildings[BuildingExample.catmintField] + 1;
    }
  }

  @override
  bool couldBuild(Context c) {
    return c.wareHouse.foods[FoodResource.catmint] >= catmintNecessary;
  }

  String getNecessaryTip(Context c) {
    if (couldBuild(c)) {
      return "已经可以建造一片新的猫薄荷田了";
    } else {
      double value = catmintNecessary - c.wareHouse.foods[FoodResource.catmint];
      return "还差${NumUtil.getNumByValueDouble(value, 2)}猫薄荷，才能建造一片新的猫薄荷田";
    }
  }

  @override
  double output(Context c) {
    //PlanckTime内产出
    return c.buildings[BuildingExample.catmintField] * 1.2 ;
  }

  @override
  bool couldShow(Context c) {
    return c.wareHouse.foods[FoodResource.catmint] > catmintNecessary / 3;
  }
}

//鸡窝
class ChickenCoopBuilder extends StaticBuilder {
  double branchNeed = -1;

  static final ChickenCoopBuilder instance = new ChickenCoopBuilder.create();

  factory ChickenCoopBuilder() {
    return instance;
  }

  ChickenCoopBuilder.create() {
    if (Application.gameContext == null) {
      throw StateError("Application.gameContext ==null");
    }

    LinkedHashMap buildings = Application.gameContext.buildings;

    if (!buildings.containsKey(BuildingExample.chickenCoop)) {
      branchNeed = Const.FIRST_CHICKEN_COOP_NEED;
    } else {
      branchNeed = Const.FIRST_CHICKEN_COOP_NEED *
          math.pow(Const.CHICKEN_COOP_BUILD_SEED,
              buildings[BuildingExample.chickenCoop]);
    }
  }

  @override
  void build(Context c) {
    if (branchNeed == -1) {
      throw new ArgumentError.notNull("未检查couldBuild,请检查UI层代码");
    } else {
      c.wareHouse.buildingMaterials[BuildingResource.branch] -= branchNeed;
      c.wareHouse.buildingMaterials[BuildingResource.branch] =
          c.wareHouse.buildingMaterials[BuildingResource.branch] + 1;
    }
    change(c);
  }

  @override
  void change(Context c) {
    c.catsLimit++;
  }

  @override
  bool couldBuild(Context c) {
    return c.wareHouse.buildingMaterials[BuildingResource.branch] >= branchNeed;
  }

  @override
  bool couldShow(Context c) {
    return c.wareHouse.buildingMaterials[BuildingResource.branch] >
        branchNeed / 3;
  }
}
