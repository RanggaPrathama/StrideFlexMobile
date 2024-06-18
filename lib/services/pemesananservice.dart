import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/pemesananModel.dart';

class pemesananService {
  Future<List<PemesananModel>?> getPemesanan(
      int idUser, int idPemesanan) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      var url =
          Uri.parse("${Config.baseURL}/pemesanan/${idPemesanan}/${idUser}");
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data != null) {
          return pemesananFromJson(data);
        } else {
          print(response.statusCode);
          throw Exception("Get Pemesanan error");
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
