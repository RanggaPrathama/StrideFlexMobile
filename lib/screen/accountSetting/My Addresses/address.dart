import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({Key? key}) : super(key: key);
  static String routeName = "/myaddress";

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My address",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Alamat Utama",
                style: judul,
              ),
            ),
            AddressCard(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Alamat Lainnnya",
                style: judul,
              ),
            ),
            AddressCard()
          ],
        ),
      )),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20),
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
                  width: 0, height: 0, text: "Add New Address", press: () {}),
            ),
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 100,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
              )
            ]),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   "Alamat penagihan & pengiriman",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                Text("Nama : Rangga Prathama"),
                Container(
                  width: 250,
                  child: Text(
                    "Alamat : Wonosari Kidul II No.9 Surabaya",
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                Text("Nomor HP : 087794413362")
              ],
            ),
            CustomButton(width: 120, height: 50, text: "Edit", press: () {})
          ],
        ),
      ),
    );
  }
}
