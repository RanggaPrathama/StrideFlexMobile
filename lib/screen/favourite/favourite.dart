import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';
import 'package:strideflex_application_1/model/wishListModel.dart';
import 'package:strideflex_application_1/services/wishlistService.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final WishListService wishlistService = WishListService();
  final ShoesService shoesService = ShoesService();
  int? idUser;
  List<ShoesModel> shoesList = [];
  List<WishlistModel> wishList = [];
  List<ShoesModel> favoriteShoes = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token != null && token.isNotEmpty) {
      decodeToken(token);
    } else {
      Navigator.pushReplacementNamed(context, Login.routeName);
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int idUserPayload = payload["id_user"];
    setState(() {
      idUser = idUserPayload;
    });
    fetchWishList(idUserPayload);
  }

  Future<void> fetchShoesList() async {
    try {
      final shoesListAPI = await shoesService.getShoes();
      setState(() {
        shoesList = shoesListAPI ?? [];
        favoriteShoes = shoesList
            .where((shoe) =>
                wishList.any((wish) => wish.idDetail == shoe.idDetailSepatu))
            .toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchWishList(int idUser) async {
    final wishListAPI = await wishlistService.getWishlist(idUser);
    setState(() {
      wishList = wishListAPI ?? [];
    });
    fetchShoesList();
  }

  Future<void> refreshPage() async {
    print("cie aku masuk");
    await fetchWishList(idUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("WishList", style: headingText),
      ),
      body: SafeArea(
        child: favoriteShoes.isEmpty
            ? VerifNotif(
                image: "assets/icon/favorite.png",
                text: "There is no wish list yet",
              )
            : GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 6,
                ),
                itemCount: favoriteShoes.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  var isLiked = wishList.any(
                    (wish) =>
                        wish.idDetail == favoriteShoes[index].idDetailSepatu,
                  );
                  isLiked = isLiked ?? false;
                  return ShoesCard(
                    shoes: favoriteShoes[index],
                    isLiked: isLiked,
                    idUser: idUser!,
                    refreshPage: refreshPage,
                    action: () {
                      Navigator.pushNamed(
                        context,
                        DetailShoes.routeName,
                        arguments: ShoesDetailsArguments(
                          idshoes: favoriteShoes[index].idSepatuVersion,
                          idDetail_sepatu: favoriteShoes[index].idDetailSepatu,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
