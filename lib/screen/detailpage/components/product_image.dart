import 'package:flutter/material.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';

class ProductImage extends StatefulWidget {
  const ProductImage({Key? key, required this.shoes}) : super(key: key);

  final ShoesModel shoes;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  int Selected = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset("${widget.shoes.image[Selected]}"),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              widget.shoes.image.length,
              (index) => MiniImage(
                  image: widget.shoes.image[index],
                  onKlik: () {
                    setState(() {
                      Selected = index;
                    });
                  },
                  selected: Selected == index)),
        )
      ],
    );
  }
}

class MiniImage extends StatefulWidget {
  const MiniImage(
      {Key? key,
      required this.image,
      required this.onKlik,
      required this.selected})
      : super(key: key);

  final bool selected;
  final VoidCallback onKlik;
  final String image;
  @override
  State<MiniImage> createState() => _MiniImageState();
}

class _MiniImageState extends State<MiniImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onKlik,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: widget.selected ? Colors.blue.shade400 : Colors.grey,
              width: 4),
          image: DecorationImage(
            image: AssetImage("${widget.image}"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
