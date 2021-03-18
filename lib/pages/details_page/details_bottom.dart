import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopProject/pages/cart_page.dart';
import 'package:flutter_shopProject/provide/cart.dart';
import 'package:flutter_shopProject/provide/currentIndex.dart';
import 'package:flutter_shopProject/provide/details_info.dart';
import 'package:provide/provide.dart';

class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsInfo =
        Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodsId = goodsInfo.goodsId;
    var goodsName = goodsInfo.goodsName;
    var count = 1;
    var price = goodsInfo.presentPrice;
    var images = goodsInfo.image1;

    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(80),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                  Navigator.pop(context);
                },
                child: Container(
                  width: ScreenUtil().setWidth(110),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Colors.red,
                  ),
                ),
              ),
              Provide<CartProvide>(
                builder: (context, child, value) {
                  int goodsCount =
                      Provide.value<CartProvide>(context).allGoodsCount;
                  return Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(
                            width: 2.0,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        '${goodsCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(22),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CartProvide>(context)
                  .save(goodsId, goodsName, count, price, images);
              await Provide.value<CartProvide>(context).getCartInfo();
            },
            child: Container(
              width: ScreenUtil().setWidth(320),
              alignment: Alignment.center,
              height: ScreenUtil().setHeight(80),
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CartProvide>(context).remove();
              await Provide.value<CartProvide>(context).getCartInfo();
            },
            child: Container(
              width: ScreenUtil().setWidth(320),
              alignment: Alignment.center,
              height: ScreenUtil().setHeight(80),
              color: Colors.red,
              child: Text(
                '立即购买',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
