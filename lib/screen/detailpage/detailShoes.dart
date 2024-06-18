import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/config.dart';
//import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/detailShoesModel.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';
import 'package:strideflex_application_1/model/ukuranModel.dart';
import 'package:strideflex_application_1/screen/cart/cart.dart';
import 'package:strideflex_application_1/screen/detailpage/components/product_content.dart';
import 'package:strideflex_application_1/screen/detailpage/components/product_image.dart';
//import 'package:strideflex_application_1/screen/transaksi/pembayaran.dart';
import 'package:strideflex_application_1/services/detailShoesService.dart';
import 'package:strideflex_application_1/services/ukuranService.dart';
import 'package:strideflex_application_1/widget/alertDialog.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class DetailShoes extends StatefulWidget {
  const DetailShoes({Key? key}) : super(key: key);

  static String routeName = "/detail";

  @override
  State<DetailShoes> createState() => _DetailShoesState();
}

class _DetailShoesState extends State<DetailShoes> {
  late DetailService _service;
  late UkuranService _ukuranService;
  late String _token;
  //int? idUkuran;
  int? id_stok;
  int? id_user;
  //int? id_detail;

  @override
  void initState() {
    super.initState();
    _service = DetailService();
    _ukuranService = UkuranService();
    getToken();
    //resfreshPPage();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final ShoesDetailsArguments arguments =
  //       ModalRoute.of(context)!.settings.arguments as ShoesDetailsArguments;
  //   id_detail = arguments.idDetail_sepatu;
  // }

  Future<void> createCart(int idStok, int idUser) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json",
      };
      var url = Uri.parse("${Config.baseURL}/createCart");
      print(url);

      print(idStok);
      print(idUser);
      var response = await http.post(url,
          headers: header,
          body: jsonEncode({
            'id_stok': idStok,
            'id_user': idUser,
          }));

      var data = jsonDecode(response.body);

      if (data["status"] == "Success Created" ||
          data["status"] == "Success Updated") {
        print(data["status"]);
        print(data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Berhasil Ditambahkan"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacementNamed(context, CartScreen.routeName);
      } else {
        print("error");
      }
    } catch (e) {
      print(e);
    }
  }

  cekValue() {
    if (id_stok == null) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Silahkan memilih ukuran"),
      //   duration: Duration(seconds: 3),
      //   backgroundColor: Colors.red,
      // ));
      MyAlertDialog.showErrorDialog(context, "Silahkan memilih ukuran");
    } else {
      print("hai aku jalan");
      createCart(id_stok!, id_user!);
    }
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token")!;
    setState(() {
      _token = token;
    });
    print("Mytoken: ${token}");
    decodeToken(token);
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int idUser = payload["id_user"];
    setState(() {
      id_user = idUser;
    });
  }

  // Future<void> resfreshPPage() async {
  //   Future.delayed(Duration(seconds: 1));
  //   await loadPage();
  //   await loadUkuran();
  //   setState(() {});
  // }

  // Widget loadPage() {

  //   return FutureBuilder(
  //       future: _service.getDetailShoes(idshoes),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasData) {
  //             var detailList = snapshot.data;
  //             if (detailList == null && detailList.isEmpty) {
  //               return CircularProgressIndicator();
  //             } else {
  //               return detailList;
  //             }
  //           } else {
  //             return CircularProgressIndicator();
  //           }
  //         } else {
  //           return CircularProgressIndicator();
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)!.settings.arguments;
    // idshoes = arguments as int;
    // print("idshoes : $idshoes");
    final ShoesDetailsArguments arguments =
        ModalRoute.of(context)!.settings.arguments as ShoesDetailsArguments;

    final idshoes = arguments.idshoes as int;
    final idDetailshoes = arguments.idDetail_sepatu as int;

    // setState(() {
    //   id_detail = idDetailshoes;
    // });

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
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
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1)
                ]),
            child: Row(children: <Widget>[
              Text(
                "5.0",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ]),
          )
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: _service.getDetailShoesByVersion(idshoes, idDetailshoes),
        builder:
            (BuildContext context, AsyncSnapshot<List<ShoesModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var detailList = snapshot.data;
              if (detailList == null && detailList!.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView(
                  children: [
                    ProductImage(shoes: detailList!),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductContent(shoes: detailList),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Variasi",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          loadPage(),
                          SizedBox(height: 20),
                          Text(
                            "Ukuran",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          loadUkuran(),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                  width: 0, height: 0, text: "Add To Chart", press: cekValue),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadPage() {
    final ShoesDetailsArguments arguments =
        ModalRoute.of(context)!.settings.arguments as ShoesDetailsArguments;

    final idshoes = arguments.idshoes as int;
    final idDetailshoes = arguments.idDetail_sepatu as int;

    // setState(() {
    //   id_detail = idDetailshoes;
    // });

    return FutureBuilder(
        future: _service.getDetailShoes(idshoes),
        builder: (BuildContext context,
            AsyncSnapshot<List<DetailShoesModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var detailList = snapshot.data;
              if (detailList == null && detailList!.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return dataDetail(detailList, idDetailshoes);
              }
            } else {
              return CircularProgressIndicator();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget dataDetail(List<DetailShoesModel> detailList, int iddetail) {
    int dipilih = 0;
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
        child: ListView.builder(
            itemCount: detailList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, DetailShoes.routeName,
                      arguments: ShoesDetailsArguments(
                          idshoes: detailList[index].id_sepatu,
                          idDetail_sepatu: detailList[index].iddetail_shoes));
                },
                child: CardDetail(
                  idDetail_sepatu: detailList[index].iddetail_shoes,
                  image: detailList[index].imageUrl,
                ),
              );
            }));
  }

  Widget loadUkuran() {
    final ShoesDetailsArguments arguments =
        ModalRoute.of(context)!.settings.arguments as ShoesDetailsArguments;

    final idshoes = arguments.idshoes as int;
    final idDetailshoes = arguments.idDetail_sepatu as int;
    return FutureBuilder(
        future: _ukuranService.getUkuranByIdDetail(idDetailshoes),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var ukuranList = snapshot.data;
              if (ukuranList == null && ukuranList!.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return dataUkuran(ukuranList);
              }
            } else {
              return CircularProgressIndicator();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget dataUkuran(List<UkuranModel> ukuranList) {
    return Container(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ukuranList.length,
        itemBuilder: (context, index) {
          bool isSelected = ukuranList[index].idstok == id_stok;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  id_stok = ukuranList[index].idstok;
                  //print(idUkuran);
                });
              },
              child: Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.blue.shade700, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ]),
                child: Center(
                    child: Text(
                  "${ukuranList[index].nomorUkuran}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black),
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardDetail extends StatefulWidget {
  CardDetail({
    Key? key,
    required this.idDetail_sepatu,
    required this.image,
  }) : super(key: key);

  final int? idDetail_sepatu;
  final String? image;

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  bool dipilih = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dipilih ? Colors.blue.shade600 : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: "${widget.image}",
          progressIndicatorBuilder: (context, url, progress) {
            return CircularProgressIndicator(
              value: progress.progress,
            );
          },
          errorWidget: (context, url, error) {
            return Icon(Icons.error);
          },
        ),
      ),
    );
  }
}

class ShoesDetailsArguments {
  final int? idshoes;
  final int? idDetail_sepatu;

  ShoesDetailsArguments({required this.idshoes, required this.idDetail_sepatu});
}
