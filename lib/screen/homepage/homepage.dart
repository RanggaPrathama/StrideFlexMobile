import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/brandModel.dart';
//import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';
import 'package:strideflex_application_1/model/wishListModel.dart';
import 'package:strideflex_application_1/screen/katalog/katalogShoes.dart';
import 'package:strideflex_application_1/services/brandservice.dart';
import 'package:strideflex_application_1/services/wishlistService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static String routeName = "/homepage";
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int brandDipilih = 0;
  late String _token;
  late ShoesService service;
  late BrandService serviceBrand;
  String? namaUser;
  int? idUser;
  final WishListService wishlistService = WishListService();
  List<WishlistModel> wishList = [];
  Map<String, dynamic> userList = {};

  @override
  void initState() {
    super.initState();
    _getToken();
    service = ShoesService();
    serviceBrand = BrandService();
    refreshPage();
  }

  Future<void> fetchWishList(int idUser) async {
    final wishListAPI = await wishlistService.getWishlist(idUser);
    if (mounted) {
      setState(() {
        wishList = wishListAPI ?? [];
      });
      print(wishListAPI);
    }
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    if (mounted) {
      setState(() {
        _token = token ?? '';
      });
    }

    if (token.isNotEmpty) {
      decodeToken(token);
    } else {
      Navigator.pushReplacementNamed(context, Login.routeName);
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    String username = payload["nama_user"];
    int id_user = payload["id_user"];

    if (mounted) {
      setState(() {
        namaUser = username;
        idUser = id_user;
        fetchWishList(idUser!);
        getUserAPI(idUser!);
      });
    }
  }

  Future<void> getUserAPI(int idUser) async {
    var url = Uri.parse("${Config.baseURL}/profile/$idUser");
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var data = json["data"];
      if (mounted) {
        setState(() {
          userList = data;
        });
      }
      print(userList);
    }
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 1));
    await _getToken();
    await loadPage();
    await loadBrand();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> refreshLiked() async {
    print("cie aku masuk");
    await fetchWishList(idUser!);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // ShoesService().getShoes().then((value) => {
    //       // Mengecek jika value tidak null
    //       if (value != null)
    //         {
    //           // Iterasi melalui setiap objek ShoesModelAPI dalam List
    //           for (var shoes in value) {
    //             print("ID Sepatu: ${shoes.price}")}
    //         }
    //       else
    //         {print("Data sepatu kosong")}
    //     });

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x4D39D2C0),
              border: Border.all(
                color: Colors.blue.shade400,
                width: 2.5,
              ),
              // image: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: AssetImage("assets/image/fotoku.jpg"),
              // ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: userList["gambar_profile"] != null &&
                        userList["gambar_profile"] != ""
                    ? Image.network(
                        "${Config.baseURL}/images/profile/${userList["gambar_profile"]}",
                        fit: BoxFit.cover)
                    : Image.asset("assets/image/user.png", fit: BoxFit.cover)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome !! 😍',
              style: TextStyle(fontSize: 16),
            ),
            userList["nama_user"] != null
                ? Text(
                    '${userList["nama_user"]}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                : Text(
                    'loading..',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
          ],
        ),
        actions: <Widget>[
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          color: Colors.white,
          backgroundColor: MyColor.primaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SearchHome(),
                SizedBox(height: 10),
                SliderHome(),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Featured Brands",
                        style: judul,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                loadBrand(),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Favorites Shoes",
                        style: judul,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                loadPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadBrand() {
    return FutureBuilder(
      future: serviceBrand.getBrand(),
      builder:
          (BuildContext context, AsyncSnapshot<List<BrandModel>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final brandList = snapshot.data;
            if (brandList == null || brandList.isEmpty) {
              return Center(
                child: Text('No data Brand'),
              );
            } else {
              return dataBrand(brandList);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget dataBrand(List<BrandModel> brandList) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ...List.generate(
                brandList.length,
                (index) => Padding(
                      padding: EdgeInsets.only(right: 10, left: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            brandDipilih = index;
                          });
                          Navigator.pushNamed(context, KatalogShoes.routeName,
                              arguments: brandList[index].idbrand);
                        },
                        child: ListBrand(
                          brand: brandList[index],
                          dipilih: index == brandDipilih,
                        ),
                      ),
                    ))
          ],
        ),
      ),
    );
  }

  Widget loadPage() {
    return FutureBuilder(
        future: service.getShoes(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ShoesModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            final shoesList = snapshot.data;
            // if (shoesList != null && shoesList.isNotEmpty) {
            //   for (var item in shoesList.toList()) {
            //     print(item.nameShoes);
            //   }
            // }

            //print("final  : ${snapshot.data}");
            if (shoesList == null || shoesList.isEmpty) {
              return Center(
                child: Text("Data Kosong"),
              );
            } else {
              return dataSepatu(shoesList);
            }
          } else {
            return Center(
              child: Text("Connection State: ${snapshot.connectionState}"),
            );
          }
        });
  }

  Widget dataSepatu(List<ShoesModel> shoesList) {
    final int crossAxissCount = 2;

    final int row = (shoesList.length / crossAxissCount).ceil();

    final double averageHeight =
        MediaQuery.of(context).size.width / crossAxissCount;

    final double totalHeight = row * averageHeight;

    return Container(
      width: double.infinity,
      height: totalHeight,
      child:
          // child: GridView.count(
          //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   physics: NeverScrollableScrollPhysics(),
          //   crossAxisSpacing: 8,
          //   mainAxisSpacing: 20,
          //   crossAxisCount: 2,
          //   shrinkWrap: true,
          //   children: List.generate(
          //       shoesList.length, // Mengubah 'shoes' menjadi 'shoesList'
          //       (index) => ShoesCard(
          //             shoes: shoesList[
          //                 index], // Menggunakan 'shoesList' sebagai data sepatu
          //             // action: () {
          //             //   Navigator.pushNamed(
          //             //     context,
          //             //     DetailShoes.routeName,
          //             //     arguments: ShoesDetailsArguments(shoes: shoesList[index])
          //             //   );
          //             // }a\
          //             action: () {},
          //           )),
          // ),

          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: shoesList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxissCount),
              itemBuilder: (context, index) {
                var isLiked = wishList.any(
                    (item) => item.idDetail == shoesList[index].idDetailSepatu);

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ShoesCard(
                      shoes: shoesList[index],
                      isLiked: isLiked,
                      idUser: idUser!,
                      refreshPage: refreshLiked,
                      action: () {
                        Navigator.pushNamed(context, DetailShoes.routeName,
                            arguments: ShoesDetailsArguments(
                                idshoes: shoesList[index].idSepatuVersion,
                                idDetail_sepatu:
                                    shoesList[index].idDetailSepatu));
                      }),
                );
              }),
    );
  }
}
