import 'dart:collection';

import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/EnumCovert.dart';

import 'ResourceEnum.dart';

class Things {
  static final Things _singleton = new Things._internal();

  factory Things() {
    return _singleton;
  }

  Things._internal();

  Interceptor getInterceptor(Handicrafts t) {
    switch (t) {
      case Handicrafts.zax:
        return new ZaxInterceptor(BuildingExample.chickenCoop,
            EnumCovert().getHandicraftsName(Handicrafts.zax));
    }
  }
}

abstract class Interceptor {
  BuildingExample buildingExample;
  String tag;

  Map<Object, double> changeBuildResourceRequire(
      Map<Object, double> originBuildResource);

  Map<Object, double> changeOutPut(Map<Object, double> output);

  @override
  int get hashCode => tag.hashCode;

  @override
  bool operator ==(other) {
    return other is Interceptor && other.tag == tag;
  }

  Interceptor(this.buildingExample, this.tag);
}

class ZaxInterceptor extends Interceptor {
  ZaxInterceptor(BuildingExample buildingExample, String tag)
      : super(buildingExample, tag);

  @override
  Map<Object, double> changeBuildResourceRequire(
      Map<Object, double> originBuildResource) {
    return originBuildResource;
  }

  @override
  Map<Object, double> changeOutPut(Map<Object, double> output) {

    return null;
  }
}
