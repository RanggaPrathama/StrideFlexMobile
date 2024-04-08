import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/brandModel.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/screen/cart/cart.dart';
import 'package:strideflex_application_1/screen/detailpage/detailShoes.dart';
import 'package:strideflex_application_1/widget/shoes_card.dart';
import 'package:strideflex_application_1/screen/store/components/listBrand.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  int dipilih = 0;
  late TabController _tabcontroller;
  late List<ShoesModel> shoesMen;
  late List<ShoesModel> shoesWomen;
  late List<ShoesModel> shoesChild;
  @override
  void initState() {
    super.initState();
    shoesMen = shoes.where((item) => item.kategoriUmur == "Men").toList();
    shoesWomen = shoes.where((item) => item.kategoriUmur == "Women").toList();
    shoesChild = shoes.where((item) => item.kategoriUmur == "Child").toList();
    shoesWomen.forEach((element) {
      print(element.kategoriUmur);
    });
    _tabcontroller = TabController(initialIndex: 0, length: 3, vsync: this);
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  childAspectRatio: 2.5,
                  children: List.generate(
                    brands.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          dipilih = index;
                        });
                      },
                      child: ListBrandCustom(
                        brandList: brands[index],
                        isTap: dipilih == index,
                      ),
                    ),
                  ),
                ),
              ),
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
                      text: "Men",
                    ),
                    Tab(text: "Women"),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        height: MediaQuery.of(context).size.height,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 6,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                              shoesMen.length,
                              (index) => ShoesCard(
                                  shoes: shoesMen[index],
                                  action: () {
                                    Navigator.pushNamed(
                                        context, DetailShoes.routeName,
                                        arguments: ShoesDetailsArguments(
                                            shoes: shoesMen[index]));
                                  })),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        height: MediaQuery.of(context).size.height,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 6,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                              shoesWomen.length,
                              (index) => ShoesCard(
                                  shoes: shoesWomen[index],
                                  action: () {
                                    Navigator.pushNamed(
                                        context, DetailShoes.routeName,
                                        arguments: ShoesDetailsArguments(
                                            shoes: shoesWomen[index]));
                                  })),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        height: MediaQuery.of(context).size.height,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 6,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                              shoesChild.length,
                              (index) => ShoesCard(
                                  shoes: shoesChild[index],
                                  action: () {
                                    Navigator.pushNamed(
                                        context, DetailShoes.routeName,
                                        arguments: ShoesDetailsArguments(
                                            shoes: shoesChild[index]));
                                  })),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabcontroller.dispose(); // Jangan lupa dispose _tabcontroller
    super.dispose();
  }
}
