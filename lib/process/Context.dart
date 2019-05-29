import 'dart:collection';
import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

class Context {
  Age age; //年代
  Season season; //季节
  Cat leader; //领导喵
  WareHouse wareHouse; //仓库
  Map<BuildingExample, int> buildings; //建筑
  List<Cat> cats; //喵喵s
  int _catsLimit; //人口上限
  Map<CatJob, int> catProfession; //喵子分工
  Map<ExpeditionResource, double> expeditions; //冒险资源
  int gameStartTime; //gameStartTime
  double saturability; //幸福度
  List<Handicrafts> things;
  int gameEndTime; //最后一次储存的事件
  List<String> eventInfos; //发生事件提示

  Context() {
    age = Age.Chaos;
    season = Season.Winter;
    wareHouse = WareHouse();
    buildings = Map();
    cats = List();
    _catsLimit = 0;
    catProfession = Map();
    gameStartTime = DateTime.now().millisecondsSinceEpoch;
    things = List();
    saturability = 1;
    expeditions = Map();
    gameEndTime = DateTime.now().millisecondsSinceEpoch;
    initCatProfession();
    eventInfos = [];
  }

  int get catsLimit => buildings[BuildingExample.chickenCoop] == null
      ? 0
      : buildings[BuildingExample.chickenCoop];

  void initCatProfession() {
    for (CatJob catJob in CatJob.values) {
      catProfession[catJob] = 0;
    }
  }

  void receiveAMessage(String s) {
    if (eventInfos.length < 10) {
      eventInfos.add(s);
    } else {
      eventInfos.removeAt(0);
      eventInfos.add(s);
    }
  }

  Map<String, dynamic> toJson() => {
        'age': age.toString(),
        'season': season.toString(),
        'leader': leader.toString(),
        'wareHouse': wareHouse.toJson(),
        'buildings': new JsonEncoder().convert(covertToStringMapInt(buildings)),
        'cats': jsonEncode(covertListToStringList(cats)),
        'catsLimit': _catsLimit,
        'catProfession':
            new JsonEncoder().convert(covertToStringMapInt(catProfession)),
        'expeditions': expeditions,
        'gameStartTime': gameStartTime,
        'saturability': saturability,
        'things': jsonEncode(covertListToStringList(things)),
        'gameEndTime': gameEndTime,
        'eventInfos': jsonEncode(eventInfos)
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
        _catsLimit = json['catsLimit'],
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
            : covertListToHandicraftsList((jsonDecode(json['things']) as List)),
        eventInfos = (json['eventInfos'] == '[]' || json['eventInfos'] == null)
            ? []
            : covertListToStringList(jsonDecode(json['eventInfos']));
}

class WareHouse {
  Map<FoodResource, double> _foods = Map();
  Map<FoodResource, double> _foodsLimit = Map();
  Map<BuildingResource, double> _buildingMaterials = Map();
  Map<BuildingResource, double> _buildingMaterialsLimit = Map();
  Map<PointResource, double> _points = Map();
  Map<PointResource, double> _pointsLimit = Map();

  Map<Object, double> receiveInfo = Map();

  Map<Object, double> showItem = Map();

  WareHouse() {
    init();
  }

  Map<String, dynamic> toJson() => {
        '_foods': new JsonEncoder().convert(covertToStringMap(_foods)),
        '_foodsLimit':
            new JsonEncoder().convert(covertToStringMap(_foodsLimit)),
        '_buildingMaterials':
            new JsonEncoder().convert(covertToStringMap(_buildingMaterials)),
        '_buildingMaterialsLimit': new JsonEncoder()
            .convert(covertToStringMap(_buildingMaterialsLimit)),
        '_points': new JsonEncoder().convert(covertToStringMap(_points)),
        '_pointsLimit':
            new JsonEncoder().convert(covertToStringMap(_pointsLimit)),
        'receiveInfo':
            new JsonEncoder().convert(covertToStringMap(receiveInfo)),
        'showItem': new JsonEncoder().convert(covertToStringMap(showItem)),
      };

