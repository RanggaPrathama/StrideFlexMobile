class WishlistModel{
  late int? idFavorit;
  late int? idDetail;

  WishlistModel({this.idFavorit,this.idDetail});

  factory WishlistModel.fromJson(Map<String,dynamic> data){
    return WishlistModel(
      idFavorit: data['id_favorit'],
      idDetail: data['idDetail_sepatu'],
    );
  }
  
}

List<WishlistModel>? wishlistFromJson(dynamic json){
  final listWish = <WishlistModel>[];
  if(json["data"] != null){
    for (var item in json["data"]){
      listWish.add(WishlistModel.fromJson(item));
    }
  }
  return listWish;
} 