import 'dart:collection';
import 'dart:math';

import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/Arith.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

import '../application.dart';
import 'ResourceEnum.dart';

class RandomEvent {
  static final RandomEvent instance = new RandomEvent.internal();

  factory RandomEvent() {
    return instance;
  }

  RandomEvent.internal();

  CatEvent event;
  int times;

  void makeCatEventOneIfNone() {
    if (Application.gameContext.cats.isEmpty) {
      return;
    }
    if (event != null) {
      if (times > 0) {
        times--;
      } else {
        Const.farmerCat = Const.farmerCatOrigin;
        Const.fallerCat = Const.fallerCatOrigin;
        this.event = null;
        Application.gameContext.receiveAMessage('喵喵恢复常态');
      }
    } else {
      int seed = FuncUtil().getRandom(399);
      if (seed > 388) {
        int times = FuncUtil().getRandomWithMin(21, 10);
        CatEvent event = getEvent();
        switch (event) {
          case CatEvent.getAFlower:
            Const.farmerCat *= 1.5;
            Const.fallerCat *= 1.5;
            Application.gameContext.receiveAMessage('喵喵闻到花香，全体工作效率提升1.5倍');
            break;
          case CatEvent.hearASong:
            Const.farmerCat *= 1.5;
            Application.gameContext
                .receiveAMessage('远处传来奇妙的歌声，喵喵干活更有劲了(农夫效率提升1.5)');
            break;
          case CatEvent.lemonComing:
            Const.farmerCat = 0;
            Const.fallerCat = 0;
            Application.gameContext
                .receiveAMessage('柠檬精来了，喵喵讨厌柠檬！丢下手中的工作，回到家中(全部停工)');
            break;
          case CatEvent.butterfly:
            // TODO: Handle this case.
            break;
          case CatEvent.windComing:
            // TODO: Handle this case.
            break;
        }
        this.event = event;
        this.times = times;
      } else {
        if (seed == 67 || seed == 28) {
          Random random = new Random();
          double result = random.nextDouble();
          Application.gameContext.wareHouse
              .receiveBranch(Arith().multiplication(result, 100), false);
          Application.gameContext.receiveAMessage(
              '一个旅喵过来歇了歇脚，留下了${Arith().multiplication(result, 100)}树枝作为答谢');
        }
      }
    }
  }

  CatEvent getEvent() {
    Age age = Application.gameContext.age;
    if (age == Age.Chaos || age == Age.Stone) {
      return FuncUtil().getRandom(2) == 1
          ? CatEvent.getAFlower
          : CatEvent.hearASong;
    }
  }
}

enum CatEvent {
  getAFlower, //(0/100)喵喵闻到花香，全体工作效率提升1.5倍 1
  hearASong, //(1/100)远处传来奇妙的歌声，喵喵干活更有劲了(农夫效率提升1.5) 1
  lemonComing, //(3/100)柠檬精来了，喵喵讨厌柠檬！丢下手中的工作，回到家中(全部停工) 1
  butterfly, //(4/100)蝴蝶来了，工厂里的喵喵翩翩起舞(工人效率提升1.5) 2
  windComing, //(2/100)清风徐来，图书馆里的喵喵静下心来了(学者工作效率提升1.5) 2

}
