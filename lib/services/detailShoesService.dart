import 'dart:convert';
import 'dart:io';

import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/detailShoesModel.dart';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/model/shoesModelAPI.dart';

class DetailService {
  var client = http.Client();
  Future<List<DetailShoesModel>?> getDetailShoes(int idshoes) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8'
      };


      var url = Uri.parse("${Config.baseURL}/detail/shoes/$idshoes");

      var response = await client.get(url, headers: header);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print("detail : $data");
        return detailFromJson(data);
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      print('error : $e');
      return null;
    }
  }

  Future<List<ShoesModel>?> getDetailShoesByVersion(int idshoes, int iddetail) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8'
      };

      //  var uri = Uri.http('10.0.2.2:3000', '/shoes', {
      //    'id_sepatu': idshoes.toString(),
      //    'id_detail': iddetail.toString(),
      //  });
      // print(idshoes.runtimeType);
      // print(iddetail.runtimeType);
      var uri = Uri.parse(
          '${Config.baseURL}/shoes/?id_sepatu=$idshoes&id_detail=$iddetail');
      print(uri);
      // var uri = Uri.parse('${Config.baseURL}/shoes/$idshoes/detail/$iddetail');
      var response = await client.get(uri, headers: header);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) ;
        print("aku disini");
        return shoesFromJson(data);
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      print('error : $e');
      return null;
    }
  }
}
