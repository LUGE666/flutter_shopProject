import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopProject/config/http_headers.dart';
import 'package:flutter_shopProject/routers/application.dart';
import 'package:flutter_shopProject/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];
  // GlobalKey<RefreshFooterState> _footerkey =
  //     new GlobalKey<RefreshFooterState>();

  //保持页面状态
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // print('页面加载');
  }

  String homePageContent = 'kais';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Application.router.navigateTo(context, '/position');
              },
              child: Icon(Icons.person_pin_circle_outlined),
            ),
            InkWell(
              onTap: () {
                Application.router.navigateTo(context, '/jpush');
              },
              child: Icon(Icons.pan_tool_rounded),
            )
          ],
        ),
        body: FutureBuilder(
          //更好的处理future的异步数据
          // future: getHomePageContent(),
          future: request('homePageContent'),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print(snapshot.data['data']['name']);
              // var data = json.decode(snapshot.data['data']['name']);
              var data = snapshot.data['data']['name'];
              // print(data is Map);
              List<Map> swiper = (data['image'] as List).cast();
              List<Map> navigatorList = (data['image'] as List).cast();
              String adPicture = data['content']['ad'];
              String leaderImage = data['content']['leaderImage'];
              String leaderPhone = data['content']['leaderPhone'];
              List<Map> recommendList =
                  (data['content']['recommend'] as List).cast();
              String pictrueAddress = data['content']['pictrue_address'];
              List<Map> floorList =
                  (data['content']['floorGoods'] as List).cast();
              // print(swiper);
              return EasyRefresh(
                //上拉加载
                header: ClassicalHeader(),
                footer: ClassicalFooter(
                    // key: _footerkey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    infoColor: Colors.pink,
                    showInfo: true,
                    noMoreText: '',
                    loadingText: '加载中',
                    loadReadyText: '准备加载'),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDateList: swiper),
                    TopNavigator(navigatorList: navigatorList),
                    AdBanner(adPicture: adPicture),
                    LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone,
                    ),
                    Recommend(recommendList: recommendList),
                    FloorTitle(pictrueAddress: pictrueAddress),
                    FloorContent(floorGoodsList: floorList),
                    _hotGoods()
                  ],
                ),
                onLoad: () async {
                  // print('加载');
                  var formData = {'page': page};
                  request('homePageBelowContent', formData: formData)
                      .then((value) {
                    // print(value);
                    // var data = json.decode(value.toString());
                    List<Map> newGoodsList =
                        (value['data']['page'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
              );
            } else {
              return Center(
                child: Text(
                  '加载中',
                  style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  //火爆专区,获取热销商品数据
  // void _getHotGods() {
  //   var formData = {'page': page};
  //   request('homePageBelowContent', formData: formData).then((value) {
  //     // print(value);
  //     // var data = json.decode(value.toString());
  //     List<Map> newGoodsList = (value['data']['page'] as List).cast();
  //     setState(() {
  //       hotGoodsList.addAll(newGoodsList);
  //       page++;
  //     });
  //   });
  // }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    //流式布局
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((value) {
        return InkWell(
          onTap: () {
            // print('goodsId-----$value');
            Application.router
                .navigateTo(context, '/detail?id=${value['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  value['img'],
                  width: ScreenUtil().setWidth(370),
                ),
                Text(
                  value['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${value['price']}'),
                    Text(
                      '￥${value['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('无数据');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }
}

//轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({Key key, this.swiperDateList});

  @override
  Widget build(BuildContext context) {
    // print('Device width dp:${1.sw}dp');
    // print('Device height dp:${1.sh}dp');
    // print('Device pixel density（设备像数密度）:${ScreenUtil().pixelRatio}');
    // print('设备的高）:${ScreenUtil().screenHeight}');
    // print('设备的宽:${ScreenUtil().screenWidth}');
    // print('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    // print('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    // print('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    // print(
    //     'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}');
    // print('System font scaling:${ScreenUtil().textScaleFactor}');
    // print('0.5 times the screen width:${0.5.sw}dp');
    // print('0.5 times the screen height:${0.5.sh}dp');

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(
                  context, '/detail?id=${swiperDateList[index]['goodsId']}');
            },
            child: Image.network(
              '${swiperDateList[index]['img']}',
              fit: BoxFit.fill,
            ),
          );
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//栅格组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: [
          Image.network(
            item['img'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['title'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), //禁止回弹，防止与easyrefresh冲突
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告组件
class AdBanner extends StatelessWidget {
  final String adPicture;

  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    // String url = 'http://www.baidu.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  //内置标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独项方法
  Widget _item(context, index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(
            context, '/detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['img']),
            Text('￥${recommendList[index]['price']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表方法
  Widget _recommendList() {
    return Container(
        height: ScreenUtil().setHeight(250),
        margin: EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(context, index);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String pictrueAddress;

  FloorTitle({Key key, this.pictrueAddress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictrueAddress),
    );
  }
}

//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _firstRow(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(BuildContext context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          Application.router
              .navigateTo(context, '/detail?id=${goods['goodsId']}');
        },
        child: Image.network(goods['img']),
      ),
    );
  }
}

//火爆专区 已作为_HomePageState的私有方法
// class HotGoods extends StatefulWidget {
//   @override
//   _HotGoodsState createState() => _HotGoodsState();
// }

// class _HotGoodsState extends State<HotGoods> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getHomePageBelowContent().then((value) {
//       print(value);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Text('kk'));
//   }
// }
