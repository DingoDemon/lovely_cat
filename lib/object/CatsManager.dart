import 'dart:collection';

import 'package:lovely_cats/object/ResourceEnum.dart';

class CatsManager {
  static final CatsManager instance = new CatsManager.internal();

  factory CatsManager() {
    return instance;
  }

  CatsManager.internal();

  HashMap<CatType, int> hashMap = new HashMap();


}
