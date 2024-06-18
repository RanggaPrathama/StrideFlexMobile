import 'dart:convert';
import 'dart:io';

import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/ukuranModel.dart';
import 'package:http/http.dart' as http;

class UkuranService{

  var client = http.Client();
  Future<List<UkuranModel>?> getUkuranByIdDetail(int iddetail) async {
    try {
      
      Map<String,String> header = {
        'Content-Type': 'application/json',
        
      };
      var url = Uri.parse("${Config.baseURL}/ukuran/detail/$iddetail");
      var response = await client.get(url, headers: header);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return UkuranfromJson(data);
      }else{
        throw Exception('Failed to Access Ukuran');
      }
    } catch (e) {
      print(e);
      return null;
    }
  } 
}