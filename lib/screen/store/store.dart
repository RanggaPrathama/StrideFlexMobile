import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/brandModel.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';
import 'package:strideflex_application_1/model/wishListModel.dart';
import 'package:strideflex_application_1/services/brandservice.dart';
import 'package:strideflex_application_1/services/wishlistService.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  int dipilih = 0;
  int pilihShoesGender = 0;
  int? idBrand;
  int? idUser;
  int? defaultBrand;
  String? _token;
  late TabController _tabcontroller;
  // late List<ShoesModel> shoesMen;
  // late List<ShoesModel> shoesWomen;
  // late List<ShoesModel> shoesChild;

  final WishListService wishlistService = WishListService();
  List<WishlistModel> wishList = [];

  List<ShoesModel> shoesBygender = [];
  BrandService serviceBrand = BrandService();
  ShoesService serviceShoes = ShoesService();

  @override
  void initState() {
    super.initState();
    // shoesMen = shoes.where((item) => item.kategoriUmur == "Men").toList();
    // shoesWomen = shoes.where((item) => item.kategoriUmur == "Women").toList();
    // shoesChild = shoes.where((item) => item.kategoriUmur == "Child").toList();
    // shoesWomen.forEach((element) {
    //   print(element.kategoriUmur);
    // });
    _tabcontroller = TabController(initialIndex: 0, length: 3, vsync: this);
    _tabcontroller.addListener(() {
      setState(() {
        pilihShoesGender = _tabcontroller.index;
      });
      if (idBrand != null) {
        getShoesByGender(idBrand!, _tabcontroller.index);
        printpilihangender(pilihShoesGender, idBrand!);
      }
    });
    if (defaultBrand != null) {
      getShoesByGender(defaultBrand!, 0);
    }

    _getToken();
    print(pilihShoesGender);
  }

  void printpilihangender(int pilih, int idbrand) {
    print("Gender : $pilih");
    print("idBrand : $idbrand");
  }

  Future<void> fetchWishList(int idUser) async {
    final wishListAPI = await wishlistService.getWishlist(idUser);
    setState(() {
      wishList = wishListAPI ?? [];
    });
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    setState(() {
      _token = token ?? '';
    });

    if (token.isNotEmpty) {
      decodeToken(token);
    } else {
      Navigator.pushReplacementNamed(context, Login.routeName);
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int id_user = payload["id_user"];

    setState(() {
      idUser = id_user;
    });

    fetchWishList(idUser!);
  }

  Future<void> refreshLiked() async {
    print("cie aku masuk");
    await fetchWishList(idUser!);
  }

  Future<void> getShoesByGender(int idBrand, int gender) async {
    print("aku disini");
    if (idBrand == null) return;
    final shoesGender = await serviceShoes.getShoesByGender(idBrand, gender);
    setState(() {
      shoesBygender = shoesGender ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Store',
          style: headingText,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              color: Colors.blue.shade800,
              icon: Icon(Icons.shopping_cart_outlined),
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      "Featured Brand",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              loadBrand(),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TabBar(
                  controller: _tabcontroller,
                  indicatorColor: Colors.blue.shade800,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.blue.shade800,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 4,
                  tabs: [
                    Tab(
                      text: "Women",
                    ),
                    Tab(text: "Men"),
                    Tab(text: "Kids"),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  controller: _tabcontroller,
                  children: [
                    loadShoes(shoesBygender),
                    loadShoes(shoesBygender),
                    loadShoes(shoesBygender)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loadShoes(List<ShoesModel> dataSepatu) {
    final int crossAxissCount = 2;

    final int row = (dataSepatu.length / crossAxissCount).ceil();

    final double averageHeight =
        MediaQuery.of(context).size.width / crossAxissCount;

    final double totalHeight = row * averageHeight;
    return Container(
        height: totalHeight,
        width: double.infinity,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: dataSepatu.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxissCount),
            itemBuilder: (context, index) {
              var isLiked = wishList.any(
                  (item) => item.idDetail == dataSepatu[index].idDetailSepatu);

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ShoesCard(
                    shoes: dataSepatu[index],
                    isLiked: isLiked,
                    idUser: idUser!,
                    refreshPage: refreshLiked,
                    action: () {
                      Navigator.pushNamed(context, DetailShoes.routeName,
                          arguments: ShoesDetailsArguments(
                              idshoes: dataSepatu[index].idSepatuVersion,
                              idDetail_sepatu:
                                  dataSepatu[index].idDetailSepatu));
                    }),
              );
            }));
  }

  Widget loadBrand() {
    return FutureBuilder<List<BrandModel>?>(
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
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              if (idBrand == null && brandList.isNotEmpty) {
                idBrand = brandList[0].idbrand;
                getShoesByGender(idBrand!, _tabcontroller.index);
              }
              // });
              return pageBrand(brandList);
            }
          } else {
            return Center(
              child: Text('No data Brand'),
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

  Widget pageBrand(List<BrandModel> brandList) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        childAspectRatio: 2.5,
        children: List.generate(brandList.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                dipilih = index;
                idBrand = brandList[index].idbrand!;
              });
              getShoesByGender(idBrand!, _tabcontroller.index);
            },
            child: ListBrandCustom(
              brandList: brandList[index],
              isTap: dipilih == index,
            ),
          );
        }),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _tabcontroller.dispose();
  //   super.dispose();
  // }
}
