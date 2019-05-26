//食物资源
enum FoodResource { catmint }

FoodResource getFoodResourceFromJson(String s) {
  for (FoodResource element in FoodResource.values) {
    if (element.toString() == s || 'FoodResource.${element.toString()}' == s)
      return element;
  }
  return null;
}

//建筑资源
enum BuildingResource {
  branch, //树枝
  beam, //树干
  stone,
  iron,
  steel,
  cement, //水泥
  gold
}

BuildingResource getBuildingResourceFromJson(String s) {
  for (BuildingResource element in BuildingResource.values) {
    if (element.toString() == s ||
        'BuildingResource.${element.toString()}' == s) return element;
  }
  return null;
}

enum PointResource {
  huntPoint,
  sciencePoint,
  religionPoint,
}

PointResource getPointResourceFromJson(String s) {
  for (PointResource element in PointResource.values) {
    if (element.toString() == s || 'PointResource.${element.toString()}' == s)
      return element;
  }
  return null;
}

enum BuildingExample {
  catmintField, //猫粮牧场
  chickenCoop, //鸡窝
  box, //纸盒子（快乐）
  refinery, //提炼厂
  coalMine, //煤矿
  college, //学院
  cattery, //猫窝
  advancedCattery, //高级猫窝
  library, //图书馆
  university, //大学
  researchInstitute, //研究院
  loggingCamp, //伐木场
  mineField, //矿场
  warehouse //仓库
}

BuildingExample getBuildingExampleFromJson(String s) {
  for (BuildingExample element in BuildingExample.values) {
    if (element.toString() == s || 'BuildingExample.${element.toString()}' == s)
      return element;
  }
  return null;
}

//探险资源
enum ExpeditionResource {
  glowworm, //萤火虫
  mushroom, //蘑菇
  Hamimelon, //哈密瓜
  grape, //葡萄
  birdsLeg, //鸟腿
  mouse, //老鼠
  ivory, //象牙

}

ExpeditionResource getExpeditionResourceFromJson(String s) {
  for (ExpeditionResource element in ExpeditionResource.values) {
    if (element.toString() == s ||
        'ExpeditionResource.${element.toString()}' == s) return element;
  }
  return null;
}

enum CatJob {
  Farmer, //农民
  Faller, //伐木工

  Miner, //矿工
  Hunter, //猎人

  Craftsman, //手工艺人
  Scholar, //学者

  Oracle, //先知
  Actor, //演员，快乐产出

}

CatJob getCatJobFromJson(String s) {
  for (CatJob element in CatJob.values) {
    if (element.toString() == s || 'CatJob.${element.toString()}' == s)
      return element;
  }
  return null;
}

enum Handicrafts {
  zax, //石斧
}

Handicrafts getHandicraftsFromJson(String s) {
  for (Handicrafts element in Handicrafts.values) {
    if (element.toString() == s || 'Handicrafts.${element.toString()}' == s)
      return element;
  }
  return null;
}

//神祇
class GodResource {}

//喵子
class CatResource {}

enum Age { Chaos, Stone, Bronze, Iron, Feudal, Industry, Modern, Space }

Age getAgeFromJson(String s) {
  for (Age element in Age.values) {
    if (element.toString() == s || 'Age.${element.toString()}' == s)
      return element;
  }
  return null;
}

enum God { Dingo, Yoyo, Neo }

enum Season { Spring, Summer, Fall, Winter }

Season getSeasonFromJson(String s) {
  for (Season element in Season.values) {
    if (element.toString() == s || 'Season.${element.toString()}' == s)
      return element;
  }
  return null;
}

Object getFromString(String s) {
  if (getFoodResourceFromJson(s) != null) {
    return getFoodResourceFromJson(s);
  } else if (getBuildingResourceFromJson(s) != null) {
    return getBuildingResourceFromJson(s);
  } else if (getPointResourceFromJson(s) != null) {
    return getPointResourceFromJson(s);
  } else if (getBuildingExampleFromJson(s) != null) {
    return getBuildingExampleFromJson(s);
  } else if (getExpeditionResourceFromJson(s) != null) {
    return getExpeditionResourceFromJson(s);
  } else if (getCatJobFromJson(s) != null) {
    return getCatJobFromJson(s);
  } else if (getAgeFromJson(s) != null) {
    return getAgeFromJson(s);
  } else if (getSeasonFromJson(s) != null) {
    return getSeasonFromJson(s);
  }
}
