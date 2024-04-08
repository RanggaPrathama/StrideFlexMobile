import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/widget/shoes_card.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  static String routeName = "/myOrders";

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Orders",
          style: headingText,
        ),
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
        bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: MyColor.primaryColor,
            labelColor: MyColor.primaryColor,
            unselectedLabelColor: MyColor.textAreaColor,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            tabs: <Widget>[
              Tab(
                text: "Semua Pesanan",
              ),
              Tab(
                text: "Diproses",
              ),
              Tab(
                text: "Terkirim",
              ),
              Tab(
                text: "Dibatalkan",
              )
            ]),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(controller: _tabController, children: [
                NoDataOrder(),
                NoDataOrder(),
                NoDataOrder(),
                NoDataOrder()
              ]),
            )
          ],
        ),
      )),
    );
  }
}

class NoDataOrder extends StatelessWidget {
  const NoDataOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: double.infinity,
      //height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Image.asset(
              "assets/icon/no-data.png",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Belum ada data ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue.shade500),
          ),
        ],
      ),
    );
  }
}
