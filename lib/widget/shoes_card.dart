import 'package:flutter/material.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';
import 'package:strideflex_application_1/screen/detailpage/detailShoes.dart';

class ShoesCard extends StatefulWidget {
  const ShoesCard({Key? key, required this.shoes, required this.action})
      : super(key: key);

  final ShoesModel shoes;
  final VoidCallback action;

  @override
  _ShoesCardState createState() => _ShoesCardState();
}

class _ShoesCardState extends State<ShoesCard> {
  // bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.action();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.action();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset("${widget.shoes.image[0]}"),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.31,
                  child: IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        widget.shoes.isLiked = !widget.shoes.isLiked;
                      });
                    },
                    icon: Icon(
                      widget.shoes.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: widget.shoes.isLiked ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Container(
                child: Text(
                  "${widget.shoes.nameShoes}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Container(
                //alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.shoes.description}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Rp.${widget.shoes.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blue.shade700,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add_shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
