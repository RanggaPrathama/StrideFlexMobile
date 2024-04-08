import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/Theme.dart';
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
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              PaymentList(
                text: "Gopay",
              ),
              PaymentList(text: "Kartu Kredit / Debit"),
              PaymentList(
                text: "OVO",
              ),
              PaymentList(text: "Bayar Di Tempat")
            ],
          ),
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    width: 0,
                    height: 0,
                    text: "Continue",
                    press: () {
                      Navigator.pushNamed(context, CekPesananPage.routeName);
                    }),
              ),
            ),
          ),
        ));
  }
}
