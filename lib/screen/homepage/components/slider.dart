import 'package:flutter/material.dart';
import 'package:strideflex_application_1/screen/homepage/components/slider_contents.dart';

class SliderHome extends StatefulWidget {
  const SliderHome({Key? key}) : super(key: key);

  @override
  State<SliderHome> createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  var currentPage = 0;

  List<Map<String, String>> gambar = [
    {
      "gambar":
          "assets/image/Blue Red Black Modern Shoes Promotion Instagram Post.png",
    },
    {
      "gambar": "assets/image/Gradient Men Shoes Promo Instagram Post.png",
    },
    {
      "gambar": "assets/image/Gradient Men Shoes Promo Instagram Post.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            height: 150,
            child: PageView.builder(
                onPageChanged: (nilai) {
                  setState(() {
                    currentPage = nilai;
                  });
                },
                itemCount: gambar.length,
                itemBuilder: ((context, index) =>
                    SliderContents(image: gambar[index]["gambar"]!)))),
        Positioned.fill(
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    gambar.length,
                    (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: currentPage == index ? 30 : 8,
                          height: 8,
                          margin: EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentPage == index
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade500,
                              border: Border.all(color: Colors.black)),
                        )),
              ),
            ))
      ],
    );
  }
}