  WareHouse.fromJSON(Map json)
      : receiveInfo = covertToObjectMap(new JsonDecoder()
            .convert(json['_receiveInfo']) as Map<String, dynamic>),
        _pointsLimit = covertToPointMap(covertToObjectMap(new JsonDecoder()
            .convert(json['_pointsLimit']) as Map<String, dynamic>)),
        _points = covertToPointMap(covertToObjectMap(new JsonDecoder()
            .convert(json['_points']) as Map<String, dynamic>)),
        _buildingMaterialsLimit = covertToBuildingResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['_buildingMaterialsLimit'])
                as Map<String, dynamic>)),
        _buildingMaterials = covertToBuildingResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['_buildingMaterials'])
                as Map<String, dynamic>)),
        _foodsLimit = covertToFoodResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['_foodsLimit'])
                as Map<String, dynamic>)),
        _foods = covertToFoodResourceMap(covertToObjectMap(
            new JsonDecoder().convert(json['_foods']) as Map<String, dynamic>)),
        showItem = covertToObjectMap(new JsonDecoder().convert(json['showItem'])
            as Map<String, dynamic>);

  void init() {
    List<FoodResource> food = FoodResource.values;
    for (FoodResource resource in food) {
      _foods[resource] = 400;
      _foodsLimit[resource] = 7500;
    }
    List<BuildingResource> build = BuildingResource.values;
    for (BuildingResource resource in build) {
      _buildingMaterials[resource] = 0;
      _buildingMaterialsLimit[resource] = 300;
    }

    List<PointResource> point = PointResource.values;
    for (PointResource resource in point) {
      _points[resource] = 0;
      _pointsLimit[resource] = 300;
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
      _foods[o] = Arith().subtraction(_foods[o], require);
    }
    if (o is BuildingResource) {
      _buildingMaterials[o] =
          Arith().subtraction(_buildingMaterials[o], require);
    }
    if (o is PointResource) {
      _points[o] = Arith().subtraction(_points[o], require);
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
      return _foods[o] >= value;
    }
    if (o is BuildingResource) {
      return _buildingMaterials[o] >= value;
    }
    if (o is PointResource) {
      return _points[o] >= value;
    }
    return true;
  }

  ///更新上一秒中[收获的资源]数值
  void updateObjectReceive(Object o, double) {
    receiveInfo[o] = double;
  }

  ///获取所有item
  List<Object> getShowItems() {
    _foods.forEach((key, value) {
      if (value != null && value > 0 && !showItem.containsKey(key)) {
        showItem[key] = -1;
      }
    });
    _buildingMaterials.forEach((key, value) {
      if (value != null && value > 0) {
        showItem[key] = -1;
      }
    });
    _points.forEach((key, value) {
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
      if (!_points.containsKey(o)) {
        _points[o] = 0;
      }
      return _points[o];
    } else if (o is BuildingResource) {
      if (!_buildingMaterials.containsKey(o)) {
        _buildingMaterials[o] = 0;
      }
      return _buildingMaterials[o];
    } else if (o is FoodResource) {
      if (!_foods.containsKey(o)) {
        _foods[o] = 0;
      }
      return _foods[o];
    } else {
      return 0.0;
    }
  }

  ///获取仓库资源存量上限
  double getItemReservesLimit(Object o) {
    if (o is PointResource) {
      return _pointsLimit[o];
    } else if (o is BuildingResource) {
      return _buildingMaterialsLimit[o];
    } else if (o is FoodResource) {
      return _foodsLimit[o];
    } else {
      return 0.0;
    }
  }

  ///收取猫薄荷
  void receiveCatmint(double d, bool isHandwork) {
    if (_foods[FoodResource.catmint] + d <= _foodsLimit[FoodResource.catmint]) {
      _foods[FoodResource.catmint] =
          Arith().add(_foods[FoodResource.catmint], d);
    } else {
      _foods[FoodResource.catmint] = _foodsLimit[FoodResource.catmint];
    }
    if (!isHandwork) {
      double receive =
          Arith().subtraction(d, 4.5 * Application.gameContext.cats.length);
      receiveInfo[FoodResource.catmint] =
          NumUtil.getNumByValueDouble(receive, 2);
    }
  }

  ///收取树枝
  void receiveBranch(double d, bool isHandwork) {
    if (_buildingMaterials[BuildingResource.branch] + d <
        _buildingMaterialsLimit[BuildingResource.branch]) {
      _buildingMaterials[BuildingResource.branch] =
          Arith().add(_buildingMaterials[BuildingResource.branch], d);
    } else {
      _buildingMaterials[BuildingResource.branch] =
          _buildingMaterialsLimit[BuildingResource.branch];
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

List<String> covertListToStringList(List<dynamic> origin) {
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
