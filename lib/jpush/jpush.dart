import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class Jpush extends StatefulWidget {
  @override
  _JpushState createState() => _JpushState();
}

class _JpushState extends State<Jpush> {
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print('....接受到推送');
        setState(() {
          debugLable = '接受到推送${message}';
        });
      });
    } on PlatformException {
      platformVersion = '平台版本获取失败';
    }

    if (!mounted) return;
    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('极光推送'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('结果:${debugLable}'),
              FlatButton(
                  onPressed: () {
                    var fireDate = DateTime.fromMillisecondsSinceEpoch(
                        DateTime.now().millisecondsSinceEpoch + 3000);
                    var localNotification = LocalNotification(
                        id: 234,
                        title: 'hh',
                        buildId: 1, //创建的id
                        content: '推送内容',
                        fireTime: fireDate,
                        subtitle: '一个测试');

                    jpush
                        .sendLocalNotification(localNotification)
                        .then((value) {
                      setState(() {
                        debugLable = value;
                      });
                    });
                  },
                  child: Text('发送推送信息'))
            ],
          ),
        ),
      ),
    );
  }
}
