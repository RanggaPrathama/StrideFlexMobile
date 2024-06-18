import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/model/cartModel.dart';

class CartService {
  Future<List<CartModel>?> getCart(int id_user) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      var url = Uri.parse("${Config.baseURL}/cart/${id_user}");
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return getCartFromJson(data);
      }
    } catch (e) {
      print("error : $e");
    }
  }
}
