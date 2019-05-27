import 'dart:convert';

import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:faker/faker.dart';
import 'package:common_utils/common_utils.dart';

abstract class CatInterface {}

class Cat implements CatInterface {
  String name;
  int exp;
  Age age;
  CatJob originType;
  BloodLines bloodLines;
  String dec;
  int level;
  int sex = 0; //0母猫，1公猫
  CatJob arrange;

  Map<String, dynamic> toJson() => {
        'age': age.toString(),
        'name': name,
        'exp': exp,
        'originType': originType.toString(),
        'BloodLines': bloodLines.toString(),
        'level': level,
        'dec': dec,
        'sex': sex,
        'arrange': arrange.toString()
      };

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }

  Cat(this.name, this.exp, this.age, this.originType, this.bloodLines, this.dec,
      this.level, this.sex, this.arrange);

  factory Cat.fromJSON(Map<String, dynamic> json) {
    return new Cat(
        json['name'],
        json['exp'],
        getAgeFromJson(json['age']),
        getCatJobFromJson(json['originType']),
        getBloodLinesFromJson(json['bloodLines']),
        json['dec'],
        json['level'],
        json['sex'],
        json[getCatJobFromJson(json['arrange'])]);
  }

  void levelUp() {
    level++;
  }
}

enum BloodLines {
  GardenCat, //中华田园猫(0)[0~4]
  AmericanShorthair, //美短(2)[5~8]
  BritishShorthair, //英短(3)[8~11]
  ScottishFold, //折耳猫(1)[12～15]
  Siam, //暹罗(6)[16~17]
  HairlessCat, //无毛猫[18~20]
  MaineCat, //缅因猫[21~23]
  LeopardCat //豹猫[24~25]
}

BloodLines getBloodLinesFromJson(String s) {
  for (BloodLines element in BloodLines.values) {
    if (element.toString() == s || 'Season.${element.toString()}' == s)
      return element;
  }
  return null;
}

Cat createOneCat(Age age) {
  Faker faker = new Faker();
  Cat cat = Cat(faker.person.name(), 0, age, null, null, null, 0,
      FuncUtil().getRandom(1), CatJob.Sleeper);
  int i;
  if (age == Age.Chaos) {
    i = FuncUtil().getRandom(1);
  } else if (age == Age.Stone) {
    i = FuncUtil().getRandom(3);
  } else if (age == Age.Bronze || age == Age.Iron) {
    i = FuncUtil().getRandom(5);
  } else if (age == Age.Feudal) {
    i = FuncUtil().getRandom(7);
  }
  cat.age = age;
  switch (i) {
    case 0:
      cat.originType = CatJob.Farmer;
      break;
    case 1:
      cat.originType = CatJob.Faller;
      break;
    case 2:
      cat.originType = CatJob.Miner;
      break;
    case 3:
      cat.originType = CatJob.Hunter;
      break;
    case 4:
      cat.originType = CatJob.Craftsman;
      break;
    case 5:
      cat.originType = CatJob.Scholar;
      break;
    case 6:
      cat.originType = CatJob.Oracle;
      break;
    case 7:
      cat.originType = CatJob.Actor;
      break;
  }
  cat.name = faker.person.name();
  cat.bloodLines = FuncUtil().getCatBlood();
  cat.dec =
      '${cat.name} ${cat.sex == 1 ? "弟弟" : "妹妹"} 是一只 ${EnumCovert().getBloodName(cat.bloodLines)} , ${EnumCovert().getAmbition(cat.originType)}';
  return cat;
}
