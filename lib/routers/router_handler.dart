import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shopProject/jpush/jpush.dart';
import 'package:flutter_shopProject/pages/details_page.dart';
import 'package:flutter_shopProject/position/position.dart';

Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    String goodsId = params['id'].first;
    // print('index>details goodsId is ${goodsId} ');
    return DetailsPage(goodsId: goodsId);
  },
);

Handler positionHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return Position();
});

Handler jpushHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return Jpush();
});
