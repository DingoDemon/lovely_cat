import 'dart:collection';

import 'package:lovely_cats/process/Context.dart';
import 'package:lovely_cats/util/FuncUtil.dart';

class RandomEvent {
  static final RandomEvent instance = new RandomEvent.internal();

  factory RandomEvent() {
    return instance;
  }

  RandomEvent.internal();

  Queue<Event> stacks = new Queue();

  Event popOneEvent(Context c) {
    if (stacks.isEmpty) {
      makeTenEvent();
    }
    return stacks.removeLast();
  }

  void makeTenEvent() {
    for (int i = 0; i < 10; i++) {

    }
  }
}

enum Event {
  getAFlower,//(1/100)喵喵闻到花香，全体工作效率提升1.2倍
  hearASong,//(2/100)远处传来奇妙的歌声，喵喵干活更有劲了(农夫效率提升1.2)
  windComing,//(3/100)清风徐来，图书馆里的喵喵静下心来了(学者工作效率提升1.2)
  lemonComing,//柠檬精来了，喵喵讨厌柠檬！丢下手中的工作，回到家中(全部停工)
  butterfly,//蝴蝶来了，工厂里的喵喵翩翩起舞(工人效率提升1.2)



}

