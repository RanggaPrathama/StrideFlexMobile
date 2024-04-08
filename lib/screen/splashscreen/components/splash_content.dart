import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({Key? key, required this.text, required this.image})
      : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        SizedBox(height: 30),
        Text(
          "StrideFlex",
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        Container(
          width: 400,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Lottie.asset(
            image,
            // width: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
      ],
    );
  }
}
