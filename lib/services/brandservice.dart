import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/brandModel.dart';


class BrandService{
  var client = http.Client();

  Future<List<BrandModel>?>  getBrand() async {

    try {
      Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var url = Uri.parse('${Config.baseURL}/brand');

    var response = await client.get(url,headers: headers);
    
    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print('TesBrand : $data');
      return brandFromjson(data);
      
    }
    else{
      throw Exception('Failed to load Brand');
    }
    } catch (e) {
      print(e);
      return null;
    }
    
  }

}