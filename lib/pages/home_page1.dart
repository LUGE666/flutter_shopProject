import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  String showText = '还没有请求数据';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('请求远程数据'),
        ),
        body: SingleChildScrollView(
          //解决弹出键盘越界的问题
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: '美女类型',
                      helperText: '请输入'),
                  autofocus: false,
                ),
                RaisedButton(
                  onPressed: () {
                    _chiceAction();
                  },
                  child: Text('xuanwan'),
                ),
                Text(
                  showText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _chiceAction() {
    print('开始选择');
    if (typeController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('不能为空'),
        ),
      );
    } else {
      getHttp(typeController.text.toString()).then((value) {
        setState(() {
          showText = value['data']['name'].toString();
        });
      });
    }
  }

  Future getHttp(String typeText) async {
    try {
      Response response;
      var data = {'name': typeText};
      response = await Dio().post(
          'https://mock.mengxuegu.com/mock/6043b9e1f340b05bceda396b/flutter_mallproject/example1',
          queryParameters: data);
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}
