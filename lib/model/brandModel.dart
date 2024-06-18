import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:strideflex_application_1/config.dart';

class BrandModel {
  late int? idbrand;
  late String? namebrand;
  late String? image;
  String ApiUrl = Config.baseURL;
  late int? valueproduct;

  BrandModel({this.idbrand,this.namebrand, this.image, this.valueproduct});

  

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
        idbrand: json["id_brand"],
        namebrand: json['nama_brand'],
        image: json['gambar_brand'],
        valueproduct: int.parse(json['total_sepatu']) );
  }

  String get getImage{
    var url = '$ApiUrl/images/brand/$image';
    //print(url);
    return url;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["id_brand"] = idbrand;
    _data['nama_brand'] = namebrand;
    _data['url_gambar'] = image;
    _data['created_at'] = DateTime.now();
    return _data;
  }
}

// List<BrandModel> brands = [
//   BrandModel(
//     namebrand: "Adidas",
//     image: "assets/brand/adidas.svg",
//     valueproduct: 255,
//   ),
//   BrandModel(
//       namebrand: "Converse",
//       image: "assets/brand/converse.svg",
//       valueproduct: 300),
//   // BrandModel(
//   //     namebrand: "New Balance",
//   //     image: "assets/brand/new_balance.svg",
//   //     valueproduct: 400),
//   BrandModel(
//       namebrand: "Nike", image: "assets/brand/nike.svg", valueproduct: 300),
//   BrandModel(
//       namebrand: "Under Armour",
//       image: "assets/brand/under_armour.svg",
//       valueproduct: 300),
// ];

List<BrandModel> brandFromjson(dynamic json) {
  final brandList = <BrandModel>[];

  if (json['data'] != null) {
    for (var item in json['data']) {
      brandList.add(BrandModel.fromJson(item));
    }
  }
  return brandList;
}
