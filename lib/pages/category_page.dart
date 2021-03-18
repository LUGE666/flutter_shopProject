import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopProject/model/categoryGoodsList.dart';
import 'package:flutter_shopProject/model/categroy.dart';
import 'package:flutter_shopProject/provide/category_goods_list.dart';
import 'package:flutter_shopProject/provide/child_category.dart';
import 'dart:convert';

import 'package:flutter_shopProject/service/service_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CateGoryPageState createState() => _CateGoryPageState();
}

class _CateGoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: [RightCategoryNavState(), CategoryGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 1;

  @override
  void initState() {
    _getCategory();
    _getGoodsList(categoryId: '1'); //初始化不输入ID使页面默认调用ID为1的啤酒页面
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftinkWell(index);
        },
      ),
    );
  }

  Widget _leftinkWell(int index) {
    bool isChick = false;
    isChick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodsList(categoryId: categoryId); //可选参数必须带key值，不然会报错
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isChick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      // print('-------$value');
      CategoryModel category = CategoryModel.fromJson(value['data']['page']);
      // print('-------${category.data}');
      setState(() {
        list = category.data;
        Provide.value<ChildCategory>(context)
            .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      });
    });
  }

  //大类请求
  void _getGoodsList({String categoryId}) {
    var data = {
      'categoryId': categoryId == null ? '1' : categoryId,
      'categorySubId': '2c9f6c94621970a801626a3770620177',
      'page': 1
    };

    request('getMallGoods', formData: data).then((value) {
      var data = value['data']['name'];
      // print(data is Map);
      // print('>>>>:$data');
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // print('分类商品列表 : ${goodsList.data[0].goodsName}');
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);
    });
  }
}

//二级导航：小类右侧导航
class RightCategoryNavState extends StatefulWidget {
  @override
  _RightCategoryNavStateState createState() => _RightCategoryNavStateState();
}

class _RightCategoryNavStateState extends State<RightCategoryNavState> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        // print('-------$childCategory');
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(
                    index, childCategory.childCategoryList[index]);
              }),
        );
      },
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  //小类请求
  void _getGoodsList(String categorySubId) {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };

    request('getMallGoods', formData: data).then((value) {
      var data = value['data']['name'];
      // print(data is Map);
      // print('>>>>:$data');
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // print('分类商品列表 : ${goodsList.data[0].goodsName}');
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(goodsList.data);
      }
    });
  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  var scorllController = new ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(builder: (context, child, data) {
      //在build里面写业务逻辑
      try {
        if (Provide.value<ChildCategory>(context).page == 1) {
          //列表位置，放到最上边
          scorllController.jumpTo(0.0);
        }
      } catch (e) {
        // print('进入页面第一次初始化：$e');
      }
      if (data.goodsList.length > 0) {
        //判断数据是否为空
        return Expanded(
          //Expanded继承于flexible，具有伸缩能力，主要解决高度溢出的bug
          child: Container(
            width: ScreenUtil().setWidth(570),
            // height: ScreenUtil().setHeight(1000),
            child: EasyRefresh(
              header: ClassicalHeader(),
              footer: ClassicalFooter(
                  // key: _footerkey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  infoColor: Colors.pink,
                  showInfo: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  loadingText: '加载中',
                  loadReadyText: '准备加载'),
              child: ListView.builder(
                  controller: scorllController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listItemWidget(data.goodsList, index);
                  }),
              onLoad: () async {
                // print('上拉加载');
                _getMoreList();
              },
            ),
          ),
        );
      } else {
        return Text('暂时没有数据');
      }
    });
  }

  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage(); //先增加页数
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    request('getMallGoods', formData: data).then((value) {
      var data = value['data']['name'];

      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Fluttertoast.showToast(
            //提示组件
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER, //提示位置
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0);
        Provide.value<ChildCategory>(context).changeNoMoreText('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '：￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _listItemWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }
}
