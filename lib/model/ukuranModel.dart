class UkuranModel {
  late int? idstok;
  late int? iddetail;
  late int? idsepatu;
  late int? idukuran;
  late int? stok;
  late int? nomorUkuran;

  UkuranModel(
      {this.idstok,this.idsepatu, this.iddetail, this.idukuran, this.stok, this.nomorUkuran});

  factory UkuranModel.fromJson(Map<String, dynamic> json) {
    return UkuranModel(
        idstok: json["id_stok"],
        iddetail: json["id_detail"],
        idukuran: json["id_ukuran"],
        idsepatu : json["id_sepatu"],
        stok: json["stok"],
        nomorUkuran: json["nomor_ukuran"]);
  }
}

List<UkuranModel> UkuranfromJson(dynamic json) {
  final data = <UkuranModel>[];
  if (json["data"] != null) {
    for (var item in json["data"]) {
      data.add(UkuranModel.fromJson(item));
    }
  }
  return data;
}
