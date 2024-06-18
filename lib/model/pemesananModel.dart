import 'package:strideflex_application_1/config.dart';

class PemesananModel {
  late int idPemesanan;
  late int idDetail_pemesanan;
  late String gambar_sepatu;
  late String nama_sepatu;
  late int harga_sepatu;
  late int subtotal;
  late String warna;
  String apiUrl = Config.baseURL;
  late int quantity;
  late int nomor_ukuran;

  PemesananModel({
    required this.idPemesanan,
    required this.idDetail_pemesanan,
    required this.gambar_sepatu,
    required this.nama_sepatu,
    required this.harga_sepatu,
    required this.subtotal,
    required this.warna,
    required this.quantity,
    required this.nomor_ukuran,
  });
  factory PemesananModel.fromJson(Map<String, dynamic> data) {
    return PemesananModel(
      idPemesanan: data['pemesanan_id_pemesanan'],
      idDetail_pemesanan: data['idDetail_pemesanan'],
      gambar_sepatu: data['gambar_sepatu'],
      nama_sepatu: data['nama_sepatu'],
      harga_sepatu: data['harga_sepatu'],
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

List<PemesananModel> pemesananFromJson(dynamic json) {
  final pemesananList = <PemesananModel>[];
  if (json['data'] != null) {
    for (var data in json['data']) {
      pemesananList.add(PemesananModel.fromJson(data));
    }
  }
  return pemesananList;
}
