import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
  static String root = '/';
  static String detailsPage = '/detail';
  static String position = '/position';
  static String jpush = '/jpush';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('error===> Route was not fonud');
        return null;
      },
    );

    router.define(detailsPage, handler: detailsHandler);
    router.define(position, handler: positionHandler);
    router.define(jpush, handler: jpushHandler);
  }
}
