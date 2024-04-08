import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:strideflex_application_1/model/brandModel.dart';

class ListBrand extends StatelessWidget {
  final BrandModel brand;
  final bool dipilih;
  const ListBrand({Key? key, required this.brand, required this.dipilih})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.4,
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: dipilih ? Colors.blue.shade400 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: dipilih ? Colors.blue.shade200 : Colors.grey.shade300,
              width: 2)),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SvgPicture.asset(
          "${brand.image}",
          height: 30,
          color: dipilih ? Colors.white : null,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${brand.namebrand}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: dipilih ? Colors.white : Colors.black),
            ),
            Text(
              "${brand.valueproduct} Product",
              style: TextStyle(
                  fontSize: 10, color: dipilih ? Colors.white : Colors.black),
            )
          ],
        )
      ]),
    );
  }
}
