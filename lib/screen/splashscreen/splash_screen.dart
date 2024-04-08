import 'package:flutter/material.dart';
import 'package:strideflex_application_1/screen/splashscreen/components/body_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String routeName = '/splashscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyScreen(),
      ),
    );
  }
}
