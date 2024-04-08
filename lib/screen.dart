import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:strideflex_application_1/screen/store/store.dart';
import 'package:strideflex_application_1/screen/favourite/favourite.dart';
import 'package:strideflex_application_1/screen/homepage/homepage.dart';
import 'package:strideflex_application_1/screen/accountSetting/profile/profile.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  static String routeName = "/";

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  var pageNow = 0;

  void setPageNav(index) {
    setState(() {
      pageNow = index;
    });
  }

  final pages = [
    const MyHomePage(),
    const StoreScreen(),
    const FavouriteScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[pageNow],
        bottomNavigationBar: GNav(
          onTabChange: setPageNav,
          selectedIndex: pageNow,
          hoverColor: Colors.blue.shade200,
          tabBackgroundColor: Colors.blue,
          //tabActiveBorder: Border.all(width: 2),
          //tabBorderRadius: 15,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          iconSize: 25,
          //rippleColor: Colors.red,
          gap: 10,
          activeColor: Colors.white,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.store_mall_directory_rounded,
              text: "Store",
            ),
            GButton(
              icon: Icons.favorite_border_rounded,
              text: "WishList",
            ),
            GButton(icon: Icons.person, text: "Profile"),
          ],
        ));
  }
}
