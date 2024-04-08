import 'package:flutter/material.dart';
import 'package:strideflex_application_1/model/cartModel.dart';

class CartCard extends StatelessWidget {
  const CartCard({Key? key, required this.cart}) : super(key: key);

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15)),
              child: Image.asset(cart.shoesproduct.image[0]),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${cart.shoesproduct.nameShoes}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text.rich(TextSpan(
              text: "${cart.shoesproduct.price}",
              style: TextStyle(color: Colors.blue.shade500, fontSize: 16),
              children: [
                TextSpan(
                    text: " x ${cart.quantity}",
                    style: TextStyle(color: Colors.grey.shade600)),
              ]))
        ])
      ],
    );
  }
}
