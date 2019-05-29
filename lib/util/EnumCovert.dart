import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';

class EnumCovert {
  static final EnumCovert _singleton = new EnumCovert._internal();

  factory EnumCovert() {
    return _singleton;
  }

  EnumCovert._internal();

  String getEnumName(Object o) {
    if (o is BuildingExample) {
      return getBuildingName(o);
    } else if (o is BuildingResource) {
      return getBuildResourceName(o);
    } else if (o is FoodResource) {
      return getFoodName(o);
    } else {
      return "";
    }
  }

  String getBuildingName(BuildingExample b) {
    switch (b) {
      case BuildingExample.catmintField:
        return "猫薄荷田";
      case BuildingExample.chickenCoop:
        return "鸡窝";
      case BuildingExample.loggingCamp:
        return "伐木喵厂";
      case BuildingExample.box:
        return "纸盒子";
      case BuildingExample.refinery:
        return "喵の加工厂";
      case BuildingExample.coalMine:
        return "煤矿";
      case BuildingExample.college:
        return "喵喵学院";
      case BuildingExample.cattery:
        return "猫窝";
      case BuildingExample.advancedCattery:
        return "猫别墅";
      case BuildingExample.library:
        return "喵书馆";
      case BuildingExample.university:
        return "喵喵大学";
      case BuildingExample.researchInstitute:
        return "喵の研究院";
      case BuildingExample.mineField:
        return "矿场";
      case BuildingExample.warehouse:
        return "仓库";
      case BuildingExample.workbench:
        return "工作台";
    }
  }

  String getFoodName(FoodResource f) {
    switch (f) {
      case FoodResource.catmint:
        return "猫薄荷";
      default:
        return "";
    }
  }

  Color getEnumShowColor(Object o) {
    if (o is FoodResource) {
      return Colors.green[600];
    } else if (o is BuildingResource) {
      return Colors.cyan[600];
    } else if (o is PointResource) {
      return Colors.purple[300];
    } else {
      return Colors.blue;
    }
  }

  String getBuildResourceName(BuildingResource b) {
    switch (b) {
      case BuildingResource.branch:
        return "树枝";
      case BuildingResource.beam:
        return "木梁";
      case BuildingResource.cement:
        return "水泥";
      case BuildingResource.iron:
        return "铁";
      case BuildingResource.steel:
        return "钢";
      case BuildingResource.stone:
        return "骨头";
      default:
        return "";
    }
  }

  String getBloodName(BloodLines b) {
    switch (b) {
      case BloodLines.AmericanShorthair:
        return "美国短毛喵";
      case BloodLines.BritishShorthair:
        return "英国短毛喵";
      case BloodLines.GardenCat:
        return "三花喵";
      case BloodLines.HairlessCat:
        return "无毛喵";
      case BloodLines.LeopardCat:
        return "稀有的豹喵";
      case BloodLines.MaineCat:
        return "缅因喵";
      case BloodLines.ScottishFold:
        return "苏格兰折耳喵";
      case BloodLines.Siam:
        return "暹罗喵";
      default:
        return "";
    }
  }

  String getAmbition(CatJob type) {
    switch (type) {
      case CatJob.Farmer:
        return "它的工作就是找到好吃的并吃掉";
      case CatJob.Craftsman:
        return "它说，铸铁需要七七四十八道工序";
      case CatJob.Actor:
        return "它的偶像是辛巴";
      case CatJob.Oracle:
        return "它遇事不决的时候，就会请教喵喵神";
      case CatJob.Scholar:
        return "它对世间万物具有强烈的好奇心";
      case CatJob.Hunter:
        return "狩猎哪里是为了生存，更重要的是抓住猎物的满足感";
      case CatJob.Faller:
        return "嘿哟嘿哟嘿哟伐木喵～!";
      case CatJob.Miner:
        return '咦呀!!咦呀!!挖矿喵';
      case CatJob.Sleeper:
        return '';
    }
  }

