import 'package:flutter/material.dart';
import 'package:strideflex_application_1/screen.dart';
import 'package:strideflex_application_1/widget/verifNotif.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  static String routeName = "/successScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyScreen.routeName);
      },
      child: VerifNotif(image: "assets/icon/verified.png", text: "Success !!"),
    )));
  }
}
