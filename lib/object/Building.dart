import 'dart:collection';

import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/object/Things.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'dart:math' as math;

import '../application.dart';

abstract class AbstractBuilder {
  Map<Object, double> originBuildResource = Map();
  HashSet<Interceptor> interceptors = HashSet();

  bool couldShow(Context c);

  bool couldBuild(Context c) {
    return Application.gameContext.wareHouse
        .resourcesEnough(buildNeedResource(c));
  }

  Map<Object, double> buildNeedResource(Context c);

  void build(Context c);

  Map<Object, double> output(Context c);

  void change(Context c);

  String getDescribe();

  void addInterceptor(Interceptor interceptor);
}

//对Context只处理一次，例如:人口建筑
abstract class StaticBuilder extends AbstractBuilder {
  @override
  Map<Object, double> output(Context c) {
    return null;
  }

  void addInterceptor(Interceptor interceptor) {
    interceptors.add(interceptor);
  }
}

//对Context每次都要处理，例如:产出建筑
abstract class OperativeBuilder extends AbstractBuilder {
  @override
  void change(Context c) {}

  void addInterceptor(Interceptor interceptor) {
    interceptors.add(interceptor);
  }
}

///猫薄荷田
class CatmintFieldBuilder extends OperativeBuilder {
  BuildingExample example;

  static final CatmintFieldBuilder instance = new CatmintFieldBuilder.create();

  factory CatmintFieldBuilder() {
    return instance;
  }

  CatmintFieldBuilder.create() {
    example = BuildingExample.catmintField;
    if (Application.gameContext == null) {
      throw StateError("Application.gameContext ==null");
    }
    for (Handicrafts handicrafts in Application.gameContext.things) {
      Interceptor interceptor = Things().getInterceptor(handicrafts);
      if (example == interceptor.buildingExample) {
        interceptors.add(interceptor);
      }
    }
  }

  @override
  void build(Context c) {
    if (couldBuild(c)) {
      Application.gameContext.wareHouse.consumeResources(buildNeedResource(c));
      Application.gameContext.buildings[BuildingExample.catmintField] += 1;
    }
  }

  @override
  bool couldShow(Context c) {
    return c.wareHouse.foods[FoodResource.catmint] > 5;
  }

  @override
  String getDescribe() {
    return "如果没有足够的猫薄荷，喵喵便会离开这里。秋天会收获更多的猫薄荷，但是在冬天，则没有猫薄荷产出。储备好足够的猫薄荷准备过冬哦";
  }

  @override
  Map<Object, double> output(Context c) {
    double origin = Arith().multiplication(
        c.buildings[BuildingExample.catmintField].toDouble(), 0.95);
    if (interceptors.length == 0) {
      return {FoodResource.catmint: origin};
    } else {
      Map procesed;
      for (Interceptor interceptor in interceptors) {
        procesed = interceptor.changeOutPut({FoodResource.catmint: origin});
      }
      return procesed;
    }
  }

  @override
  Map<Object, double> buildNeedResource(Context c) {
    Map<Object, double> origin = {
      FoodResource.catmint: Arith().multiplication(
          10,
          math.pow(1.67,
              Application.gameContext.buildings[BuildingExample.catmintField]))
    };
    if (interceptors.length == 0) {
      return origin;
    } else {
      Map<Object, double> processed;
      for (Interceptor interceptor in interceptors) {
        processed = interceptor.changeBuildResourceRequire(origin);
      }
      return processed;
    }
  }
}

///鸡窝
class ChickenCoopBuilder extends StaticBuilder {
  BuildingExample example;

  static final ChickenCoopBuilder instance = new ChickenCoopBuilder.create();

  factory ChickenCoopBuilder() {
    return instance;
  }

  ChickenCoopBuilder.create() {
    example = BuildingExample.chickenCoop;
    if (Application.gameContext == null) {
      throw StateError("Application.gameContext ==null");
    }
    for (Handicrafts handicrafts in Application.gameContext.things) {
      Interceptor interceptor = Things().getInterceptor(handicrafts);
      if (example == interceptor.buildingExample) {
        interceptors.add(interceptor);
      }
    }
  }

  @override
  void build(Context c) {
    if (couldBuild(c)) {
      Application.gameContext.wareHouse.consumeResources(buildNeedResource(c));
      Application.gameContext.buildings[BuildingExample.chickenCoop]++;
      change(c);
    }
  }

  @override
  void change(Context c) {
    c.catsLimit++;
  }

  @override
  bool couldShow(Context c) {
    return c.wareHouse.buildingMaterials[BuildingResource.branch] > 2;
  }

  @override
  String getDescribe() {
    return "猫猫喜欢睡鸡窝，好像这就是为他们而制作的";
  }

  @override
  Map<Object, double> buildNeedResource(Context c) {
    Map<Object, double> origin = {
      BuildingResource.branch: Arith().multiplication(
          10,
          math.pow(2,
              Application.gameContext.buildings[BuildingExample.catmintField]))
    };
    if (interceptors.length == 0) {
      return origin;
    } else {
      Map<Object, double> processed;
      for (Interceptor interceptor in interceptors) {
        processed = interceptor.changeBuildResourceRequire(origin);
      }
      return processed;
    }
  }
}