  String getAmbitionName(CatJob type) {
    switch (type) {
      case CatJob.Farmer:
        return "农学喵";
      case CatJob.Craftsman:
        return "工匠喵";
      case CatJob.Actor:
        return "领导喵";
      case CatJob.Oracle:
        return "祭祀喵";
      case CatJob.Scholar:
        return "学者喵";
      case CatJob.Faller:
        return '砍树喵';
      case CatJob.Hunter:
        return '猎喵';
      case CatJob.Miner:
        return '挖矿喵';
      case CatJob.Sleeper:
        return '懒觉喵';
    }
  }

  String getAgeName(Age a) {
    switch (a) {
      case Age.Chaos:
        return "混沌喵代";
      case Age.Bronze:
        return "青铜喵代";
      case Age.Stone:
        return "石器喵代";
      case Age.Feudal:
        return "封建喵代";
      case Age.Industry:
        return "工业革命";
      case Age.Iron:
        return "铁器喵代";
      case Age.Modern:
        return "摩登喵代";
      case Age.Space:
        return "太空喵代";

      default:
        return "";
    }
  }

  String getSeasonName(Season s) {
    switch (s) {
      case Season.Spring:
        return "懒洋洋的春天";
      case Season.Summer:
        return "闷闷热的夏天";
      case Season.Fall:
        return "困乏乏的秋天";
      case Season.Winter:
        return "冷飕飕的冬天";
      default:
        return "";
    }
  }

  String getHandicraftsName(Handicrafts h) {
    switch (h) {
      case Handicrafts.zax:
        return "石斧";
    }
  }

  Season getNextSeason(Season current) {
    switch (current) {
      case Season.Spring:
        return Season.Summer;
      case Season.Summer:
        return Season.Fall;
      case Season.Fall:
        return Season.Winter;
      case Season.Winter:
        return Season.Spring;
      default:
        return Season.Spring;
    }
  }

  String getResourceReceiveInfo(Object o) {
    if (o is FoodResource) {
      return getFoodReceiveInfo(o);
    } else if (o is BuildingResource) {
      return getBuildingResourceReceiveInfo(o);
    } else if (o is PointResource) {
      return getPointResourceReceiveInfo(o);
    } else {
      return "";
    }
  }

  String getFoodReceiveInfo(FoodResource f) {
    return '${NumUtil.getNumByValueDouble(Application.gameContext.wareHouse.getItemReserves(f), 2)} '
        '/ '
        '${NumUtil.getNumByValueDouble(Application.gameContext.wareHouse.getItemReserves(f), 2)}';
  }

  String getBuildingResourceReceiveInfo(BuildingResource b) {
    return '${NumUtil.getNumByValueDouble(Application.gameContext.wareHouse.getItemReserves(b), 2)} '
        '/'
        ' ${NumUtil.getNumByValueDouble(Application.gameContext.wareHouse.getItemReserves(b), 2)}';
  }

  String getPointResourceReceiveInfo(PointResource p) {
    return '${NumUtil.getNumByValueDouble(Application.gameContext.wareHouse.getItemReserves(p), 2)} '
        '/'
        ' ${NumUtil.getNumByValueDouble(Application.gameContext.wareHouse.getItemReserves(p), 2)}';
  }

  String getBuildIconPath(BuildingExample b) {
    switch (b) {
      case BuildingExample.researchInstitute:
        return "";
      case BuildingExample.refinery:
        return "";
      case BuildingExample.loggingCamp:
        return "images/building_03.png";
      case BuildingExample.college:
        return "";
      case BuildingExample.library:
        return "";
      case BuildingExample.cattery:
        return "";
      case BuildingExample.box:
        return "";
      case BuildingExample.chickenCoop:
        return "images/building_01.png";
      case BuildingExample.advancedCattery:
        return "";
      case BuildingExample.catmintField:
        return "images/building_02.png";
      case BuildingExample.mineField:
        return "";
      case BuildingExample.university:
        return "";
      case BuildingExample.coalMine:
        // TODO: Handle this case.
        break;
      case BuildingExample.warehouse:
        // TODO: Handle this case.
        break;
      case BuildingExample.workbench:
        // TODO: Handle this case.
        break;
    }
  }
}
