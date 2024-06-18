import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:strideflex_application_1/core.dart';

class MyAlertDialog {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Error",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
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
                    message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColor.primaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  static void showVerifiedDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Berhasil",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
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
                        "assets/lottie/Animation - 1715474246529.json"),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColor.primaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
}
