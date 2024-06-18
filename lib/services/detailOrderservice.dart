import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/itemOrderModel.dart';

class DetailOrderService {
  Future<List<ItemOrder>?> getItemOrder(int idPembayaran) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse("${Config.baseURL}/order/item/$idPembayaran");
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return itemOrderFromJson(data);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
