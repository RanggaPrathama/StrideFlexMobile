import 'package:flutter/material.dart';
import 'package:strideflex_application_1/core.dart'; // Ganti dengan path ke HomePage Anda

class BodyScreen extends StatefulWidget {
  const BodyScreen({Key? key, this.isLoading = false}) : super(key: key);
  final bool isLoading;
  @override
  State<BodyScreen> createState() => BodyScreenState();
}

class BodyScreenState extends State<BodyScreen> {
  int pageSaatIni = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageSaatIni);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void changePage(int index) {
    setState(() {
      pageSaatIni = index;
    });
  }

  List<Map<String, String>> dataSplash = [
    {
      "text": "Welcome to StrideFlex, Lets go shopping !!",
      "image": "assets/lottie/Animation - 1710339398450.json"
    },
    {
      "text": "Just shop at home !! ",
      "image": "assets/lottie/Animation - 1710339463090.json"
    },
    {
      "text": "Lorem ipsum dolor sit amet, consectetur",
      "image": "assets/lottie/Animation - 1710339647426.json"
    }
  ];

  @override
  Widget build(BuildContext context) {
    bool isLastPage = pageSaatIni == dataSplash.length - 1;
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 6,
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      changePage(value);
                    },
                    itemCount: dataSplash.length,
                    itemBuilder: (context, index) => SplashContent(
                          image: dataSplash[index]["image"]!,
                          text: dataSplash[index]["text"]!,
                        ))),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              dataSplash.length, (index) => dotSplash(index))),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700),
                            onPressed: () {
                              if (isLastPage) {
                                Navigator.pushNamed(context, Login.routeName);
                              } else {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: Text(
                              isLastPage ? "Get Started" : "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                      ),
                      Spacer(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  AnimatedContainer dotSplash(int index) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 6),
        width: pageSaatIni == index ? 30 : 6,
        height: pageSaatIni == index ? 8 : 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: pageSaatIni == index
              ? Colors.blue.shade700
              : Colors.grey.shade800,
        ));
  }
}
