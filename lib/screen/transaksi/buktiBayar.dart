import 'dart:async';
import "dart:convert";
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';

class BuktibayarScreen extends StatefulWidget {
  const BuktibayarScreen({Key? key}) : super(key: key);

  static String routeName = "/buktibayar";
  @override
  State<BuktibayarScreen> createState() => _BuktibayarScreenState();
}

class _BuktibayarScreenState extends State<BuktibayarScreen> {
  Map<String, dynamic> listPembayaran = {};
  late int? statusPembayaran = 0;
  int? idPayment;
  late Map<String, dynamic> PaymentDipilih = {};
  File? buktiBayar;
  String? nama;
  late String _token;
  int? idBayar;
  final ImagePicker picker = ImagePicker();
  //DATE
  late DateTime? createdAt;
  late DateTime waktuAkhirPembayaran;
  Timer? _timer;
  String remainingTime = "";

  @override
  void initState() {
    super.initState();
    _getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buktiBayarArguments args =
          ModalRoute.of(context)!.settings.arguments as buktiBayarArguments;
      int idPembayaran = args.idPembayaran as int;
      print("Pembayaran : ${idPembayaran}");
      getPembayaran(idPembayaran);
      setState(() {
        idBayar = idPembayaran;
      });
    });
    // DateTime now = DateTime.now();
    // waktuAkhirPembayaran = now.add(Duration(hours: 3));
    // initializeDateFormatting('id_ID', null).then((_) {
    DateTime now = DateTime.now().toLocal();
    waktuAkhirPembayaran =
        now.add(Duration(hours: 3)); // Set waktuAkhirPembayaran

    // });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now().toLocal();
        Duration difference = waktuAkhirPembayaran.difference(now);
        print("waktu sekarang : $now");
        print("Pembeda:  $difference");
        print("waktu akhir pembayaran : $waktuAkhirPembayaran");
        if (difference.isNegative) {
          remainingTime = "Waktu Habis";
          pembayaranExpired(idBayar!);
          _timer?.cancel();
        } else {
          remainingTime =
              "${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}";
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
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
    String name = payload["nama_user"];
    if (mounted) {
      setState(() {
        nama = name;
      });
    }
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
        createdAt = DateTime.parse(data["data"]["created_at"]).toLocal();
        waktuAkhirPembayaran = createdAt!.add(Duration(hours: 3));
      });
      print("Status $statusPembayaran");
      print("Tanggal Created : ${createdAt}");
      print("Tanggal Akhir : ${waktuAkhirPembayaran}");
      startTimer();
      getPaymentId(data["data"]["payment_id_payment"]);
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

  Future<void> uploadBuktiPembayaran() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        buktiBayar = File(pickedImage.path);
      });
    }
  }

  Future<void> pembayaranExpired(int idPembayaran) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    var url = Uri.parse("${Config.baseURL}/pembayaran/expired/$idPembayaran");
    var response = await http.put(url, headers: header);
    if (response.statusCode == 201) {
      refreshPage();
    }
  }

  void refreshPage() async {
    await getPembayaran(idBayar!);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> submitPembayaran(int idPembayaran) async {
    Map<String, String> header = {"Content-Type": "multipart/form-data"};
    var url = Uri.parse("${Config.baseURL}/pembayaran/paid/$idPembayaran");

    var request = http.MultipartRequest('PUT', url);
    if (buktiBayar != null) {
      final mimeType = lookupMimeType(buktiBayar!.path);
      request.files.add(await http.MultipartFile.fromPath(
          'file', buktiBayar!.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        Navigator.pushReplacementNamed(context, SuccessScreen.routeName);
      } else {
        var responseData = await response.stream.bytesToString();
        print('Error: ${response.statusCode}');
        print('Error response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error Submit Bukti Pembayaran")));
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void cekBuktiBayar() {
    if (buktiBayar == null && idBayar == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error Submit Bukti Pembayaran")));
    } else {
      print("aku betul");
      submitPembayaran(idBayar!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "Pembayaran StrideFLex",
                        style: TextStyle(
                            fontSize: 24,
                            color: MyColor.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Hi ${nama}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        "Silahkan Mengirimkan Bukti Bayar ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Waktu tersisa untuk pembayaran:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            )),
                      ),
                      Text(
                        "$remainingTime",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(TextSpan(
                                  text: "Perubahan batas akhir pembayaran : ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  children: [
                                    TextSpan(
                                        text: "3 Jam",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                  ])),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Container(
                          alignment: Alignment.center,
                          width: 500,
                          child: Text(
                            "Penting ! Lakukan Pembayaran sebelum $waktuAkhirPembayaran atau pesanan Anda otomatis dibatalkan oleh sistem",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: PaymentDipilih["gambar_bank"] != null
                              ? Image.network(
                                  "${Config.baseURL}/images/payment/${PaymentDipilih["gambar_bank"]}")
                              : Text("null")),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("No Order"),
                                  Text("STD-${listPembayaran["id_pembayaran"]}")
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Bank"),
                                  Text("${PaymentDipilih["nama_bank"]}")
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("No Rekening"),
                                  Text("${PaymentDipilih["no_rekening"]}")
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Atas Nama"),
                                  Text("${PaymentDipilih["atas_nama"]}")
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Total Bayar"),
                                  Text(
                                      "Rp.${listPembayaran["total_pembayaran"]}")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      statusPembayaran != 3
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: uploadBuktiPembayaran,
                                  child: Text("Upload Bukti Bayar"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                    padding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                            )
                          : Text(""),
                      buktiBayar != null
                          ? Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 5,
                              child: Image.file(
                                buktiBayar!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 20,
                      ),
                      statusPembayaran != 3
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: cekBuktiBayar,
                                  child: Text(
                                    "Kirim Bukti Bayar",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, MyScreen.routeName);
                          },
                          child: Text(
                            "Lanjut Berbelanja",
                            style: TextStyle(
                              color: MyColor.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class buktiBayarArguments {
  final int idPembayaran;
  buktiBayarArguments({required this.idPembayaran});
}
