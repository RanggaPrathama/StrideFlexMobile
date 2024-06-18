import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/core.dart';
import 'package:strideflex_application_1/model/detailShoesModel.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';
//import 'package:strideflex_application_1/model/shoesModelAPI.dart';

class ProductContent extends StatefulWidget {
  const ProductContent({Key? key, required this.shoes}) : super(key: key);

  final List<ShoesModel> shoes;

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  int selected = 0;
  int counter = 0;

  void counterPlus() {
    setState(() {
      counter++;
    });
  }

  void counterMinus() {
    setState(() {
      counter--;

      if (counter < 0) {
        counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "${widget.shoes[0].nameShoes}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "${widget.shoes[0].nameShoes} - ${widget.shoes[0].warna}",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Rp. ${widget.shoes[0].hargaSepatu}",
            style: TextStyle(
                fontSize: 24,
                color: MyColor.secondaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  widget.shoes[0].isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.shoes[0].isLiked ? Colors.red : Colors.white,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "${widget.shoes[0].description}",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: <Widget>[
              // ...List.generate(
              //     widget.shoes.length,
              //     (index) => Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 5.0),
              //           child: GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 selected = index;
              //               });
              //             },
              //             child: ColorDots(
              //               color: "${widget.shoes[index].tagcolor}",
              //               nama_warna: "${widget.shoes[index].nama_warna}",
              //               isSelected: selected == index,
              //             ),
              //           ),
              //         )),
              Spacer(),
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.2),
              //           spreadRadius: 1,
              //           blurRadius: 1,
              //           offset: Offset(0, 1),
              //         ),
              //       ]),
              //   child: IconButton(
              //       onPressed: counterMinus, icon: Icon(Icons.remove)),
              // ),
              // SizedBox(
              //   width: 20,
              // ),
              // Container(
              //   child: Text("${counter}"),
              // ),
              // SizedBox(width: 20),
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.2),
              //           spreadRadius: 1,
              //           blurRadius: 1,
              //           offset: Offset(0, 1),
              //         ),
              //       ]),
              //   child:
              //       IconButton(onPressed: counterPlus, icon: Icon(Icons.add)),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColorDots extends StatelessWidget {
  const ColorDots({
    super.key,
    required this.color,
    required this.nama_warna,
    required this.isSelected,
  });

  final String color;
  final String nama_warna;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    // int colorParsed = int.parse('0x$color', radix: 16);
    Color colorParsed = Color(int.parse("0xFF" + color));
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                  color: isSelected ? Colors.blue.shade700 : Colors.white,
                  width: 3)),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: colorParsed),
          ),
        ),
        Text(
          "$nama_warna",
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
