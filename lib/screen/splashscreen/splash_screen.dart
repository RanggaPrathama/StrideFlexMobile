import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String routeName = '/splashscreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // await Future.delayed(Duration(seconds: 10));
    bool isValidToken = await _checkTokenValidity();
    print("tes isValidToken : $isValidToken");
    if (isValidToken) {
      Navigator.pushReplacementNamed(context, MyScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, Login.routeName);
    }
  }

  Future<bool> _checkTokenValidity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken.containsKey('exp')) {
        int? exp = decodedToken['exp'];
        if (exp != null) {
          DateTime now = DateTime.now();
          DateTime tokenExpTime =
              DateTime.fromMillisecondsSinceEpoch(exp * 1000);

          DateTime tokenExpLimit = tokenExpTime.add(Duration(hours: 3));
          if (now.isBefore(tokenExpLimit)) {
            return true;
          }
        }
      }
    }
    prefs.clear();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyScreen(),
      ),
    );
  }
}
