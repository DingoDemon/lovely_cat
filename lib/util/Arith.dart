import 'package:common_utils/common_utils.dart';

class Arith {
  static final Arith _singleton = new Arith._internal();

  factory Arith() {
    return _singleton;
  }

  Arith._internal();

  double add(double a, double b) {
    return NumUtil.getNumByValueDouble(a + b, 2);
  }

  double subtraction(double a, double b) {
    return NumUtil.getNumByValueDouble(a - b, 2);
  }

  double multiplication(double a, double b) {
    return NumUtil.getNumByValueDouble(a * b, 2);
  }

  double division(double a, double b) {
    return NumUtil.getNumByValueDouble(a / b, 2);
  }
}
