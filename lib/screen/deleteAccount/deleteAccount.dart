import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  static String routeName = "/deleteAccount";
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  int? id_user;
  TextEditingController _emailcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args =
          ModalRoute.of(context)!.settings.arguments as DeleteAccountArguments;
      final idUser = args.idUser as int;
      setState(() {
        id_user = idUser;
      });
      print("ID USER : $idUser");
    });
  }

  Future<void> deleteAccount(int idUser) async {
    Map<String, String> header = {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json; charset=UTF-8",
    };

    var url = Uri.parse("${Config.baseURL}/deleteAccount");
    var response = await http.delete(url,
        headers: header,
        body: json.encode(<String, dynamic>{
          "idUser": idUser,
          "email": _emailcontroller.text
        }));
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if (data["message"] == "Account deleted") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.pushReplacementNamed(context, Login.routeName);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("${data["message"]}")));
    }
  }

  void cekDeleteAccount() {
    if (_formKey.currentState!.validate() && _formKey.currentState != null) {
      _formKey.currentState!.save();
      showDeleteVerification(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Delete Account",
          style: headingAuth,
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
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset("assets/logo/logoNoBG.png")),
                  ],
                ),
              ),
              Text(
                "Delete Account",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                "Apakah anda Yakin untuk Menghapus Account Anda ? ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
              Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: TextFormField(
                            controller: _emailcontroller,
                            style: Theme.of(context).textTheme.bodySmall,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 22, horizontal: 25),
                              labelText: "Email",
                              hintText: "Input Your Email ..",
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.email_outlined),
                              ),

                              //floatingLabelBehavior: FloatingLabelBehavior.always,
                              enabledBorder: OutlineInputBorder(
                                  //gapPadding: 10,
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade500, width: 2)),

                              focusedBorder: OutlineInputBorder(
                                //gapPadding: 10,
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            validator: (value) {
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (value!.isEmpty) {
                                return 'Please Enter Your Email';
                              } else if (!emailRegex.hasMatch(value)) {
                                return 'Please Enter Valid Email';
                              } else if (!value.contains('@')) {
                                return 'Email must contain @ symbol';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700),
                                  onPressed: cekDeleteAccount,
                                  child: Text(
                                    "Delete Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ))),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteVerification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Delete Account",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ],
        ),
        content: Container(
          width: 250,
          height: 250,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                child: Lottie.asset(
                    "assets/lottie/Animation - 1715474213830.json"),
              ),
              Text(
                "Apakah Anda Yakin ? ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Batal',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: MyColor.primaryColor),
            onPressed: () {
              Navigator.of(context).pop();
              deleteAccount(id_user!);
            },
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteAccountArguments {
  final int idUser;
  DeleteAccountArguments({required this.idUser});
}
