import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/brandModel.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/screen/cart/cart.dart';
import 'package:strideflex_application_1/screen/detailpage/detailShoes.dart';
import 'package:strideflex_application_1/widget/list_brand.dart';
import 'package:strideflex_application_1/screen/homepage/components/search.dart';
import 'package:strideflex_application_1/widget/shoes_card.dart';
import 'package:strideflex_application_1/screen/homepage/components/slider.dart';
import 'package:strideflex_application_1/screen/notification/notification.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static String routeName = "/homepage";
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int brandDipilih = 0;
  @override
  Widget build(BuildContext context) {
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
                child:
                    Image.asset("assets/image/fotoku.jpg", fit: BoxFit.cover)),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome !! 😍',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Rangga Prathama',
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SearchHome(),
              SizedBox(height: 10),
              SliderHome(),
              SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      ...List.generate(
                          brands.length,
                          (index) => Padding(
                                padding: EdgeInsets.only(right: 10, left: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      brandDipilih = index;
                                    });
                                  },
                                  child: ListBrand(
                                    brand: brands[index],
                                    dipilih: index == brandDipilih,
                                  ),
                                ),
                              ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
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
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1.5,
                child: GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: List.generate(
                      shoes.length,
                      (index) => ShoesCard(
                          shoes: shoes[index],
                          action: () {
                            Navigator.pushNamed(context, DetailShoes.routeName,
                                arguments:
                                    ShoesDetailsArguments(shoes: shoes[index]));
                          })),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
