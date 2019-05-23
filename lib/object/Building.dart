import 'dart:collection';

import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/process/Engine.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'dart:math' as math;

import '../application.dart';

abstract class AbstractBuilder {
  LinkedHashMap<Object, double> buildResource = new LinkedHashMap();

  bool couldShow(Context c);

  bool couldBuild(Context c);

  void build(Context c);

  double output(Context c);

  void change(Context c);

  void updateResource();

  String getDescribe();
}

//对Context只处理一次，例如:人口建筑
abstract class StaticBuilder extends AbstractBuilder {
  @override
  double output(Context c) {
    return double.minPositive;
  }
}

//对Context每次都要处理，例如:产出建筑
abstract class OperativeBuilder extends AbstractBuilder {
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
    updateResource();
  }

  @override
  void build(Context c) {
    //造一片猫薄荷田
    if (catmintNecessary == -1) {
      throw new ArgumentError.notNull("未检查couldBuild,请检查UI层代码");
    } else {
      c.wareHouse.foods[FoodResource.catmint] = Arith().subtraction(
          c.wareHouse.foods[FoodResource.catmint], catmintNecessary);
      c.buildings[BuildingExample.catmintField] =
          c.buildings[BuildingExample.catmintField] + 1;
    }
    updateResource();
  }

  @override
  bool couldBuild(Context c) {
    return c.wareHouse.foods[FoodResource.catmint] >=
        buildResource[FoodResource.catmint];
  }

  String getNecessaryTip(Context c) {
    if (couldBuild(c)) {
      return "已经可以建造一片新的猫薄荷田了";
    } else {
      double value = Arith().subtraction(
          catmintNecessary, c.wareHouse.foods[FoodResource.catmint]);
      return "还差$value猫薄荷，才能建造一片新的猫薄荷田";
    }
  }

  @override
  double output(Context c) {
    //PlanckTime内产出
    return c.buildings[BuildingExample.catmintField] * 0.95;
  }

  @override
  bool couldShow(Context c) {
    return c.wareHouse.foods[FoodResource.catmint] > catmintNecessary / 3;
  }

  @override
  void updateResource() {
    LinkedHashMap buildings = Application.gameContext.buildings;

    if (!buildings.containsKey(BuildingExample.catmintField)) {
      catmintNecessary = Const.FIRST_BUILD_CATMINT_FIELD_NEED;
    } else {
      catmintNecessary = Arith().multiplication(catmintNecessary, 2);
    }
    buildResource[FoodResource.catmint] = catmintNecessary;
  }

  @override
  String getDescribe() {
    return "如果没有足够的猫薄荷，喵喵便会离开这里。秋天会收获更多的猫薄荷，但是在冬天，则没有猫薄荷产出。储备好足够的猫薄荷准备过冬哦";
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
    updateResource();
  }

  @override
  void build(Context c) {
    if (branchNeed == -1) {
      throw new ArgumentError.notNull("未检查couldBuild,请检查UI层代码");
    } else {
      c.wareHouse.buildingMaterials[BuildingResource.branch] = Arith()
          .subtraction(c.wareHouse.buildingMaterials[BuildingResource.branch],
              branchNeed);

      c.buildings[BuildingExample.chickenCoop] =
          c.buildings[BuildingExample.chickenCoop] + 1;
    }
    change(c);
    updateResource();
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

  @override
  void updateResource() {
    LinkedHashMap buildings = Application.gameContext.buildings;

    if (!buildings.containsKey(BuildingExample.chickenCoop)) {
      branchNeed = Const.FIRST_CHICKEN_COOP_NEED;
    } else {
      branchNeed = Arith().multiplication(branchNeed, 1.8);
    }

    buildResource[BuildingResource.branch] = branchNeed;
  }

  @override
  String getDescribe() {
    return "猫猫喜欢睡鸡窝，好像这就是为他们而制作的";
  }
}
