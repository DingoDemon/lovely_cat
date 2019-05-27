import 'dart:collection';
import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

class Context {
  Age age;
  Season season;
  Cat leader;
  WareHouse wareHouse; //仓库
  Map<BuildingExample, int> buildings; //建筑
  List<Cat> cats;
  int catsLimit; //人口上限
  Map<CatJob, int> catProfession; //喵子分工
  Map<ExpeditionResource, double> expeditions; //冒险资源
  int gameStartTime;
  double saturability; //幸福度
  List<Handicrafts> things;
  int gameEndTime;

  Context() {
    age = Age.Chaos;
    season = Season.Winter;
    wareHouse = new WareHouse();
    buildings = new Map();
    cats = new List();
    catsLimit = 0;
    catProfession = new Map();
    gameStartTime = DateTime.now().millisecondsSinceEpoch;
    things = List();
    saturability = 1;
    expeditions = Map();
    gameEndTime = DateTime.now().millisecondsSinceEpoch;
    initCatProfession();
  }

  void initCatProfession() {
    for (CatJob catJob in CatJob.values) {
      catProfession[catJob] = 0;
    }
  }

  Map<String, dynamic> toJson() => {
        'age': age.toString(),
        'season': season.toString(),
        'leader': leader.toString(),
        'wareHouse': wareHouse.toJson(),
        'buildings': new JsonEncoder().convert(covertToStringMapInt(buildings)),
        'cats': jsonEncode(covertListToStringList(cats)),
        'catsLimit': catsLimit,
        'catProfession':
            new JsonEncoder().convert(covertToStringMapInt(catProfession)),
        'expeditions': expeditions,
        'gameStartTime': gameStartTime,
        'saturability': saturability,
        'things': jsonEncode(covertListToStringList(things)),
        'gameEndTime': gameEndTime
      };

  Context.fromJSON(Map json)
      : age = getAgeFromJson(json['age']),
        season = getSeasonFromJson(json['season']),
        leader = json['leader'] == "null"
            ? null
            : Cat.fromJSON(new JsonDecoder().convert(json['leader'])),
        wareHouse = WareHouse.fromJSON(json['wareHouse']),
        buildings = covertToBuildingExampleMap(covertToObjectMapInt(
            new JsonDecoder().convert(json['buildings'])
                as Map<String, dynamic>)),
        cats = json['cats'] == '[]'
            ? []
            : covertListToCatList((jsonDecode(json['cats']) as List)),
        catsLimit = json['catsLimit'],
        catProfession = covertToCatJobMap(covertToObjectMapInt(new JsonDecoder()
            .convert(json['catProfession']) as Map<String, dynamic>)),
        expeditions = (json['expeditions'] as Map).isEmpty
            ? {}
            : covertToExpeditionResourceMap(covertToObjectMap(new JsonDecoder()
                .convert(json['expeditions']) as Map<String, dynamic>)),
        gameStartTime = json['gameStartTime'],
        gameEndTime = json['gameEndTime'],
        saturability = json['saturability'],
        things = json['things'] == '[]'
            ? []
            : covertListToHandicraftsList((jsonDecode(json['things']) as List));
}

class WareHouse {
  Map<FoodResource, double> foods = Map();
  Map<FoodResource, double> foodsLimit = Map();
  Map<BuildingResource, double> buildingMaterials = Map();
  Map<BuildingResource, double> buildingMaterialsLimit = Map();
  Map<PointResource, double> points = Map();
  Map<PointResource, double> pointsLimit = Map();

  Map<Object, double> receiveInfo = Map();

  Map<Object, double> showItem = Map();

  WareHouse() {
    init();
  }

  Map<String, dynamic> toJson() => {
        'foods': new JsonEncoder().convert(covertToStringMap(foods)),
        'foodsLimit': new JsonEncoder().convert(covertToStringMap(foodsLimit)),
        'buildingMaterials':
            new JsonEncoder().convert(covertToStringMap(buildingMaterials)),
        'buildingMaterialsLimit': new JsonEncoder()
            .convert(covertToStringMap(buildingMaterialsLimit)),
        'points': new JsonEncoder().convert(covertToStringMap(points)),
        'pointsLimit':
            new JsonEncoder().convert(covertToStringMap(pointsLimit)),
        'receiveInfo':
            new JsonEncoder().convert(covertToStringMap(receiveInfo)),
        'showItem': new JsonEncoder().convert(covertToStringMap(showItem)),
      };

