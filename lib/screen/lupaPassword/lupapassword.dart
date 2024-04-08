import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/screen/lupaPassword/components/formlupapassword.dart';

class LupaPassword extends StatelessWidget {
  const LupaPassword({Key? key}) : super(key: key);

  static String routeName = "/forgetPassword";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forget Password",
          style: headingAuth,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.zero,
                foregroundColor: Colors.blue,
                elevation: 0,
                backgroundColor: Colors.white),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset("assets/logo/logoNoBG.png")),
                  ],
                ),
              ),
              Text(
                "Forget Password",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
              ForgetForm(),
            ],
          ),
        ),
      )),
    );
    ;
  }
}
