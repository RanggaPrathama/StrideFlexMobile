import 'package:flutter/material.dart';

class VerifNotif extends StatelessWidget {
  const VerifNotif({Key? key, required this.image, required this.text})
      : super(key: key);

  final String image;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Image.asset(image),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue.shade500),
          ),
        ],
      ),
    );
  }
}
