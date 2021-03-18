import 'package:flutter/foundation.dart';

//数据模型

//自己写的
// class CategoryBidModel {
//   String mallCategoryId;
//   String mallCategoryName;
//   List<dynamic> boxMallSubDto;
//   String comments;
//   String image;

//   CategoryBidModel({
//     this.mallCategoryId,
//     this.mallCategoryName,
//     this.boxMallSubDto,
//     this.comments,
//     this.image,
//   });

//   factory CategoryBidModel.fromJson(dynamic json) {
//     return CategoryBidModel(
//         mallCategoryId: json['mallCategoryId'],
//         mallCategoryName: json['mallCategoryName'],
//         boxMallSubDto: json['boxMallSubDto'],
//         comments: json['comments'],
//         image: json['image']);
//   }
// }

// class CategoryBigListModel {
//   List<CategoryBidModel> data;
//   CategoryBigListModel(this.data);

//   factory CategoryBigListModel.fromJson(List json) {
//     return CategoryBigListModel(
//         json.map((e) => CategoryBidModel.fromJson((e))).toList());
//   }
// }

//根据json to dart 自动生成的
class CategoryModel {
  String _code;
  String _message;
  List<CategoryData> _data;

  CategoryModel({String code, String message, List<CategoryData> data}) {
    this._code = code;
    this._message = message;
    this._data = data;
  }

  String get code => _code;
  set code(String code) => _code = code;
  String get message => _message;
  set message(String message) => _message = message;
  List<CategoryData> get data => _data;
  set data(List<CategoryData> data) => _data = data;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _message = json['message'];
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      _data = new List<CategoryData>();
      json['data'].forEach((v) {
        _data.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  String _mallCategoryId;
  String _mallCategoryName;
  List<BxMallSubDto> _bxMallSubDto;
  Null _comments;
  String _image;

  CategoryData(
      {String mallCategoryId,
      String mallCategoryName,
      List<BxMallSubDto> bxMallSubDto,
      Null comments,
      String image}) {
    this._mallCategoryId = mallCategoryId;
    this._mallCategoryName = mallCategoryName;
    this._bxMallSubDto = bxMallSubDto;
    this._comments = comments;
    this._image = image;
  }

  String get mallCategoryId => _mallCategoryId;
  set mallCategoryId(String mallCategoryId) => _mallCategoryId = mallCategoryId;
  String get mallCategoryName => _mallCategoryName;
  set mallCategoryName(String mallCategoryName) =>
      _mallCategoryName = mallCategoryName;
  List<BxMallSubDto> get bxMallSubDto => _bxMallSubDto;
  set bxMallSubDto(List<BxMallSubDto> bxMallSubDto) =>
      _bxMallSubDto = bxMallSubDto;
  Null get comments => _comments;
  set comments(Null comments) => _comments = comments;
  String get image => _image;
  set image(String image) => _image = image;

  CategoryData.fromJson(Map<String, dynamic> json) {
    _mallCategoryId = json['mallCategoryId'];
    _mallCategoryName = json['mallCategoryName'];
    if (json['bxMallSubDto'] != null) {
      // ignore: deprecated_member_use
      _bxMallSubDto = new List<BxMallSubDto>();
      json['bxMallSubDto'].forEach((v) {
        _bxMallSubDto.add(new BxMallSubDto.fromJson(v));
      });
    }
    _comments = json['comments'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallCategoryId'] = this._mallCategoryId;
    data['mallCategoryName'] = this._mallCategoryName;
    if (this._bxMallSubDto != null) {
      data['bxMallSubDto'] = this._bxMallSubDto.map((v) => v.toJson()).toList();
    }
    data['comments'] = this._comments;
    data['image'] = this._image;
    return data;
  }
}

class BxMallSubDto {
  String _mallSubId;
  String _mallCategoryId;
  String _mallSubName;
  String _comments;

  BxMallSubDto(
      {String mallSubId,
      String mallCategoryId,
      String mallSubName,
      String comments}) {
    this._mallSubId = mallSubId;
    this._mallCategoryId = mallCategoryId;
    this._mallSubName = mallSubName;
    this._comments = comments;
  }

  String get mallSubId => _mallSubId;
  set mallSubId(String mallSubId) => _mallSubId = mallSubId;
  String get mallCategoryId => _mallCategoryId;
  set mallCategoryId(String mallCategoryId) => _mallCategoryId = mallCategoryId;
  String get mallSubName => _mallSubName;
  set mallSubName(String mallSubName) => _mallSubName = mallSubName;
  String get comments => _comments;
  set comments(String comments) => _comments = comments;

  BxMallSubDto.fromJson(Map<String, dynamic> json) {
    _mallSubId = json['mallSubId'];
    _mallCategoryId = json['mallCategoryId'];
    _mallSubName = json['mallSubName'];
    _comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallSubId'] = this._mallSubId;
    data['mallCategoryId'] = this._mallCategoryId;
    data['mallSubName'] = this._mallSubName;
    data['comments'] = this._comments;
    return data;
  }
}
