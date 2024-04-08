import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/screen/register/components/register_form.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static String routeName = "/register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
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
                "Register Account",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sign up with your email and password  \nor continue with social media",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
              RegisterForm(),
            ],
          ),
        ),
      )),
    );
  }
}
