import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/cartModel.dart';

class CartCard extends StatefulWidget {
  const CartCard(
      {Key? key,
      required this.cart,
      required this.updateTotal,
      required this.quantityUpdate})
      : super(key: key);

  final CartModel cart;
  final Function(int) updateTotal;
  final Function(int, int) quantityUpdate;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Color(0xFFE5E5E5), blurRadius: 2, offset: Offset(0, 2))
          ]),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 120,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: widget.cart.imageUrl,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "${widget.cart.namaBrand}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              width: 200,
              child: Text(
                "${widget.cart.sepatuVersion} - ${widget.cart.warna}",
                style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
              ),
            ),
            Text("Ukuran : ${widget.cart.nomorUkuran}"),
            DropdownButton(
                value: widget.cart.quantity,
                items: List.generate(10, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text("${index + 1}"),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    quantity = value!;
                    widget.updateTotal(
                        quantity * (widget.cart.hargaSepatu ?? 0).toInt());
                    widget.quantityUpdate(quantity, widget.cart.idCart!);
                  });
                }),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.cart.hargaSepatu}",
              style: TextStyle(fontSize: 16, color: MyColor.secondaryColor),
            )
          ])
        ],
      ),
    );
  }
}
