import 'package:flutter/material.dart';
import 'package:flutter_shopProject/model/categroy.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '1'; //大类ID
  String subId = ''; //小类
  int page = 1; //列表页数
  String noMoreText = ''; //显示没有数据的文字

  getChildCategory(List<BxMallSubDto> list, String id) {
    page = 1;
    noMoreText = '';
    //每次点击大类的时候都把子类索引归零
    childIndex = 0;
    categoryId = id;

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';

    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
  changChildIndex(index, String id) {
    page = 1;
    noMoreText = '';
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  //增加page的方法
  addPage() {
    page++;
  }

  //改变noMoreText的方法
  changeNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
