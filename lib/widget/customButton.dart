import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.press})
      : super(key: key);

  final String text;
  final double width;
  final double height;
  //final Future<void> Function() press;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      height: height,
      child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
          onPressed: press,
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Login()));
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )),
    );
  }
}
