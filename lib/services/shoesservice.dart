import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';

class ShoesService {
  var client = http.Client();
  Future<List<ShoesModel>?> getShoes() async {
    try {
      //
      //String geturlshoes = "/shoes";
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      // var url = Uri.http(
      //   Config.baseURL,
      //   geturlshoes,
      // );

      var config = Config.baseURL;
      var url2 = Uri.parse("$config/shoes");

      var response = await client.get(
        url2,
        headers: requestHeaders,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print("Tes: $data");
        return shoesFromJson(data);
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      print("error : $e");
      return null;
    }
  }

  Future<List<ShoesModel>?> getShoesByIdBrand(int id_brand) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var config = Config.baseURL;
      var url2 = Uri.parse("$config/shoes/brand/$id_brand");
      var response = await client.get(url2, headers: requestHeaders);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print("Tes: $data");
        return shoesFromJson(data);
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      print("error : $e");
      return null;
    }
  }

  Future<List<ShoesSearch>?> getShoesByQuery(String query) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json",
      };

      //print("query : $query");

      var url = Uri.parse("${Config.baseURL}/shoes?nama_sepatu=$query");

      var response = await client.get(url, headers: header);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print("data search: $data");
        return shoesSearchFromJson(data);
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      print("error : $e");
      return null;
    }
  }

  Future<List<ShoesModel>?> getShoesByGender(int idbrand, int gender) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      var url = Uri.parse("${Config.baseURL}/shoes/gender/$idbrand/$gender");

      var response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return shoesFromJson(data);
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
