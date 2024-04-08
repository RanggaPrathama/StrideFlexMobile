import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:strideflex_application_1/screen/accountSetting/My%20Addresses/address.dart';
import 'package:strideflex_application_1/screen/accountSetting/editProfile/editProfile.dart';
import 'package:strideflex_application_1/screen/accountSetting/myOrder/myOrder.dart';
import 'package:strideflex_application_1/screen/login/login.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/image/fotoku.jpg'),
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: Text(
                                "Rangga Prathama Nugraha.H",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "ranggaprathama9@gmail.com",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
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
                                press: () {
                                  Navigator.pushNamed(context, Login.routeName);
                                }),
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
