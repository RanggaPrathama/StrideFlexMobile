//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/screen.dart';
import 'package:strideflex_application_1/screen/accountSetting/My%20Addresses/address.dart';
import 'package:strideflex_application_1/screen/accountSetting/editProfile/editProfile.dart';
import 'package:strideflex_application_1/screen/accountSetting/myOrder/detailOrder.dart';
import 'package:strideflex_application_1/screen/accountSetting/myOrder/myOrder.dart';
import 'package:strideflex_application_1/screen/cart/cart.dart';
import 'package:strideflex_application_1/screen/deleteAccount/deleteAccount.dart';
import 'package:strideflex_application_1/screen/detailpage/detailShoes.dart';
import 'package:strideflex_application_1/screen/homepage/homepage.dart';
import 'package:strideflex_application_1/screen/homepage/searchpage.dart';
import 'package:strideflex_application_1/screen/katalog/katalogShoes.dart';
import 'package:strideflex_application_1/screen/login/login.dart';
import 'package:strideflex_application_1/screen/lupaPassword/lupapassword.dart';
import 'package:strideflex_application_1/screen/notification/notification.dart';
import 'package:strideflex_application_1/screen/register/register.dart';
import 'package:strideflex_application_1/screen/splashscreen/splash_screen.dart';
import 'package:strideflex_application_1/screen/transaksi/buktiBayar.dart';
import 'package:strideflex_application_1/screen/transaksi/cekpesanan.dart';
import 'package:strideflex_application_1/screen/transaksi/pembayaran.dart';
import 'package:strideflex_application_1/screen/transaksi/successScreen.dart';

final Map<String, WidgetBuilder> routers = {
  MyScreen.routeName: (context) => MyScreen(),
  Login.routeName: (context) => Login(),
  SplashScreen.routeName: (context) => SplashScreen(),
  Register.routeName: (context) => Register(),
  MyHomePage.routeName: (context) => MyHomePage(),
  DetailShoes.routeName: (context) => DetailShoes(),
  CartScreen.routeName: (context) => CartScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  Pembayaran.routeName: (context) => Pembayaran(),
  CekPesananPage.routeName: (context) => CekPesananPage(),
  SuccessScreen.routeName: (context) => SuccessScreen(),
  LupaPassword.routeName: (context) => LupaPassword(),
  editProfile.routeName: (context) => editProfile(),
  MyAddress.routeName: (context) => MyAddress(),
  MyOrders.routeName: (context) => MyOrders(),
  KatalogShoes.routeName: (context) => KatalogShoes(),
  SearchPage.routeName: (context) => SearchPage(),
  BuktibayarScreen.routeName: (context) => BuktibayarScreen(),
  DetailOrder.routeName: (context) => DetailOrder(),
  DeleteAccount.routeName: (context) => DeleteAccount(),
};
