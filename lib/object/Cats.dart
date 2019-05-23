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

  //各项系数
  double agriculturalOutput = 1;
  double happinessOutput = 1;
  double industryOutput = 1;
  double scienceOutput = 1;
  double religionOutput = 1;

  factory Cat(Age age) {
    int i;

    Cat cat = new Cat(age);
    Faker faker = new Faker();
    if (age == Age.Chaos) {
      i = FuncUtil().getRandom(1);
    } else if (age == Age.Stone || age == Age.Bronze || age == Age.Iron) {
      i = FuncUtil().getRandom(3);
    } else if (age == Age.Feudal) {
      i = FuncUtil().getRandom(4);
    }
    switch (i) {
      case 0:
        cat.type = CatJob.Farmer;
        cat.agriculturalOutput = Const.CAT_DEFAULT_SKILL;
        break;
      case 1:
        cat.type = CatJob.Leader;
        cat.happinessOutput = Const.CAT_DEFAULT_SKILL;
        break;
      case 2:
        cat.type = CatJob.Craftsman;
        cat.industryOutput = Const.CAT_DEFAULT_SKILL;
        break;
      case 3:
        cat.type = CatJob.Scholar;
        cat.scienceOutput = Const.CAT_DEFAULT_SKILL;
        break;
      case 4:
        cat.type = CatJob.Oracle;
        cat.religionOutput = Const.CAT_DEFAULT_SKILL;
        break;
      default:
    }

    cat.name = faker.person.name();
    cat.exp = 0;
    cat.bloodLines = FuncUtil().getCatBlood();
    cat.dec =
        '${cat.name} 是一只 ${EnumCovert().getBloodName(cat.bloodLines)} , ${EnumCovert().getAmbition(cat.type)}';
    return cat;
  }

  void levelUp() {
    switch (type) {
      case CatJob.Farmer:
        this.agriculturalOutput = Arith().multiplication(agriculturalOutput, 2);
        break;
      case CatJob.Craftsman:
        industryOutput = Arith().multiplication(industryOutput, 1.5);
        break;
      case CatJob.Leader:
        happinessOutput = Arith().multiplication(happinessOutput, 1.1);
        break;
      case CatJob.Oracle:
        religionOutput = Arith().multiplication(religionOutput, 1.5);
        break;
      case CatJob.Scholar:
        scienceOutput = Arith().multiplication(scienceOutput, 1.5);
        break;
      default:
    }
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
