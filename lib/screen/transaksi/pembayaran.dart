import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/screen/transaksi/cekpesanan.dart';
import 'package:strideflex_application_1/screen/transaksi/components/paymentsLList.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({super.key});

  static String routeName = "/pembayaran";
  @override
  State<Pembayaran> createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  List<Map<String, dynamic>> paymentList = [];
  bool isLoading = true;
  int? selectedPaymentId = 0;
  int? idPemesanan = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args =
          ModalRoute.of(context)!.settings.arguments as PemesananArguments;
      int idPesan = args.idPemesanan as int;
      print("id Pesan : ${idPesan}");
      setState(() {
        idPemesanan = idPesan;
      });
    });
    fetchPayment();
  }

  Future<void> fetchPayment() async {
    print("aku dipanggil");
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var url = Uri.parse("${Config.baseURL}/payment");
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print(response.statusCode);
      print(responseBody);
      var data = responseBody["data"];
      setState(() {
        paymentList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      print(response.statusCode);
    }
  }

  void cekPayment() {
    if (selectedPaymentId != 0 && idPemesanan != 0) {
      print("Selec Payment : $selectedPaymentId");
      print("Id Pemesanan : $idPemesanan");
      Navigator.pushNamed(context, CekPesananPage.routeName,
          arguments: PembayaranArguments(
              idPemesanan: idPemesanan, idPayment: selectedPaymentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pembayaran",
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: paymentList.length,
                          itemBuilder: (context, index) {
                            return PaymentList(
                              text: paymentList[index]["nama_bank"],
                              value: paymentList[index]["id_payment"],
                              groupValue: selectedPaymentId!,
                              onChanged: (value) {
                                setState(() {
                                  selectedPaymentId = value;
                                  print(selectedPaymentId);
                                });
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
      ),
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                width: 0,
                height: 0,
                text: "Continue",
                press: cekPayment,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PemesananArguments {
  final int? idPemesanan;
  PemesananArguments({this.idPemesanan});
}
