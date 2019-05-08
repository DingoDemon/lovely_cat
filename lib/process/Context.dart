import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;
import 'package:decimal/decimal.dart';
import 'package:lovely_cats/object/Building.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/Const.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';

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

  Context() {
    age = Age.Chaos;
    season = Season.Spring;
    wareHouse = new WareHouse();
    buildings = new LinkedHashMap();
    cats = new List();
    catsLimit = 0;
    catProfession = new HashMap();
    gameStartTime = DateTime.now().millisecondsSinceEpoch;
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
      foodsLimit[resource] = 500;
    }
    List<BuildingResource> build = BuildingResource.values;
    for (BuildingResource resource in build) {
      buildingMaterialsLimit[resource] = 200;
    }

    List<PointResource> point = PointResource.values;
    for (PointResource resource in point) {
      pointsLimit[resource] = 100;
    }
  }

  void receiveCatmint(double d) {
    if (foods[FoodResource.catmint] + d < foodsLimit[FoodResource.catmint]) {
      foods[FoodResource.catmint] += d;
    } else {
      return;
    }
  }
}
