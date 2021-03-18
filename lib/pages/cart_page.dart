import 'package:flutter/material.dart';
import 'package:flutter_shopProject/pages/cart_page/cart_bottom.dart';
import 'package:flutter_shopProject/pages/cart_page/cart_item.dart';
import 'package:flutter_shopProject/provide/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provide/provide.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List cartList = Provide.value<CartProvide>(context).cartList;
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, childCategory) {
                    cartList = Provide.value<CartProvide>(context).cartList;
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return CartItem(cartList[index]);
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();

    return 'end';
  }
}

// 持久化案例
// class CartPage extends StatefulWidget {
//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   List<String> testList = [];
//   @override
//   Widget build(BuildContext context) {
//     _show();
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: 500.0,
//             child: ListView.builder(
//                 itemCount: testList.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(testList[index]),
//                   );
//                 }),
//           ),
//           RaisedButton(
//             onPressed: () {
//               _add();
//             },
//             child: Text('增加'),
//           ),
//           RaisedButton(
//             onPressed: () {
//               _clear();
//             },
//             child: Text('清空'),
//           )
//         ],
//       ),
//     );
//   }

//   //增加方法
//   void _add() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String temp = 'hh';
//     testList.add(temp);

//     //持久化处理
//     prefs.setStringList('testInfo', testList);
//     _show();
//   }

//   //查询
//   void _show() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getStringList('testInfo') != null) {
//       setState(() {
//         testList = prefs.getStringList('testInfo');
//       });
//     }
//   }

//   //删除
//   void _clear() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     //全部删除
//     // prefs.clear();

//     //移除key
//     prefs.remove('testInfo');
//     setState(() {
//       testList = [];
//     });
//   }
// }
