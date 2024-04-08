import 'package:strideflex_application_1/model/shoesModel.dart';

class CartModel {
  late ShoesModel shoesproduct;
  late int quantity;

  CartModel({required this.shoesproduct, required this.quantity});
}

List<CartModel> cartList = [
  CartModel(shoesproduct: shoes[0], quantity: 2),
  CartModel(shoesproduct: shoes[1], quantity: 3),
  CartModel(shoesproduct: shoes[2], quantity: 4),
  CartModel(shoesproduct: shoes[3], quantity: 5),
  CartModel(shoesproduct: shoes[4], quantity: 6),
];