  WareHouse.fromJSON(Map json)
      : receiveInfo = covertToObjectMap(new JsonDecoder()
            .convert(json['receiveInfo']) as Map<String, dynamic>),
        pointsLimit = covertToPointMap(covertToObjectMap(new JsonDecoder()
            .convert(json['pointsLimit']) as Map<String, dynamic>)),
        points = covertToPointMap(covertToObjectMap(
            new JsonDecoder().convert(json['points']) as Map<String, dynamic>)),
        buildingMaterialsLimit = covertToBuildingResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['buildingMaterialsLimit'])
                as Map<String, dynamic>)),
        buildingMaterials = covertToBuildingResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['buildingMaterials'])
                as Map<String, dynamic>)),
        foodsLimit = covertToFoodResourceMap(covertToObjectMap(new JsonDecoder()
            .convert(json['foodsLimit']) as Map<String, dynamic>)),
        foods = covertToFoodResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['foods']) as Map<String, dynamic>)),
        showItem = covertToObjectMap(new JsonDecoder().convert(json['showItem'])
            as Map<String, dynamic>);

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
      if (value != null && value > 0 && !showItem.containsKey(key)) {
        showItem[key] = -1;
      }
    });
    buildingMaterials.forEach((key, value) {
      if (value != null && value > 0) {
        showItem[key] = -1;
      }
    });
    points.forEach((key, value) {
      if (value != null && value > 0) {
        showItem[key] = -1;
      }
    });
    List<Object> result = [];
    showItem.forEach((o, v) {
      result.add(o);
    });
    return result;
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

Map<Object, double> covertToObjectMap(Map<String, dynamic> origin) {
  Map<Object, double> result = Map();
  origin.forEach((s, v) {
    double d = v;
    result[getFromString(s)] = d;
  });

  return result;
}

Map<Object, int> covertToObjectMapInt(Map<String, dynamic> origin) {
  Map<Object, int> result = Map();
  origin.forEach((s, v) {
    int i = v;
    result[getFromString(s)] = i;
  });

  return result;
}

Map<String, double> covertToStringMap(Map<Object, double> origin) {
  Map<String, double> result = Map();
  origin.forEach((o, v) {
    result[o.toString()] = v;
  });

  return result;
}

Map<String, int> covertToStringMapInt(Map<Object, int> origin) {
  Map<String, int> result = Map();
  origin.forEach((o, v) {
    result[o.toString()] = v;
  });

  return result;
}

Map<PointResource, double> covertToPointMap(Map<Object, double> origin) {
  Map<PointResource, double> result = Map();
  origin.forEach((o, v) {
    result[o as PointResource] = v;
  });

  return result;
}

Map<BuildingResource, double> covertToBuildingResourceMap(
    Map<Object, double> origin) {
  Map<BuildingResource, double> result = Map();
  origin.forEach((o, v) {
    result[o as BuildingResource] = v;
  });

  return result;
}

Map<FoodResource, double> covertToFoodResourceMap(Map<Object, double> origin) {
  Map<FoodResource, double> result = Map();
  origin.forEach((o, v) {
    result[o as FoodResource] = v;
  });
  return result;
}

Map<BuildingExample, int> covertToBuildingExampleMap(Map<Object, int> origin) {
  Map<BuildingExample, int> result = Map();
  origin.forEach((o, v) {
    result[o as BuildingExample] = v;
  });
  return result;
}

Map<CatJob, int> covertToCatJobMap(Map<Object, int> origin) {
  Map<CatJob, int> result = Map();
  origin.forEach((o, v) {
    result[o as CatJob] = v;
  });
  return result;
}

Map<ExpeditionResource, double> covertToExpeditionResourceMap(
    Map<Object, double> origin) {
  Map<ExpeditionResource, double> result = Map();
  origin.forEach((o, v) {
    result[o as ExpeditionResource] = v;
  });
  return result;
}

List<String> covertListToStringList(List<Object> origin) {
  List<String> result = [];
  origin.forEach((o) {
    result.add(o.toString());
  });
  return result;
}

List<Cat> covertListToCatList(List<dynamic> origin) {
  List<Cat> result = [];
  origin.forEach((o) {
    result.add(Cat.fromJSON(jsonDecode((o as String))));
  });
  return result;
}

List<Handicrafts> covertListToHandicraftsList(List<dynamic> origin) {
  List<Handicrafts> result = [];
  origin.forEach((o) {
    result.add(getHandicraftsFromJson(o));
  });
  return result;
}
