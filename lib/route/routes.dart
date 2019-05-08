import 'package:fluro/fluro.dart';
import 'package:lovely_cats/Const.dart';
import 'package:lovely_cats/view/GamePage.dart';
import 'package:lovely_cats/view/WelComePage.dart';

class Routes {
  static Router router;
  static String page1 = '/';
  static String page2 = '/game/:data';

  static void configureRoutes(Router router) {
    router.define(page1,
        handler: Handler(handlerFunc: (context, params) => WelcomePage()));
    router.define(page2, handler: Handler(handlerFunc: (context, params) {
      return GamePage(params['data'][0]);
    }));
    Routes.router = router;
  }
}
