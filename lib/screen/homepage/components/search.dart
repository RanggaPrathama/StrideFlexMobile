import 'package:flutter/material.dart';

class SearchHome extends StatelessWidget {
  const SearchHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          width: double.infinity,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey.shade700,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Nike Shoes Promo Up To 50 % 🙌",
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            )
          ]),
        ),
      ),
    );
  }
}
