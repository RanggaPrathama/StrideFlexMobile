import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';

class PaymentList extends StatelessWidget {
  const PaymentList({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColor.secondaryColor, width: 2),
        ),
        child: Row(
          children: [
            Radio(
              value: 1,
              groupValue: "TES",
              onChanged: (value) {},
              activeColor: MyColor.secondaryColor,
            ),
            Expanded(
                child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
            Icon(
              Icons.wallet,
              color: MyColor.secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
