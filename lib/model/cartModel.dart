import 'package:strideflex_application_1/config.dart';

class CartModel {
  late int? idCart;
  late int? stok_id_stok;
  late int? idUser;
  late int? quantity;
  String apiUrl = Config.baseURL;
  late String? namaBrand;
  late String? sepatuVersion;
  late String? warna;
  late int? hargaSepatu;
  late String? gambarSepatu;
  late int? nomorUkuran;

  CartModel(
      {this.idCart,
      this.stok_id_stok,
      this.idUser,
      this.quantity,
      this.namaBrand,
      this.sepatuVersion,
      this.warna,
      this.hargaSepatu,
      this.gambarSepatu,
      this.nomorUkuran});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      idCart: json['id_cart'],
      stok_id_stok: json['stok_id_stok'],
      idUser: json['user_id_user'],
      quantity: json['quantity'],
      namaBrand: json['nama_brand'],
      sepatuVersion: json['nama_sepatu'],
      warna: json['warna'],
      hargaSepatu: json['harga_sepatu'],
      gambarSepatu: json['gambar_sepatu'],
      nomorUkuran: json['nomor_ukuran'],
    );
  }

  String get imageUrl {
    return "$apiUrl/images/shoes/$gambarSepatu";
  }

  Map<String, dynamic> toJson() {
    return {
      'idCart': idCart,
      'quantity': quantity,
      'hargaSepatu': hargaSepatu,
      'stok_id_stok': stok_id_stok,
    };
  }
}

List<CartModel> getCartFromJson(dynamic json) {
  List<CartModel> cart = [];
  if (json["data"] != null) {
    for (var item in json["data"]) {
      cart.add(CartModel.fromJson(item));
    }
  }

  return cart;
}
