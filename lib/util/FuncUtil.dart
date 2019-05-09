import 'dart:collection';
import 'dart:math';

import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';

class FuncUtil {
  static final FuncUtil _singleton = new FuncUtil._internal();

  FuncUtil._internal();

  factory FuncUtil() {
    return _singleton;
  }

  int getRandom(int max) {
    Random random = new Random();
    return random.nextInt(max);
  }

  double getRandomDouble() {
    Random random = new Random();
    double result = random.nextDouble();
    return result == 0 ? getRandomDouble() : result * 3;
  }

  BloodLines getCatBlood() {
    Random random = new Random();
    int i = random.nextInt(25);
    if (i <= 4) {
      return BloodLines.GardenCat;
    } else if (i > 4 && i <= 8) {
      return BloodLines.AmericanShorthair;
    } else if (i > 8 && i <= 11) {
      return BloodLines.BritishShorthair;
    } else if (i > 11 && i <= 15) {
      return BloodLines.ScottishFold;
    } else if (i > 15 && i <= 17) {
      return BloodLines.Siam;
    } else if (i > 17 && i <= 20) {
      return BloodLines.HairlessCat;
    } else if (i > 21 && i <= 23) {
      return BloodLines.HairlessCat;
    } else {
      return BloodLines.HairlessCat;
    }
  }

  double saturability(int catsNum, double happinessResource) {
    double denominator = 100;
    double numerator = 100 - (catsNum * catsNum / 10) + happinessResource;
    if (numerator < 0) {
      return 0.01;
    } else {
      return double.parse((numerator / denominator).toStringAsFixed(2));
    }
  }

  double happiness(LinkedHashMap<ExpeditionResource, double> expeditions) {
    return 0;
  }
}
