import 'package:flutter/material.dart';
import 'package:strideflex_application_1/screen/login/components/form_login.dart';
import 'package:strideflex_application_1/screen/register/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                          //height: 150,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Image.asset("assets/logo/logoNoBG.png")),
                    ],
                  ),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                ),
                FormLogin(),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an Account ?",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Register.routeName);
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(color: Colors.blue.shade700),
                        ))
                  ],
                ),

                // Text(
                //   "Agree With Your Term and Conditions",
                //   style: TextStyle(color: Colors.grey.shade600),
                // )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
