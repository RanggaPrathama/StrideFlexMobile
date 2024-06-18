import 'package:flutter/material.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';

class SearchHome extends StatelessWidget {
  const SearchHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: MySearchDelegate());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          width: double.infinity,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey.shade700,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Nike Shoes Promo Up To 50 % 🙌",
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            )
          ]),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final ShoesService _service = ShoesService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: _service.getShoesByQuery(query),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final List<ShoesSearch> shoesList = snapshot.data;
                  if (shoesList == null || shoesList.isEmpty) {
                    return Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/icon/no-data.png"),
                              Text(
                                "No data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.secondaryColor,
                                    fontSize: 25),
                              )
                            ],
                          )),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: shoesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, DetailShoes.routeName,
                                  arguments: ShoesDetailsArguments(
                                      idshoes: shoesList[index].idSepatuVersion,
                                      idDetail_sepatu:
                                          shoesList[index].idDetailSepatu));
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                              ),
                              title: Text(
                                "${shoesList[index].nameShoes} - ${shoesList[index].warna}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        });
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
