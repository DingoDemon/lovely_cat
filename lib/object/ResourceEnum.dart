//食物资源
enum FoodResource { catmint }

//建筑资源
enum BuildingResource {
  branch, //树枝
  beam, //树干
  stone,
  iron,
  steel,
  cement //水泥
}

enum PointResource {
  huntPoint,
  sciencePoint,
  religionPoint,
}

enum BuildingExample {
  catmintField, //猫粮牧场
  chickenCoop, //鸡窝
  box, //纸盒子
  tent, //帐篷
  logCabin, //小木屋
  cattery, //猫窝
  advancedCattery, //高级猫窝
  library, //图书馆
  university, //大学
  researchInstitute, //研究院
  loggingCamp, //伐木场
  mineField //矿场
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

enum CatType {
  Farmer, //农民，提升农田产量(0)
  Leader, //领导，提升领导才能(1)
  Craftsman, //工匠，提升建筑产出(2)
  Scholar, //学者，提升科技点(3)
  Oracle //先知，提升宗教点(4)
}

enum CatJob { Farmer, Craftsman, Scholar, Hunter, Oracle }

//神祇
class GodResource {}

//喵子
class CatResource {}

enum Age { Chaos, Stone, Bronze, Iron, Feudal, Industry, Modern, Space }

enum God { Dingo, Yoyo, Neo }

enum Season { Spring, Summer, Fall, Winter }
