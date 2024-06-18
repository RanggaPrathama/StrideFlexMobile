import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/screen/accountSetting/My%20Addresses/address.dart';
import 'package:strideflex_application_1/screen/accountSetting/editProfile/editProfile.dart';
import 'package:strideflex_application_1/screen/accountSetting/myOrder/myOrder.dart';
import 'package:strideflex_application_1/screen/login/login.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _token;
  Map<String, dynamic> userList = {};
  int? idUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacementNamed(context, Login.routeName);
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    if (mounted) {
      setState(() {
        _token = token ?? '';
      });
    }

    if (token.isNotEmpty) {
      decodeToken(token);
    } else {
      Navigator.pushReplacementNamed(context, Login.routeName);
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    String username = payload["nama_user"];
    int id_user = payload["id_user"];

    if (mounted) {
      setState(() {
        idUser = id_user;
        getUserAPI(idUser!);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.blue.shade600,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.5,
                              ),
                            ),
                            child: userList["gambar_profile"] != null &&
                                    userList["gambar_profile"] != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                        "${Config.baseURL}/images/profile/${userList["gambar_profile"]}",
                                        fit: BoxFit.cover))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset("assets/image/user.png",
                                        fit: BoxFit.cover)),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: userList["nama_user"] != null
                                  ? Text(
                                      "${userList["nama_user"]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "loading",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                            Container(
                              width: 200,
                              child: userList["email"] != null
                                  ? Text(
                                      "${userList["email"]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Text(
                                      "loading",
                                      style: TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400),
                                    ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Text(
                              "Account Settings",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          MenuProfile(
                            icon: "assets/icon/user-pen.svg",
                            text: "My Account",
                            press: () {
                              Navigator.pushNamed(
                                  context, editProfile.routeName);
                            },
                          ),
                          MenuProfile(
                            icon: "assets/icon/home.svg",
                            text: "My Addresses",
                            press: () {
                              Navigator.pushNamed(context, MyAddress.routeName);
                            },
                          ),
                          MenuProfile(
                            text: "My Orders",
                            icon: "assets/icon/dolly-flatbed.svg",
                            press: () {
                              Navigator.pushNamed(context, MyOrders.routeName);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CustomButton(
                                width: double.infinity,
                                height: 60,
                                text: "LogOut",
                                press: logout),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class MenuProfile extends StatelessWidget {
  const MenuProfile(
      {Key? key, required this.text, required this.icon, required this.press})
      : super(key: key);

  final String icon, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: GestureDetector(
        onTap: press,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xFFF5F6F9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                icon,
                color: Colors.blue,
                width: 30,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
