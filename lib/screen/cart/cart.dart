import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/model/cartModel.dart';
import 'package:strideflex_application_1/screen/cart/components/cart_card.dart';
import 'package:strideflex_application_1/screen/transaksi/pembayaran.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static String routeName = '/cart';

  @override
  State<CartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
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
              "4 Items",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: cartList.length,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Dismissible(
                    key: Key(cartList[index].shoesproduct.idShoes.toString()),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        cartList.removeAt(index);
                      });
                    },
                    child: CartCard(
                      cart: cartList[index],
                    ),
                  ),
                )),
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
                          text: "26700000",
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
                        onPressed: () {
                          Navigator.pushNamed(context, Pembayaran.routeName);
                        },
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
