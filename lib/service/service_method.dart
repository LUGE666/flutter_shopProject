import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_shopProject/config/servcie_url.dart';

//设置通用请求方法
Future request(url, {formData}) async {
  try {
    print('开始获取数据');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = "application/x-www-form-urlencoded";
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], queryParameters: formData);
    }

    // print(response.data);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    return print('error:===> $e');
  }
}

//获取首页主题内容
// Future getHomePageContent() async {
//   try {
//     print('开始');
//     Response response;
//     Dio dio = new Dio();
//     dio.options.contentType = "application/x-www-form-urlencoded";
//     var formData = {'lon': '115.02932', 'lat': '35.76189'};
//     response = await dio.post(servicePath['homePageContent']);
//     // print(response.data);

//     if (response.statusCode == 200) {
//       return response.data;
//     } else {
//       throw Exception('后端接口出现异常');
//     }
//   } catch (e) {
//     return print('error:===> $e');
//   }
// }

//获取火爆专区商品的方法
// Future getHomePageBelowContent() async {
//   try {
//     Response response;
//     Dio dio = new Dio();
//     dio.options.contentType = "application/x-www-form-urlencoded";
//     var page = {'page': 1};
//     response = await dio.post(servicePath['homePageBelowContent'],
//         queryParameters: page);
//     // print(response.data);

//     if (response.statusCode == 200) {
//       return response.data;
//     } else {
//       throw Exception('后端接口出现异常');
//     }
//   } catch (e) {
//     return print('error:===> $e');
//   }
// }
