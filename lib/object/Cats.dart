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
  CatJob type;
  BloodLines bloodLines;
  String dec;
  int level;

  Map<String, dynamic> toJson() => {
        'age': age,
        'name': name,
        'exp': exp,
        'type': type,
        'BloodLines': BloodLines,
        'level': level,
        'dec': dec,
      };

  @override
  String toString() {
    return 'Cat{name: $name, exp: $exp, age: $age, type: $type, bloodLines: $bloodLines, dec: $dec, level: $level}';
  }

  Cat.fromJSON(Map json)
      : age = json['age'],
        name = json['name'],
        exp = json['exp'],
        type = json['type'],
        bloodLines = json['bloodLines'],
        dec = json['dec'],
        level = json['level'];

  Cat(Age age) {
    int i;
    Faker faker = new Faker();
    if (age == Age.Chaos) {
      i = FuncUtil().getRandom(1);
    } else if (age == Age.Stone || age == Age.Bronze || age == Age.Iron) {
      i = FuncUtil().getRandom(3);
    } else if (age == Age.Feudal) {
      i = FuncUtil().getRandom(4);
    }
    this.age = age;
    switch (i) {
      case 0:
        type = CatJob.Farmer;
        break;
      case 1:
        type = CatJob.Faller;
        break;
      case 2:
        type = CatJob.Craftsman;
        break;
      case 3:
        type = CatJob.Scholar;
        break;
      case 4:
        type = CatJob.Oracle;
        break;
    }

    name = faker.person.name();
    exp = 0;
    bloodLines = FuncUtil().getCatBlood();
    dec =
        '${name} 是一只 ${EnumCovert().getBloodName(bloodLines)} , ${EnumCovert().getAmbition(type)}';
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
