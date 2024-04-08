import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:strideflex_application_1/model/brandModel.dart';

class ListBrandCustom extends StatelessWidget {
  const ListBrandCustom(
      {Key? key, required this.brandList, required this.isTap})
      : super(key: key);

  final BrandModel brandList;
  final bool isTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isTap ? Colors.blue.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${brandList.image}",
            width: 35,
            color: isTap ? Colors.white : Colors.black,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${brandList.namebrand}",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isTap ? Colors.white : Colors.black)),
              Text(
                "${brandList.valueproduct} products",
                style: TextStyle(
                  fontSize: 12,
                  color: isTap ? Colors.white : Colors.grey.shade600,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
