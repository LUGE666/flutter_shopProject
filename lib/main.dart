import 'package:flutter/material.dart'; //UI样式、谷歌的纸墨设计风格
import 'package:flutter/cupertino.dart'; //苹果ios的设计风格
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopProject/pages/index_page.dart';
import 'package:flutter_shopProject/provide/cart.dart';
import 'package:flutter_shopProject/provide/category_goods_list.dart';
import 'package:flutter_shopProject/provide/child_category.dart';
import 'package:flutter_shopProject/provide/counter.dart';
import 'package:flutter_shopProject/provide/currentIndex.dart';
import 'package:flutter_shopProject/provide/details_info.dart';
import 'package:flutter_shopProject/routers/application.dart';
import 'package:flutter_shopProject/routers/routers.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';

void main() {
  //将状态管理模块放入顶层
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();

  var providers = Providers();

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(
        Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));

  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = FluroRouter(); //路由声明
    Routes.configureRoutes(router);
    Application.router = router;

    return ScreenUtilInit(
      //屏幕适配
      designSize: Size(750, 1334),
      allowFontScaling: false,
      builder: () => Container(
        //在外面嵌套一个Container使得以后扩展组件变得容易
        child: MaterialApp(
          title: '百姓生活+',
          onGenerateRoute: Application.router.generator,
          debugShowCheckedModeBanner: false, //去掉默认的debug
          theme: ThemeData(primaryColor: Colors.pink),
          home: IndexPage(),
        ),
      ),
    );
  }
}
