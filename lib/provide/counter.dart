import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int value = 0;

  increment() {
    value++;
    notifyListeners(); //通知监听者，然后进行局部刷新小组件
  }
}
