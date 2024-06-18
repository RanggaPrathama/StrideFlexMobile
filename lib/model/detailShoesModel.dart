import 'package:strideflex_application_1/config.dart';

class DetailShoesModel{
  late int? id_sepatu;
  late int? iddetail_shoes;
  late String? image;
  String apiUrl = Config.baseURL;
  bool isLiked;
  
  DetailShoesModel(
    {
    this.iddetail_shoes,
    this.id_sepatu,
    this.image,
    this.isLiked = false
    
    }
  );

  factory DetailShoesModel.fromJson(Map<String, dynamic> json){

    return DetailShoesModel(
    iddetail_shoes: json["idDetail_sepatu"],
    id_sepatu: json["id_sepatu"],
    image: json["gambar_sepatu"],
    );
  }

  String get imageUrl {
    var tes = '$apiUrl/images/shoes/$image';
    //print('shoes: $tes');
    return tes;
  }

  

}


List<DetailShoesModel> detailFromJson(dynamic json){
  List<DetailShoesModel> detailShoes = [];
  for(var item in json["data"]){
    detailShoes.add(DetailShoesModel.fromJson(item));
  }
  return detailShoes;
}

