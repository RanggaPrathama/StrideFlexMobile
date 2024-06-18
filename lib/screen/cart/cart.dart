import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/cartModel.dart';
import 'package:strideflex_application_1/services/cartService.dart';
import 'package:strideflex_application_1/widget/alertDialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static String routeName = '/cart';

  @override
  State<CartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<CartScreen> {
  int? id_user;
  int? id_cart;
  int total = 0;
  int quantity = 0;
  int cartCount = 0;
  late CartService _cartService;
  List<CartModel>? datacart = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    _cartService = CartService();
  }

  //UPDATETOTALFUNCTION
  void updateTotal(int newTotal) {
    setState(() {
      total = newTotal;
    });
  }

  //FUNNCTION DELETE CART
  Future<void> deleteCart(int idCart) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(
        "${Config.baseURL}/cart/delete?id_user=${id_user}&id_cart=${idCart}");

    var response = await http.put(url, headers: header);

    var data = jsonDecode(response.body);

    if (data["message"] == "Cart Berhasil DiHapus!") {
      refreshPage();
    }
  }

  //FUNCTION UPDATE QUANTITY
  Future<void> updateQuantity(int quantity, int id_cart) async {
    print("id_cart : ${id_cart}");
    print("quantity : ${quantity}");

    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var url = Uri.parse(
        "${Config.baseURL}/cart/update?id_cart=${id_cart}&id_user=${id_user}");

    var response = await http.put(url,
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "quantity": quantity,
        }));

    var data = jsonDecode(response.body);

    if (data["message"] == "Cart Berhasil DiUpdate!") {
      refreshPage();
    }
  }

  //REFRESH PAGE
  Future<void> refreshPage() async {
    await getToken();
  }

  //get token
  Future<void> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token') ?? '';
    decodeToken(token);
  }

  //decode the token
  void decodeToken(String token) async {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int idUser = payload["id_user"];
    setState(() {
      id_user = idUser;
    });

    // get cart bbackend
    List<CartModel>? cartList = await _cartService.getCart(id_user!);
    // Hitung total harga
    //print('length : ${cartList?.length}');
    setState(() {
      cartCount = cartList!.length;
      datacart = cartList;
    });
    int newTotal = calculateTotal(cartList);
    // print(newTotal);
    // printdataCart(datacart!);
    // Perbarui total harga
    updateTotal(newTotal);
  }

  //debug print data Caer
  void printdataCart(List<CartModel> cartList) {
    //print(cartList);
    for (var item in cartList) {
      print("harga sepatu : ${item.hargaSepatu}");
    }
  }

  //PERHITUNGAN TOTAL HARGA CART
  int calculateTotal(List<CartModel>? cartList) {
    int total = 0;
    if (cartList != null) {
      for (CartModel cart in cartList) {
        //print(cart.quantity);
        //print(cart.hargaSepatu);
        total += (cart.quantity ?? 0) * (cart.hargaSepatu ?? 0).toInt();
      }
    }
    // print(total);
    return total;
  }

  //FUNCTION STORE BACKEND
  Future<void> storeCart(
      int idUser, List<CartModel> dataPemesanan, int totalPesan) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var url = Uri.parse("${Config.baseURL}/pemesanan/store");
    var dataMapCart = dataPemesanan.map((cart) => cart.toJson()).toList();
    var response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "idUser": idUser,
          "dataPemesanan": dataMapCart,
          "totalPesan": totalPesan,
        }));
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      print(data);
      if (data["message"] == "Pemesanan Added") {
        int idPemesanan = data["data"]["id_pemesanan"];
        Navigator.pushNamed(context, Pembayaran.routeName,
            arguments: PemesananArguments(idPemesanan: idPemesanan));
      }
    } else {
      print(response.statusCode);
      var data = jsonDecode(response.body);
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          content: Text("Error Store BACKEND")));
    }
  }

  //VALIDATION CART
  void cekCart() {
    if (datacart!.length == 0) {
      MyAlertDialog.showErrorDialog(context, "no data Cart available");
    } else {
      if (id_user != null && datacart != null && total != null) {
        //print("hei ada semua");
        storeCart(id_user!, datacart!, total);
      } else {
        MyAlertDialog.showErrorDialog(
            context, "no data Cart available, User is not logged in");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (id_user == null) {
      // Tampilkan widget loading atau pesan lain
      return CircularProgressIndicator(); // Misalnya
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
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
          title: Column(
            children: [
              Text(
                "Your Cart",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Text(
                "${cartCount} Items",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
              future: _cartService.getCart(id_user!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CartModel>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    var cartList = snapshot.data;
                    if (cartList!.isEmpty && cartList == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: cartList.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Dismissible(
                                key: Key(cartList[index].idCart.toString()),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  deleteCart(cartList[index].idCart!).then((_) {
                                    refreshPage();
                                  });
                                },
                                child: CartCard(
                                  cart: cartList[index],
                                  updateTotal: updateTotal,
                                  quantityUpdate: (value, idCart) {
                                    setState(() {
                                      updateQuantity(value, idCart);
                                    });
                                  },
                                ),
                              ),
                            );
                          }));
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
              }),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          padding: EdgeInsets.symmetric(vertical: 20),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 1))
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text.rich(TextSpan(text: "Total : \n", children: [
                        TextSpan(
                            text: "${total}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ])),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 60,
                      child: ElevatedButton(
                          onPressed: cekCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            elevation: 0,
                            padding: EdgeInsets.all(10),
                          ),
                          child: Text(
                            "Check Out",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                    ),
                  )
                ],
              )
            ],
          )),
        ),
      );
    }
  }
}
