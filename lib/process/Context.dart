import 'dart:collection';
import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/Arith.dart';

class Context {
  Age age;
  Season season;
  Cat leader;
  WareHouse wareHouse; //仓库
  HashMap<BuildingExample, int> buildings; //建筑
  List<Cat> cats;
  int catsLimit; //人口上限
  HashMap<CatJob, int> catProfession; //喵子分工
  LinkedHashMap<ExpeditionResource, double> expeditions; //冒险资源
  int gameStartTime;
  double saturability; //幸福度
  List<Handicrafts> things;

  Context() {
    age = Age.Chaos;
    season = Season.Winter;
    wareHouse = new WareHouse();
    buildings = new HashMap();
    cats = new List();
    catsLimit = 0;
    catProfession = new HashMap();
    gameStartTime = DateTime.now().millisecondsSinceEpoch;
    things = List();
  }

  Map<String, dynamic> toJson() => {
        'age': age,
        'season': season,
        'leader': leader,
        'wareHouse': wareHouse,
        'buildings': buildings,
        'cats': cats,
        'catsLimit': catsLimit,
        'catProfession': catProfession,
        'expeditions': expeditions,
        'gameStartTime': gameStartTime,
        'saturability': saturability,
        'things': things,
      };

  Context.fromJSON(Map json)
      : age = json['age'],
        season = json['season'],
        leader = json['leader'],
        wareHouse = json['wareHouse'],
        buildings = json['buildings'],
        cats = json['cats'],
        catsLimit = json['catsLimit'],
        catProfession = json['catProfession'],
        expeditions = json['expeditions'],
        gameStartTime = json['gameStartTime'],
        saturability = json['saturability'],
        things = json['things'];
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

  HashSet<Object> showItem = HashSet();

  WareHouse() {
    init();
  }

  Map<String, dynamic> toJson() => {
        'foods': foods,
        'foodsLimit': foodsLimit,
        'buildingMaterials': buildingMaterials,
        'buildingMaterialsLimit': buildingMaterialsLimit,
        'points': points,
        'pointsLimit': pointsLimit,
        'receiveInfo': receiveInfo,
        'showItem': showItem,
      };

  WareHouse.fromJSON(Map json)
      : showItem = json['showItem'],
        receiveInfo = json['season'],
        pointsLimit = json['pointsLimit'],
        points = json['points'],
        buildingMaterialsLimit = json['buildingMaterialsLimit'],
        buildingMaterials = json['buildingMaterials'],
        foodsLimit = json['foodsLimit'],
        foods = json['foods'];

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

  ///消耗资源
  void consumeResources(Map<Object, double> require) {
    require.forEach((object, double) {
      consumeResource(object, double);
    });
  }

  void consumeResource(Object o, double require) {
    if (o is FoodResource) {
      foods[o] = Arith().subtraction(foods[o], require);
    }
    if (o is BuildingResource) {
      buildingMaterials[o] = Arith().subtraction(buildingMaterials[o], require);
    }
    if (o is PointResource) {
      points[o] = Arith().subtraction(points[o], require);
    }
  }

  ///检查资源是否充分
  bool resourcesEnough(Map<Object, double> require) {
    bool result = true;
    for (MapEntry<Object, double> entry in require.entries) {
      if (!resourceEnough(entry.key, entry.value)) {
        result = false;
        break;
      }
    }
    return result;
  }

  bool resourceEnough(Object o, double value) {
    if (o is FoodResource) {
      return foods[o] >= value;
    }
    if (o is BuildingResource) {
      return buildingMaterials[o] >= value;
    }
    if (o is PointResource) {
      return points[o] >= value;
    }
    return true;
  }

  ///更新上一秒中[收获的资源]数值
  void updateObjectReceive(Object o, double) {
    receiveInfo[o] = double;
  }

  ///获取所有item
  List<Object> getShowItems() {
    foods.forEach((key, value) {
      if (value != null && value > 0) {
        showItem.add(key);
      }
    });
    buildingMaterials.forEach((key, value) {
      if (value != null && value > 0) {
        showItem.add(key);
      }
    });
    points.forEach((key, value) {
      if (value != null && value > 0) {
        showItem.add(key);
      }
    });
    return showItem.toList();
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

  void receiveObject(Object o, double v) {
    if (o is FoodResource) {
      switch (o) {
        case FoodResource.catmint:
          receiveCatmint(v, false);
          break;
      }
    } else if (o is BuildingResource) {
      switch (o) {
        case BuildingResource.branch:
          receiveBranch(v, false);
          break;
        case BuildingResource.beam:
          // TODO: Handle this case.
          break;
        case BuildingResource.stone:
          // TODO: Handle this case.
          break;
        case BuildingResource.iron:
          // TODO: Handle this case.
          break;
        case BuildingResource.steel:
          // TODO: Handle this case.
          break;
        case BuildingResource.cement:
          // TODO: Handle this case.
          break;
        case BuildingResource.gold:
          // TODO: Handle this case.
          break;
      }
    }
  }
}
