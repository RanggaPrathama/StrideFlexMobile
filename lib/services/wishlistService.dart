import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:strideflex_application_1/config.dart';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/model/wishListModel.dart';

class WishListService {
  Future<List<WishlistModel>?> getWishlist(int idUser) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      var url = Uri.parse("${Config.baseURL}/wishList/$idUser");
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return wishlistFromJson(data);
      } else {
        throw Exception('Failed to Access Ukuran');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> addWishlist(int idUser, int idDetail) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      var url = Uri.parse("${Config.baseURL}/addWishlist");
      var response = await http.post(url,
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            "id_user": idUser,
            "idDetail_sepatu": idDetail
          }));
      var data = jsonDecode(response.body);
      if (data["message"] == "Success WishList Created") {
        return data;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteWishlist(int idUser, int idDetail) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var url = Uri.parse("${Config.baseURL}/deleteWishlist/$idUser/$idDetail");
    var response = await http.delete(url, headers: headers);
    var data = jsonDecode(response.body);
    if (data["message"] == "wishList delete successfully") {
      return data;
    }
  }
}
