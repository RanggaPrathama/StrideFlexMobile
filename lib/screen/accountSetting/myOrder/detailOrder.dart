import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/itemOrderModel.dart';
import 'package:strideflex_application_1/services/detailOrderservice.dart';

class DetailOrder extends StatefulWidget {
  const DetailOrder({super.key});
  static String routeName = "/detailOrder";

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  Map<String, dynamic> listPembayaran = {};
  late Map<String, dynamic> PaymentDipilih = {};
  late int statusPembayaran = 1;
  final DetailOrderService OrderService = DetailOrderService();
  int? idBayar;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailOrderArguments args =
          ModalRoute.of(context)!.settings.arguments as detailOrderArguments;
      int idPembayaran = args.idPembayaran as int;
      print("Type Pembayaran : ${idPembayaran.runtimeType}");
      print("Pembayaran : ${idPembayaran}");
      getPembayaran(idPembayaran);
      setState(() {
        idBayar = idPembayaran;
      });
    });
  }

  Future<void> getPembayaran(int idPembayaran) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    var url = Uri.parse("${Config.baseURL}/pembayaran/${idPembayaran}");
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        listPembayaran = data["data"];
        statusPembayaran = data["data"]["status"];
      });
      getPaymentId(listPembayaran["payment_id_payment"]);
    }
  }

  Future<void> getPaymentId(int idPayment) async {
    try {
      print("akudipayment");
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      var url = Uri.parse("${Config.baseURL}/payment/${idPayment}");
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          PaymentDipilih = data["data"];
          isLoading = false;
        });
        print(PaymentDipilih);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detail Order",
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
      ),
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text.rich(TextSpan(
                          text: "Nomor Order : ",
                          style: TextStyle(fontSize: 18),
                          children: [
                            TextSpan(
                                text:
                                    "STD-${listPembayaran["id_pembayaran"] ?? "N/A"}",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ])),
                    ),
                    if (statusPembayaran == 1) notificationPaid(),
                    if (statusPembayaran == 2) notificationPending(),
                    if (statusPembayaran == 3) notificationExpired(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            "Tanggal : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Text(
                            "${DateTime.parse(listPembayaran["updated_at"]).toLocal()}",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            "Total : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            "Rp.${listPembayaran["total_pembayaran"]}",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            "Bank : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            "${PaymentDipilih["nama_bank"]}",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "Alamat : ",
                    //         style:
                    //             TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    //       ),
                    //       SizedBox(
                    //         width: 30,
                    //       ),
                    //       Text(
                    //         "Jalan WOnorejo, 60242",
                    //         style: TextStyle(fontSize: 18),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      child: Text(
                        "Perincian Item",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    loadOrder(idBayar!),
                  ],
                ),
              ),
      ),
    );
  }

  Widget notificationExpired() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: 26,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Pesanan Dibatalkan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Maaf, pesanan Anda telah Dibatalkan karena masalah pembayaran",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget notificationPaid() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: 26,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Pesanan Sudah Terbayar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Terima kasih, Pesanan anda sudah terbayar !  ",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget notificationPending() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: 26,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Pesanan Menunggu Verifikasi",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Maaf, pesananan anda menunggu untuk diverifikasi dulu",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget loadOrder(int idPembayaran) {
    return FutureBuilder(
        future: OrderService.getItemOrder(idPembayaran),
        builder:
            (BuildContext context, AsyncSnapshot<List<ItemOrder>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            final orderList = snapshot.data;
            // for (var item in orderList!.toList()) {
            //   print("AKU TES PESAN :${item.nama_sepatu}");
            // }
            if (orderList == null || orderList.isEmpty) {
              return Center(
                child: Text("Data Kosong"),
              );
            } else {
              return dataItemOrder(orderList);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget dataItemOrder(List<ItemOrder> listItem) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: listItem.length,
          itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 1))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 5,
                      child: CachedNetworkImage(
                        imageUrl: listItem[index].imageUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${listItem[index].nama_sepatu}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("${listItem[index].warna}"),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ukuran : ${listItem[index].nomor_ukuran}",
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Jumlah : ${listItem[index].quantity}")
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${listItem[index].subtotal}",
                          style: TextStyle(
                              color: MyColor.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}

class detailOrderArguments {
  final int idPembayaran;
  detailOrderArguments({required this.idPembayaran});
}
