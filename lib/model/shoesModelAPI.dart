import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:strideflex_application_1/config.dart';

// List<Color> color = [
//    Colors.black,
//         Colors.red,
//         Colors.white,
//         Colors.yellow,
// ];
class ShoesModel {
  late int? idSepatuVersion;
  late int? idDetailSepatu;
  late String? nameShoes;
  late String? warna;
  late int? hargaSepatu;
  late String? description;
  late String? image;
  String apiUrl = Config.baseURL;
  late bool isLiked;

  ShoesModel({
    this.idSepatuVersion,
    this.idDetailSepatu,
    this.nameShoes,
    this.warna,
    this.hargaSepatu,
    this.description,
    this.image,
    this.isLiked = false,
  });

  factory ShoesModel.fromJson(Map<String, dynamic> json) {
    // late List<Color> color;

    // color = [
    //   Colors.black,
    //   Colors.red,
    //   Colors.white,
    //   Colors.yellow,
    // ];

    return ShoesModel(
        idSepatuVersion: json["id_sepatu"],
        idDetailSepatu: json["idDetail_sepatu"],
        nameShoes: json["nama_sepatu"],
        hargaSepatu: json["harga_sepatu"] != null
            ? int.parse(json["harga_sepatu"].toString())
            : null,
        description: json["deskripsi_sepatu"],
        image: json["gambar_sepatu"],
        warna: json["warna"]
        // kategoriUmur: json["jenis_kelamin"] != null
        //     ? int.parse(json["jenis_kelamin"].toString())
        //     : null,
        );
  }

  String get imageUrl {
    var tes = '$apiUrl/images/shoes/$image';
    //print('shoes: $tes');
    return tes;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["id_sepatu"] = idSepatuVersion;
    _data["idDetail_sepatu"] = idDetailSepatu;
    _data["nama_sepatu"] = nameShoes;
    _data["harga_sepatu"] = hargaSepatu;
    _data["deskripsi_sepatu"] = description;
    _data["gambar_sepatu"] = image;
    _data["warna"] = warna;
    return _data;
  }
}

//List<ShoesModel> shoesFromJson(dynamic json) => List<ShoesModel>.from((json).map((x)=> ShoesModel.fromJson(x)));
// List<ShoesModel> shoesFromJson(dynamic json) =>
//     List<ShoesModel>.from((json).map((x) => ShoesModel.fromJson(x)));

List<ShoesModel> shoesFromJson(dynamic json) {
  final shoesList = <ShoesModel>[];
  if (json['data'] != null) {
    for (var item in json['data']) {
      shoesList.add(ShoesModel.fromJson(item));
    }
  }
  return shoesList;
}


class ShoesSearch{
  late int? idSepatuVersion;
  late int? idDetailSepatu;
  late String? nameShoes;
  late String? warna;

  ShoesSearch({
     this.idSepatuVersion,
    this.idDetailSepatu,
    this.nameShoes,
    this.warna,
  });

   factory ShoesSearch.fromJson(Map<String, dynamic> json) {
    return ShoesSearch(
        idSepatuVersion: json["id_sepatu"],
        idDetailSepatu: json["idDetail_sepatu"],
        nameShoes: json["nama_sepatu"],
        warna: json["warna"]
        // kategoriUmur: json["jenis_kelamin"] != null
        //     ? int.parse(json["jenis_kelamin"].toString())
        //     : null,
        );
  }
  
}

List<ShoesSearch> shoesSearchFromJson(dynamic json) {
  final shoesList = <ShoesSearch>[];
  if (json['data'] != null) {
    for (var item in json['data']) {
      shoesList.add(ShoesSearch.fromJson(item));
    }
  }
  return shoesList;
}