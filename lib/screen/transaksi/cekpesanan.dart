import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/pemesananModel.dart';
import 'package:strideflex_application_1/screen/transaksi/buktiBayar.dart';
import 'package:strideflex_application_1/services/pemesananservice.dart';

class CekPesananPage extends StatefulWidget {
  const CekPesananPage({Key? key}) : super(key: key);

  static String routeName = "/cekPesanan";

  @override
  State<CekPesananPage> createState() => _CekPesananPageState();
}

class _CekPesananPageState extends State<CekPesananPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOngkir();
    _getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PembayaranArguments args =
          ModalRoute.of(context)!.settings.arguments as PembayaranArguments;
      int idPayment = args.idPayment as int;
      int idPemesanan = args.idPemesanan as int;
      print(idPayment);
      print(idPemesanan);
      setState(() {
        idPesan = idPemesanan;
        idMetodeBayar = idPayment;
      });
      await getPaymentId(idPayment);
      await getPesan(idUser!, idPesan!);
    });
  }

  int selectedOngkir = 0;
  int? idUser; //value validasi pembayaran
  String? nama;
  String? alamat = "";
  int? notelepon = 0;
  late String _token;
  int harga_ongkir = 0;
  int totalBayar = 0; // valuevalidasi pembayaran
  int subtotal = 0;
  late int? id_Ongkir = 0; // value validasi pembayaran
  int? idPesan; //value validasi pembayaran
  int? idMetodeBayar; //value validasi pembayaran
  Map<String, dynamic> userList = {};
  List<Map<String, dynamic>?> listOngkir = [];
  // List<PemesananModel> listPemesanan = [];
  late Map<String, dynamic> listAddressActive = {};
  late Map<String, dynamic> PaymentDipilih = {};
  final pemesananService pesanservice = pemesananService();

  Future<void> storePembayaran(
      int idPemesanan, int idOngkir, int idMetodeBayar, int totalBayar) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      print("aku post masuk");
      print(idPemesanan);
      print(idOngkir);
      print(idMetodeBayar);
      print(totalBayar);

      var url = Uri.parse("${Config.baseURL}/pembayaran/store");
      var response = await http.post(
          headers: header,
          url,
          body: jsonEncode(<String, dynamic>{
            "idPemesanan": idPemesanan,
            "idOngkir": idOngkir,
            "idPayment": idMetodeBayar,
            "totalBayar": totalBayar,
          }));

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data["message"] == "Pembayaran successfully") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("Silahkan Upload Bukti Bayar")));
          Navigator.pushNamed(context, BuktibayarScreen.routeName,
              arguments: buktiBayarArguments(
                  idPembayaran: data["data"]["id_pembayaran"]));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text("Pemesanan Gagal !")));
        }
      }
    } catch (e) {
      print("error: $e");
    }
  }

  void cekPembayaran() {
    if (idUser != null &&
        totalBayar != null &&
        id_Ongkir != 0 &&
        idPesan != null) {
      storePembayaran(idPesan!, id_Ongkir!, idMetodeBayar!, totalBayar);
      print("idOngkir success: ${id_Ongkir}");
    } else {
      print("gak betul");
      print("idOngkir success: ${id_Ongkir}");
      print("idPesan success: ${idPesan}");
      print("idMetodeBayar success: ${idMetodeBayar}");
      print("totalBayar success: ${totalBayar}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Silahkan Memilih Ongkir !! ')));
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
    int id_user = payload["id_user"];
    String name = payload["nama_user"];
    // int noHP = payload["phoneNumber"];
    if (mounted) {
      setState(() {
        idUser = id_user;
        nama = name;
        //notelepon = noHP;
        //notelepon = noHP != null ? noHP : 0;
      });
    }
    getUserAPI(id_user);
    getAddressActive(id_user);
    //getPemesanan(idPemesanan, id_user);
  }

  Future<void> getUserAPI(int idUser) async {
    var url = Uri.parse("${Config.baseURL}/profile/$idUser");
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var data = json["data"];
      setState(() {
        userList = data;
      });
      print(userList);
    }
  }

  Future<void> getPesan(int idUser, int idPemesanan) async {
    //print("akudipesan");
    List<PemesananModel>? listPemesanan =
        await pesanservice.getPemesanan(idUser, idPemesanan);

    //print(listPemesanan);

    int totalBayar = calculateSubTotal(listPemesanan, harga_ongkir);
    //print(totalBayar);
    updateTotalBayar(totalBayar, harga_ongkir);
  }

  int calculateSubTotal(List<PemesananModel>? listPemesanan, int hargaOngkir) {
    int total = 0;
    if (listPemesanan != null) {
      for (PemesananModel item in listPemesanan) {
        total += (item.subtotal ?? 0);
      }
    } else {
      return total;
    }
    int totalBayar = total;
    return totalBayar;
  }

  void updateTotalBayar(int total, int hargaOngkir) {
    setState(() {
      totalBayar = total + (hargaOngkir ?? 0);
      subtotal = total;
    });
    print("subtotal: ${subtotal}");
    print("TOTAL BAYAR: ${totalBayar}");
  }

  Future<void> getAddressActive(int idUser) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      var url = Uri.parse("${Config.baseURL}/user/address/active/$idUser");
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          listAddressActive = data["data"];
        });
        print(listAddressActive);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getOngkir() async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    var url = Uri.parse("${Config.baseURL}/ongkir");
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var item = data["ongkir"];
      setState(() {
        listOngkir = List<Map<String, dynamic>>.from(item);
      });
      //printList(listOngkir);
    }
  }

  Future<void> refreshPage() async {
    await _getToken();
    await getOngkir();
    await getPesan(idUser!, idPesan!);

    // if (mounted) {
    //   setState(() {});
    // }
  }

  Future<void> getOngkirById(int idOngkir) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    var url = Uri.parse("${Config.baseURL}/ongkir/${idOngkir}");
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var item = data["ongkir"];
      setState(() {
        harga_ongkir = data["ongkir"]["harga_ongkir"];
        id_Ongkir = data["ongkir"]["id_ongkir"];
      });
      print("id Ongkir : ${id_Ongkir}");
      print("harga ongkir : ${harga_ongkir}");
      //printList(listOngkir);
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
        });
        print(PaymentDipilih);
      }
    } catch (e) {
      print(e);
    }
  }

  //debugListOngkir
  void printList(List<Map<String, dynamic>?> listOngkir) {
    for (var item in listOngkir) {
      print(item!["nama_ongkir"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // PembayaranArguments args =
    //     ModalRoute.of(context)!.settings.arguments as PembayaranArguments;
    // int idPayment = args.idPayment as int;
    // int idPemesanan = args.idPemesanan as int;
    // print("idPayment = ${idPayment}");
    // print("idPemesanan = ${idPemesanan}");

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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Opsi Pengiriman",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: listOngkir.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: MyColor.textAreaColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Radio(
                              value: listOngkir[index]!["id_ongkir"],
                              groupValue: selectedOngkir,
                              onChanged: (value) {
                                setState(() {
                                  selectedOngkir = value;
                                });
                                getOngkirById(selectedOngkir);
                                refreshPage();
                              },
                              activeColor: MyColor.secondaryColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Pengiriman Reguler",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "${listOngkir[index]!["nama_ongkir"]}",
                                  style:
                                      TextStyle(color: MyColor.textAreaColor),
                                )
                              ],
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2),
                            Text("Rp.${listOngkir[index]!["harga_ongkir"]}",
                                style: TextStyle(color: MyColor.primaryColor))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, MyAddress.routeName);
                              },
                              child: Text(
                                "Ubah",
                                style: TextStyle(
                                    color: MyColor.secondaryColor,
                                    fontSize: 16),
                              ))
                        ],
                      ),
                      Text("${nama}"),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 300,
                        child: Text("${listAddressActive["alamat"]}"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Nomor Telepon: ${userList["phoneNumber"]}")
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Hasil Pesanan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            loadPesan(idUser!, idPesan!),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Metode Pembayaran",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Pembayaran.routeName,
                                      arguments: PemesananArguments(
                                          idPemesanan: idPesan));
                                },
                                child: Text(
                                  "Ubah",
                                  style: TextStyle(
                                    color: MyColor.secondaryColor,
                                    fontSize: 16,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${PaymentDipilih["nama_bank"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${PaymentDipilih["atas_nama"]}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade600),
                                ),
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: PaymentDipilih["gambar_bank"] != null
                                    ? Image.network(
                                        "${Config.baseURL}/images/payment/${PaymentDipilih["gambar_bank"]}")
                                    : Text("null"))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Jumlah Pesanan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 1))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            "Rp.${subtotal}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pengiriman",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Dari Jasa Ongkir")
                            ],
                          ),
                          Text(
                            "Rp.${harga_ongkir}",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Text(
                            "Rp. ${totalBayar}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: cekPembayaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Pembayaran",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      )),
    );
  }

  Widget loadPesan(int idUser, int idPemesanan) {
    return FutureBuilder(
        future: pesanservice.getPemesanan(idUser!, idPemesanan!),
        builder: (BuildContext context,
            AsyncSnapshot<List<PemesananModel>?> snapshot) {
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
            final pemesananList = snapshot.data;
            for (var item in pemesananList!.toList()) {
              print("AKU TES PESAN :${item.nama_sepatu}");
            }
            if (pemesananList == null || pemesananList.isEmpty) {
              return Center(
                child: Text("Data Kosong"),
              );
            } else {
              return dataPemesanan(pemesananList);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget dataPemesanan(List<PemesananModel> listPemesanan) {
    return Container(
      width: double.infinity,
      //height: MediaQuery.of(context).size.height / 2,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: listPemesanan.length,
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
                        imageUrl: listPemesanan[index].imageUrl,
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
                          "${listPemesanan[index].nama_sepatu}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("${listPemesanan[index].warna}"),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ukuran : ${listPemesanan[index].nomor_ukuran}",
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Jumlah : ${listPemesanan[index].quantity}")
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${listPemesanan[index].subtotal}",
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

class PembayaranArguments {
  final int? idPayment;
  final int? idPemesanan;
  PembayaranArguments({this.idPayment, this.idPemesanan});
}
