import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/screen/accountSetting/myOrder/detailOrder.dart';
import 'package:strideflex_application_1/screen/transaksi/buktiBayar.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  static String routeName = "/myOrders";

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
  late TabController _tabController;
  late int statusPembayaran = 0;
  List<Map<String, dynamic>> pendingOrders = [];
  List<Map<String, dynamic>> paidOrders = [];
  List<Map<String, dynamic>> verificationOrders = [];
  List<Map<String, dynamic>> expiredOrders = [];
  late String _token;
  int? id_user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _getToken();
    _tabController.addListener(() {
      setState(() {
        statusPembayaran = _tabController.index;
      });
      if (id_user != null) {
        getOrder(id_user!, statusPembayaran);
      }
    });
    if (id_user != null) {
      getOrder(id_user!, 0);
    }
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    print(token);
    if (mounted) {
      setState(() {
        _token = token ?? '';
      });
    }

    if (token.isNotEmpty) {
      decodeToken(token);
    }
  }

  void decodeToken(String token) async {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int idUser = payload["id_user"];
    if (mounted) {
      setState(() {
        id_user = idUser;
      });
    }
    getOrder(idUser, statusPembayaran);
  }

  Future<void> getOrder(int idUser, int status) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    var url = Uri.parse(
        "${Config.baseURL}/order/status?idUser=${idUser}&status=${status}");
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Status : $status");
      setState(() {
        switch (status) {
          case 0:
            pendingOrders = List<Map<String, dynamic>>.from(data["data"]);
            break;
          case 1:
            paidOrders = List<Map<String, dynamic>>.from(data["data"]);
            break;
          case 2:
            verificationOrders = List<Map<String, dynamic>>.from(data["data"]);
            break;
          case 3:
            expiredOrders = List<Map<String, dynamic>>.from(data["data"]);
            break;
        }
      });
    }
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
                text: "Pending Payment",
              ),
              Tab(
                text: "Paid",
              ),
              Tab(
                text: "Payment Verification",
              ),
              Tab(
                text: "Expired",
              )
            ]),
      ),
      body: SafeArea(
          child: TabBarView(controller: _tabController, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: pendingOrders.isEmpty
                      ? NoDataOrder()
                      : ListView.builder(
                          itemCount: pendingOrders.length,
                          itemBuilder: (context, index) => buildCardPending(
                              context, pendingOrders[index]["id_pembayaran"])))
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: paidOrders.isEmpty
                      ? NoDataOrder()
                      : ListView.builder(
                          itemCount: paidOrders.length,
                          itemBuilder: (context, index) => buildCardPaid(
                              context, paidOrders[index]["id_pembayaran"])))
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: verificationOrders.isEmpty
                    ? NoDataOrder()
                    : ListView.builder(
                        itemCount: verificationOrders.length,
                        itemBuilder: (context, index) => buildCardVerification(
                            context,
                            verificationOrders[index]["id_pembayaran"])),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: expiredOrders.isEmpty
                    ? NoDataOrder()
                    : ListView.builder(
                        itemCount: expiredOrders.length,
                        itemBuilder: (context, index) => buildCardExpired(
                            context, expiredOrders[index]["id_pembayaran"])),
              ),
            ],
          ),
        ),
      ])),
    );
  }

  Widget buildCardPending(BuildContext context, int idPembayaran) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment_sharp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waiting for payment',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text.rich(TextSpan(text: "Nomor Order : ", children: [
                    TextSpan(
                      text: "STD-$idPembayaran",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ]))
                ],
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, BuktibayarScreen.routeName,
                        arguments:
                            buktiBayarArguments(idPembayaran: idPembayaran));
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
          // Additional content here
          SizedBox(height: 10),
          Text('Please make the payment before the deadline ends'),
        ],
      ),
    );
  }

  Widget buildCardPaid(BuildContext context, int idPembayaran) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment_sharp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paid',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text.rich(TextSpan(text: "Nomor Order : ", children: [
                    TextSpan(
                      text: "STD-$idPembayaran",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ]))
                ],
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, DetailOrder.routeName,
                        arguments:
                            detailOrderArguments(idPembayaran: idPembayaran));
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
          // Additional content here
          SizedBox(height: 10),
          Text('Your payment has been received'),
        ],
      ),
    );
  }

  Widget buildCardVerification(BuildContext context, int idPembayaran) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment_sharp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waiting for verification',
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text.rich(TextSpan(text: "Nomor Order : ", children: [
                    TextSpan(
                      text: "STD-$idPembayaran",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ]))
                ],
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, DetailOrder.routeName,
                        arguments:
                            detailOrderArguments(idPembayaran: idPembayaran));
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
          // Additional content here
          SizedBox(height: 10),
          Text('Your payment is being verified'),
        ],
      ),
    );
  }

  Widget buildCardExpired(BuildContext context, int idPembayaran) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment_sharp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expired',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text.rich(TextSpan(text: "Nomor Order : ", children: [
                    TextSpan(
                      text: "STD-$idPembayaran",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ]))
                ],
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, DetailOrder.routeName,
                        arguments:
                            detailOrderArguments(idPembayaran: idPembayaran));
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
          // Additional content here
          SizedBox(height: 10),
          Text('This order has expired'),
        ],
      ),
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
