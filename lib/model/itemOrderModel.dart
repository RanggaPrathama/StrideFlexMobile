import 'package:strideflex_application_1/config.dart';

class ItemOrder {
  late int idPembayaran;
  late int status;
  late String gambar_sepatu;
  late String nama_sepatu;
  late int subtotal;
  late String warna;
  String apiUrl = Config.baseURL;
  late int quantity;
  late int nomor_ukuran;

  ItemOrder({
    required this.idPembayaran,
    required this.status,
    required this.gambar_sepatu,
    required this.nama_sepatu,
    required this.subtotal,
    required this.warna,
    required this.quantity,
    required this.nomor_ukuran,
  });
  factory ItemOrder.fromJson(Map<String, dynamic> data) {
    return ItemOrder(
      idPembayaran: data['id_pembayaran'],
      status: data['status'],
      gambar_sepatu: data['gambar_sepatu'],
      nama_sepatu: data['nama_sepatu'],
      subtotal: data['subtotal'],
      warna: data['warna'],
      quantity: data['quantity'],
      nomor_ukuran: data['nomor_ukuran'],
    );
  }

  String get imageUrl {
    var tes = '$apiUrl/images/shoes/$gambar_sepatu';
    return tes;
  }
}

List<ItemOrder> itemOrderFromJson(dynamic json) {
  final itemOrderList = <ItemOrder>[];
  if (json['data'] != null) {
    for (var data in json['data']) {
      itemOrderList.add(ItemOrder.fromJson(data));
    }
  }
  return itemOrderList;
}
