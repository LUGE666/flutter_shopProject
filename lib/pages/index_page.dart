import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_shopProject/pages/cart_page.dart';
import 'package:flutter_shopProject/pages/category_page.dart';
import 'package:flutter_shopProject/pages/home_page.dart';
import 'package:flutter_shopProject/pages/member_page.dart';
import 'package:flutter_shopProject/provide/currentIndex.dart';
import 'package:provide/provide.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      // ignore: deprecated_member_use
      title: Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心'),
    ),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Provide<CurrentIndexProvide>(
      builder: (context, child, value) {
        int currentIndex =
            Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items: bottomTabs,
              onTap: (index) {
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
              },
            ),
            body: IndexedStack(
              //保持页面状态
              index: currentIndex,
              children: tabBodies,
            ));
      },
    );
  }
}

// class IndexPage extends StatefulWidget {
//   @override
//   _IndexPageState createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
//   final List<BottomNavigationBarItem> bottomTabs = [
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.home),
//       // ignore: deprecated_member_use
//       title: Text('首页'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.search),
//       title: Text('分类'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.shopping_cart),
//       title: Text('购物车'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.profile_circled),
//       title: Text('会员中心'),
//     ),
//   ];

//   final List<Widget> tabBodies = [
//     HomePage(),
//     CategoryPage(),
//     CartPage(),
//     MemberPage()
//   ];

//   int currentIndex = 0;
//   var currentPage;

//   @override
//   void initState() {
//     //初始化
//     // TODO: implement initState
//     currentPage = tabBodies[currentIndex];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: currentIndex,
//           items: bottomTabs,
//           onTap: (index) {
//             setState(() {
//               currentIndex = index;
//               currentPage = tabBodies[index];
//             });
//           },
//         ),
//         body: IndexedStack(
//           //保持页面状态
//           index: currentIndex,
//           children: tabBodies,
//         ));
//   }
// }
