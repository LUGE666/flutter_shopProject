import 'package:flutter/material.dart';
import 'package:flutter_shopProject/model/cartInfo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList = [];
  double allPrice = 0; //总价格
  int allGoodsCount = 0; //商品总数量
  bool isAllCheck = true; //是否全选

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp =
        cartString == null ? [] : json.decode(cartString.toString()); //转换为str
    List<Map> tempList = (temp as List).cast(); //转换为List
    bool isHave = false;
    int ival = 0;
    allPrice = 0; //初始化，增强代码的健壮性
    allGoodsCount = 0; //初始化
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        //判断当前goodsId是否已存在
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      // if (item['isCheck']) {
      //   allPrice += double.parse(
      //       (cartList[ival].price * cartList[ival].count).toStringAsFixed(3));
      //   allGoodsCount += cartList[ival].count;
      // }
      ival++;
    });

    if (!isHave) {
      //当前goodsId不存在
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));

      // allPrice += (count * price);
      // allGoodsCount += count;
    }

    cartString = json.encode(tempList).toString();
    // print('字符串---------$cartString');
    // print('数据模型---------$cartList');

    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    // print('清空完成-----');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;
      tempList.forEach((item) {
        if (item['isCheck']) {
          allPrice +=
              double.parse((item['count'] * item['price']).toStringAsFixed(3));
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    print('getCartInfo $cartList');
    notifyListeners();
  }

  //删除单个购物车商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();
    int tempIndex = 0;
    int delIndex = 0;

    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);

    await getCartInfo();
  }

  //点击全选按钮操作
  changeAllCheckBtn(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();
    List<Map> newList = []; //每次声明list需要初始化，不能直接写newListList<Map>；这样会是用不了add方法
    for (var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }

    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  //商品数量加减
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }

    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
}
