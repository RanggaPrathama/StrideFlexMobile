import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/screen/cart/cart.dart';
import 'package:strideflex_application_1/screen/detailpage/components/product_content.dart';
import 'package:strideflex_application_1/screen/detailpage/components/product_image.dart';
import 'package:strideflex_application_1/screen/transaksi/pembayaran.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class DetailShoes extends StatefulWidget {
  const DetailShoes({Key? key}) : super(key: key);

  static String routeName = "/detail";

  @override
  State<DetailShoes> createState() => _DetailShoesState();
}

class _DetailShoesState extends State<DetailShoes> {
  @override
  Widget build(BuildContext context) {
    final ShoesDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ShoesDetailsArguments;
    final shoesDetail = agrs.shoes;
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
          child: ListView(
        children: [
          ProductImage(shoes: shoesDetail),
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
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: ProductContent(shoes: shoesDetail),
          )
        ],
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
                  width: 0,
                  height: 0,
                  text: "Add To Chart",
                  press: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

class ShoesDetailsArguments {
  final ShoesModel shoes;

  ShoesDetailsArguments({required this.shoes});
}
