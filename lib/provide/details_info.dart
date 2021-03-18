import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_shopProject/model/details.dart';
import 'package:flutter_shopProject/service/service_method.dart';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo;

  bool isLeft = true;
  bool isRight = false;

  //tabbar的切换方法
  changLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  //从后台获取商品数据
  getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((value) {
      // var responseData = json.decode(value.toString());
      var responseData = value['data']['name'];
      // print('responseData----$responseData');
      goodsInfo = DetailsModel.fromJson(responseData);
      // print('goodsInfo ---$goodsInfo');
      notifyListeners();
    });
  }
}
