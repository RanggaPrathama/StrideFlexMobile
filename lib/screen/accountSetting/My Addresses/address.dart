import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/widget/alertDialog.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class MyAddress extends StatefulWidget {
  MyAddress({Key? key}) : super(key: key);
  static String routeName = "/myaddress";

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  int? idUser;
  late Map<String, dynamic> listAddressActive = {};
  late List<Map<String, dynamic>> listAddressNonActive = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString("token") ?? "";
    if (token.isNotEmpty) {
      decodeToken(token);
    }
  }

  Future<void> refreshPage() async {
    await getUser();
  }

  Future<void> deleteAddress(int idAddress) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      print("aku kedelete");
      var url = Uri.parse("${Config.baseURL}/user/address/delete/$idAddress");
      var response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        // refreshPage();
        var data = jsonDecode(response.body);
        print(data["message"]);
      }
    } catch (e) {
      print(e);
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int id_user = payload["id_user"];
    setState(() {
      idUser = id_user;
    });
    getAddressActive(id_user);
    getAddressNonActive(id_user);
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

  Future<void> getAddressNonActive(int idUser) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      var url = Uri.parse("${Config.baseURL}/user/address/nonactive/$idUser");
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          listAddressNonActive = List<Map<String, dynamic>>.from(data["data"]);
        });
        print(listAddressNonActive);
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
            listAddressActive != null && listAddressActive.isNotEmpty
                ? Dismissible(
                    key: Key(listAddressActive["id_alamat"].toString()),
                    background: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteAddress(listAddressActive["id_alamat"]);
                    },
                    child: AddressCard(
                      alamat: listAddressActive["alamat"],
                      idAlamat: listAddressActive["id_alamat"],
                      idUser: idUser,
                      isMainAddress: true,
                      refreshPage: refreshPage,
                    ))
                : SizedBox(
                    height: 100,
                  ),
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
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: listAddressNonActive.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        key: Key(listAddressNonActive[index]["id_alamat"]
                            .toString()),
                        background: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          deleteAddress(
                                  listAddressNonActive[index]["id_alamat"])
                              .then((_) {
                            refreshPage();
                          });
                        },
                        child: AddressCard(
                          alamat: listAddressNonActive[index]["alamat"],
                          idAlamat: listAddressNonActive[index]["id_alamat"],
                          idUser: idUser,
                          isMainAddress: false,
                          refreshPage: refreshPage,
                        ));
                  }),
            ),
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
                  width: 0,
                  height: 0,
                  text: "Add New Address",
                  press: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return DraggableScrollableSheet(
                          expand: true,
                          initialChildSize: 0.9,
                          minChildSize: 0.5,
                          maxChildSize: 0.9,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return CreateAddress(
                              idUser: idUser,
                              scrollController: scrollController,
                              refreshPage: refreshPage,
                            );
                          },
                        );
                      },
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  AddressCard(
      {super.key,
      this.press,
      this.alamat,
      this.idAlamat,
      this.idUser,
      this.isMainAddress = false,
      this.refreshPage});
  late int? idAlamat;
  late int? idUser;
  late String? alamat;
  bool isMainAddress;
  VoidCallback? press;
  VoidCallback? refreshPage;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isMainAddress;
  }

  Future<void> updateAddressActive(int idAlamat, int idUser) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      var url = Uri.parse(
          "${Config.baseURL}/user/address/update/${idUser}/${idAlamat}");
      var response = await http.put(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["message"] == "Address Berhasil terload") {
          return data;
        }
        print(data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> toggleAddressActive() async {
    if (isChecked) {
      await updateAddressActive(widget.idAlamat!, widget.idUser!);
    }
    if (widget.refreshPage != null) {
      widget.refreshPage!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.blue;
                    }
                    return Colors.transparent;
                  },
                ),
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                  if (isChecked) {
                    toggleAddressActive();
                  }
                }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 180,
                    child: Text(
                      "Nama : Rangga Prathama",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    )),
                Container(
                  width: 150,
                  child: Text(
                    "Alamat : ${widget.alamat}",
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                Container(
                    width: 180,
                    child: Text(
                      "Nomor HP : 087794413362",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ))
              ],
            ),
            CustomButton(
              width: 120,
              height: 50,
              text: "Edit",
              press: () {
                showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      expand: true,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return UpdateAddress(
                          idAddress: widget.idAlamat,
                          idUser: widget.idUser,
                          scrollController: scrollController,
                          refreshPage: widget.refreshPage,
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CreateAddress extends StatefulWidget {
  CreateAddress(
      {Key? key, this.refreshPage, this.idUser, this.scrollController})
      : super(key: key);

  VoidCallback? refreshPage;
  int? idUser;
  final ScrollController? scrollController;
  @override
  State<CreateAddress> createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  Future<void> createAddress(int idUser) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var url = Uri.parse("${Config.baseURL}/user/address/$idUser");

    try {
      var response = await http.post(url,
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "alamat": _addressController.text,
          }));

      var data = jsonDecode(response.body);
      print(response.body);
      if (data["message"] == "Address created successfully") {
        MyAlertDialog.showVerifiedDialog(
            context, "Address created successfully");
        widget.refreshPage!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text("Failed to create address")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text("Failed to create address: Network error")));
    }
  }

  void cekAddress() {
    if (_formKey.currentState!.validate() && _formKey.currentState != null) {
      _formKey.currentState!.save();
      createAddress(widget.idUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Container(
        child: Column(
          children: [
            Text(
              "Create Address",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColor.secondaryColor),
            ),
            Container(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: TextFormField(
                        controller: _addressController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 22, horizontal: 25),
                          labelText: "Address",
                          hintText: "Input Your Address..",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.home),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade500, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Address";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                        width: double.infinity,
                        height: 60,
                        text: "Create Address",
                        press: cekAddress)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UpdateAddress extends StatefulWidget {
  UpdateAddress(
      {Key? key,
      this.refreshPage,
      this.idAddress,
      this.idUser,
      this.scrollController})
      : super(key: key);

  VoidCallback? refreshPage;
  int? idUser;
  int? idAddress;
  final ScrollController? scrollController;
  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  String? Address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("idAddress : ${widget.idAddress}");
    getAddress(widget.idAddress!);
  }

  Future<void> getAddress(int idAddress) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse("${Config.baseURL}/user/address/$idAddress");
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        Address = data["data"]["alamat"];
      });
    }
  }

  Future<void> updateAddress(int idAlamat) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var url = Uri.parse("${Config.baseURL}/user/addressName/update/$idAlamat");

    try {
      var response = await http.put(url,
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "alamat": _addressController.text,
          }));

      var data = jsonDecode(response.body);
      print(response.body);
      if (data["message"] == "Alamat updated successfully") {
        MyAlertDialog.showVerifiedDialog(
            context, "Address updated successfully");
        widget.refreshPage!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text("Failed to create address")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text("Failed to create address: Network error")));
    }
  }

  void cekAddress() {
    if (_formKey.currentState!.validate() && _formKey.currentState != null) {
      _formKey.currentState!.save();
      updateAddress(widget.idAddress!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Container(
        child: Column(
          children: [
            Text(
              "Edit Address",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColor.secondaryColor),
            ),
            Container(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: TextFormField(
                        controller: _addressController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 22, horizontal: 25),
                          labelText: "${Address}",
                          hintText: "Input Your Address..",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.home),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade500, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Address";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                        width: double.infinity,
                        height: 60,
                        text: "Update Address",
                        press: cekAddress)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
