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
import 'package:lovely_cats/util/EnumCovert.dart';

class Context {
  Age age;
  Season season;
  Cat leader;
  WareHouse wareHouse; //仓库
  LinkedHashMap<BuildingExample, int> buildings; //建筑
  List<Cat> cats;
  int catsLimit;
  HashMap<CatJob, int> catProfession;
  LinkedHashMap<ExpeditionResource, double> expeditions;
  int gameStartTime;
  Queue<Event> events;

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

  WareHouse() {
    init();
  }

  void init() {
    List<FoodResource> food = FoodResource.values;
    for (FoodResource resource in food) {
      foods[resource] = 0;
      foodsLimit[resource] = 500;
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

  double getItemReserves(Object o) {
    if (o is PointResource) {
      if (!points.containsKey(o)) {
        points[o] = 0;
      }
      return points[o];
    } else if (o == BuildingResource) {
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

  void receiveCatmint(double d) {
    if (foods[FoodResource.catmint] + d < foodsLimit[FoodResource.catmint]) {
      foods[FoodResource.catmint] =
          NumUtil.getNumByValueDouble(foods[FoodResource.catmint] + d, 2);
    } else {
      foods[FoodResource.catmint] = foodsLimit[FoodResource.catmint];
    }
  }

  void receiveBranch(double d) {
    if (buildingMaterials[BuildingResource.branch] + d <
        buildingMaterialsLimit[BuildingResource.branch]) {
      buildingMaterials[BuildingResource.branch] = NumUtil.getNumByValueDouble(
          buildingMaterials[BuildingResource.branch] + d, 2);
    } else {
      buildingMaterials[BuildingResource.branch] =
          buildingMaterialsLimit[BuildingResource.branch];
    }
  }
}
