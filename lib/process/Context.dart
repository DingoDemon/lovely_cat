import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;
import 'package:common_utils/common_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/object/RandomEvent.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/EnumCovert.dart';

class Context {
  Age age;
  Season season;
  Cat leader;
  WareHouse wareHouse; //仓库
  LinkedHashMap<BuildingExample, int> buildings; //建筑
  List<Cat> cats;
  int catsLimit; //人口上限
  HashMap<CatJob, int> catProfession; //喵子分工
  LinkedHashMap<ExpeditionResource, double> expeditions;
  int gameStartTime;
  Queue<Event> events;
  double saturability; //幸福度

  Context() {
    age = Age.Chaos;
    season = Season.Winter;
    wareHouse = new WareHouse();
    buildings = new LinkedHashMap();
    cats = new List();
    catsLimit = 0;
    catProfession = new HashMap();
    gameStartTime = DateTime.now().millisecondsSinceEpoch;
    events = new Queue();
  }
}

class WareHouse {
  LinkedHashMap<FoodResource, double> foods = LinkedHashMap();
  LinkedHashMap<FoodResource, double> foodsLimit = LinkedHashMap();
  LinkedHashMap<BuildingResource, double> buildingMaterials = LinkedHashMap();
  LinkedHashMap<BuildingResource, double> buildingMaterialsLimit =
      LinkedHashMap();
  LinkedHashMap<PointResource, double> points = LinkedHashMap();
  LinkedHashMap<PointResource, double> pointsLimit = LinkedHashMap();

  LinkedHashMap<Object, double> receiveInfo = LinkedHashMap();

  WareHouse() {
    init();
  }

  void init() {
    List<FoodResource> food = FoodResource.values;
    for (FoodResource resource in food) {
      foods[resource] = 0;
      foodsLimit[resource] = 5000;
    }
    List<BuildingResource> build = BuildingResource.values;
    for (BuildingResource resource in build) {
      buildingMaterials[resource] = 0;
      buildingMaterialsLimit[resource] = 200;
    }

    List<PointResource> point = PointResource.values;
    for (PointResource resource in point) {
      points[resource] = 0;
      pointsLimit[resource] = 100;
    }
  }

  ///更新上一秒中收获的资源
  void updateObjectReceive(Object o, double) {
    receiveInfo[o] = double;
  }

  ///获取所有item
  List<Object> getItems() {
    List<Object> list = [];
    foods.forEach((key, value) {
      if (value != null && value > 0) list.add(key);
    });
    buildingMaterials.forEach((key, value) {
      if (value != null && value > 0) list.add(key);
    });
    points.forEach((key, value) {
      if (value != null && value > 0) list.add(key);
    });
    return list;
  }

  ///获取仓库资源存量
  double getItemReserves(Object o) {
    if (o is PointResource) {
      if (!points.containsKey(o)) {
        points[o] = 0;
      }
      return points[o];
    } else if (o is BuildingResource) {
      if (!buildingMaterials.containsKey(o)) {
        buildingMaterials[o] = 0;
      }
      return buildingMaterials[o];
    } else if (o is FoodResource) {
      if (!foods.containsKey(o)) {
        foods[o] = 0;
      }
      return foods[o];
    } else {
      return 0.0;
    }
  }

  ///获取仓库资源存量上限
  double getItemReservesLimit(Object o) {
    if (o is PointResource) {
      return pointsLimit[o];
    } else if (o is BuildingResource) {
      return buildingMaterialsLimit[o];
    } else if (o is FoodResource) {
      return foodsLimit[o];
    } else {
      return 0.0;
    }
  }

  ///收取猫薄荷
  void receiveCatmint(double d, bool isHandwork) {
    if (foods[FoodResource.catmint] + d < foodsLimit[FoodResource.catmint]) {
      foods[FoodResource.catmint] = Arith().add(foods[FoodResource.catmint], d);
    } else {
      foods[FoodResource.catmint] = foodsLimit[FoodResource.catmint];
    }
    if (!isHandwork) {
      receiveInfo[FoodResource.catmint] = NumUtil.getNumByValueDouble(d, 2);
    }
  }

  ///收取树枝
  void receiveBranch(double d, bool isHandwork) {
    if (buildingMaterials[BuildingResource.branch] + d <
        buildingMaterialsLimit[BuildingResource.branch]) {
      buildingMaterials[BuildingResource.branch] =
          Arith().add(buildingMaterials[BuildingResource.branch], d);
    } else {
      buildingMaterials[BuildingResource.branch] =
          buildingMaterialsLimit[BuildingResource.branch];
    }
    if (!isHandwork) {
      receiveInfo[BuildingResource.branch] = NumUtil.getNumByValueDouble(d, 2);
    }
  }
}
