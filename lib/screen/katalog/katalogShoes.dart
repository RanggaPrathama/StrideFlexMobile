import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';

import 'package:strideflex_application_1/model/shoesModelAPI.dart';
import 'package:strideflex_application_1/model/wishListModel.dart';
import 'package:strideflex_application_1/services/wishlistService.dart';

class KatalogShoes extends StatefulWidget {
  const KatalogShoes({Key? key}) : super(key: key);

  static String routeName = "/katalogShoes";
  @override
  State<KatalogShoes> createState() => _KatalogShoesState();
}

class _KatalogShoesState extends State<KatalogShoes> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  late ShoesService _serviceShoes;
  late int id_brand;
  late int idUser;
  final WishListService wishlistService = WishListService();
  List<WishlistModel> wishList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id_brand = 0;

    _serviceShoes = ShoesService();
    refreshPage();
    getUser();
    //print("$id_brand");
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      loadPage();
    });
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "";
    if (token.isNotEmpty) {
      decodeToken(token);
    }
  }

  Future<void> refreshLiked() async {
    await fetchWishList(idUser!);
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    var id_user = payload["id_user"];
    setState(() {
      idUser = id_user;
    });
    fetchWishList(id_user);
  }

  Future<void> fetchWishList(int idUser) async {
    final wishListAPI = await wishlistService.getWishlist(idUser);
    setState(() {
      wishList = wishListAPI ?? [];
    });
  }

  Widget loadPage() {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      id_brand = arguments as int;
      print(id_brand);
    }
    return FutureBuilder(
        future: _serviceShoes.getShoesByIdBrand(id_brand),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var shoesList = snapshot.data;
              if (shoesList == null && shoesList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return dataSepatu(shoesList);
              }
            } else {
              return CircularProgressIndicator();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.zero,
                foregroundColor: Colors.blue,
                elevation: 0,
                backgroundColor: Colors.white),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        title: Text("Katalog Shoes", style: headingText),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
            color: Colors.blue.shade800,
            icon: Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, NotificationScreen.routeName);
              },
              color: Colors.blue.shade800,
              icon: Icon(Icons.notifications_none_rounded)),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refresh,
        color: Colors.white,
        backgroundColor: MyColor.primaryColor,
        onRefresh: refreshPage,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      "assets/image/BannerSepatu.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Shoes Product",
                        style: judul,
                      ),
                    ],
                  ),
                ),
                loadPage()
              ],
            ),
          ]),
        )),
      ),
    );
  }

  Widget dataSepatu(List<ShoesModel> shoesList) {
    final int crossAxisCount = 2;

    // Hitung jumlah baris berdasarkan jumlah item dan jumlah kolom dalam grid
    final int rowCount = (shoesList.length / crossAxisCount).ceil();

    //  tinggi rata-rata setiap item dalam grid
    final double averageItemHeight =
        MediaQuery.of(context).size.width / crossAxisCount;

    // Hitung tinggi total grid
    final double totalHeight = rowCount * averageItemHeight;

    return Container(
      width: double.infinity,
      height: totalHeight,
      child: GridView.builder(
          itemCount: shoesList.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 6),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount),
          itemBuilder: (context, index) {
            var isLiked = wishList.any(
                (item) => item.idDetail == shoesList[index].idDetailSepatu);
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ShoesCard(
                  shoes: shoesList[index],
                  isLiked: isLiked,
                  refreshPage: refreshLiked,
                  idUser: idUser,
                  action: () {
                    Navigator.pushNamed(context, DetailShoes.routeName,
                        arguments: ShoesDetailsArguments(
                            idshoes: shoesList[index].idSepatuVersion,
                            idDetail_sepatu: shoesList[index].idDetailSepatu));
                  }),
            );
          }),
    );
  }
}
