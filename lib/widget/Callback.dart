import 'package:lovely_cats/object/Cats.dart';

abstract class Callback {
  void callBack();

  void receiveACat(Cat c) {}

  void catLeave(Cat c);
}
