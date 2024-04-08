import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/cartModel.dart';
import 'package:strideflex_application_1/screen/cart/components/cart_card.dart';
import 'package:strideflex_application_1/screen/transaksi/successScreen.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class CekPesananPage extends StatefulWidget {
  const CekPesananPage({Key? key}) : super(key: key);

  static String routeName = "/cekPesanan";

  @override
  State<CekPesananPage> createState() => _CekPesananPageState();
}

class _CekPesananPageState extends State<CekPesananPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cek Pesanan",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Opsi Pengiriman",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Lihat Semua",
                            style: TextStyle(color: MyColor.secondaryColor),
                          )),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: MyColor.secondaryColor,
                        size: 18,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MyColor.textAreaColor, width: 2),
                ),
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: "TES",
                      onChanged: (value) {},
                      activeColor: MyColor.secondaryColor,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(TextSpan(
                            text: "Pengiriman Reguler : ",
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                  text: "3-5 Apr",
                                  style: TextStyle(
                                    color: MyColor.secondaryColor,
                                  ))
                            ])),
                        Text(
                          "Oleh Jne",
                          style: TextStyle(color: MyColor.textAreaColor),
                        )
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Text("Rp.100.000",
                        style: TextStyle(color: MyColor.primaryColor))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Alamat Pengiriman",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Ubah",
                                style: TextStyle(
                                    color: MyColor.secondaryColor,
                                    fontSize: 16),
                              ))
                        ],
                      ),
                      Text("Rangga Prathama"),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 300,
                        child: Text("Jalan Wonorejo, Gorontalo, 60242"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Nomor Telepon: 087794413362")
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text(
                    "Hasil Pesanan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.9,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartList.length,
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dismissible(
                        key: Key(
                            cartList[index].shoesproduct.idShoes.toString()),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            cartList.removeAt(index);
                          });
                        },
                        child: CartCard(
                          cart: cartList[index],
                        ),
                      ))),
            )
          ],
        ),
      )),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.35,
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300, width: 2))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub Total : ",
                            style: textkecil,
                          ),
                          Text(
                            "Rp. 20.000.000",
                            style: textkecil,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Harga Pengiriman :",
                            style: textkecil,
                          ),
                          Text(
                            "Rp.100.000",
                            style: textkecil,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Harga :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "Rp.20.100.000",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColor.secondaryColor),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 70,
                      child: CustomButton(
                          width: 0,
                          height: 0,
                          text: "Confirm Order",
                          press: () {
                            Navigator.pushNamed(
                                context, SuccessScreen.routeName);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
