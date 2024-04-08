import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/screen/detailpage/detailShoes.dart';
import 'package:strideflex_application_1/widget/shoes_card.dart';
import 'package:strideflex_application_1/widget/verifNotif.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late List<ShoesModel> favoritShoes;

  @override
  void initState() {
    super.initState();

    favoritShoes = shoes.where((shoe) => shoe.isLiked == true).toList();

    favoritShoes.forEach((shoe) {
      print(shoe.nameShoes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("WishList", style: headingText),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              favoritShoes.isEmpty
                  ? VerifNotif(
                      image: "assets/icon/favorite.png",
                      text: "There is no wish list yet",
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 6,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            favoritShoes.length,
                            (index) => ShoesCard(
                                shoes: favoritShoes[index],
                                action: () {
                                  Navigator.pushNamed(
                                      context, DetailShoes.routeName,
                                      arguments: ShoesDetailsArguments(
                                          shoes: favoritShoes[index]));
                                })),
                      ),
                    ),
            ],
          ),
        )));
  }
}
