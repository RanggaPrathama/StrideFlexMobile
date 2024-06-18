import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/core.dart';

//enum LoginStatus { notSignIn, signIn }

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  static String tag = 'auth-page';
  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = new TextEditingController();
  final TextEditingController _passwordcontroller = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalObjectKey<ScaffoldState>('AuthPage');

  LoginStatus loginStatus = LoginStatus.notSignIn;

  bool? remember = false;

  bool cekPassword = true;

  String? errorsList;

  Future<void> login() async {
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.parse("${Config.baseURL}/login");

    var response = await http.post(url,
        headers: headers,
        body: json.encode({
          "email": email,
          "password": password,
        }));
    var data = jsonDecode(response.body);
    if (data["message"] == "Login berhasil") {
      String token = data["token"];
      //print(token);
      //print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          content: Text("Login Berhasil")));
      setState(() {
        loginStatus = LoginStatus.signIn;
        saveLocal(token);
      });
      Navigator.pushReplacementNamed(context, MyScreen.routeName);
    } else {
      dynamic errors = data["message"];
      setState(() {
        errorsList = errors;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$errorsList"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }

  saveLocal(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("token", token);
    });
  }

  cekLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      login();
    }
  }
// cekLogin() {
//   if()

// }
  @override
  Widget build(BuildContext context) {
    // switch (loginStatus) {
    //   case LoginStatus.notSignIn:
    //     return body();

    //   case LoginStatus.signIn:
    //     return MyScreen();
    //   default:
    //     return Container();
    // }
    return body();
  }

  Widget body() {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: TextFormField(
                  controller: _emailcontroller,
                  style: Theme.of(context).textTheme.bodySmall,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 22, horizontal: 25),
                    labelText: "Email",
                    hintText: "Input Your Email ..",
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.email_outlined),
                    ),

                    //floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                        //gapPadding: 10,
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            BorderSide(color: Colors.grey.shade500, width: 2)),

                    focusedBorder: OutlineInputBorder(
                      //gapPadding: 10,
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  validator: (value) {
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (value!.isEmpty) {
                      return 'Please Enter Your Email';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Please Enter Valid Email';
                    } else if (!value.contains('@')) {
                      return 'Email must contain @ symbol';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: TextFormField(
                  controller: _passwordcontroller,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: cekPassword,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    labelText: "Password",
                    hintText: "Input Your Password ..",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            cekPassword = !cekPassword;
                          });
                        },
                        icon: Icon(cekPassword
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    //floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                        //gapPadding: 10,
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            BorderSide(color: Colors.grey.shade500, width: 2)),

                    focusedBorder: OutlineInputBorder(
                      //gapPadding: 10,
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Your Password";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Checkbox(
                      value: remember,
                      activeColor: MyColor.secondaryColor,
                      onChanged: (value) {
                        setState(() {
                          remember = value;
                        });
                      }),
                  Expanded(child: Text("Remember me")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LupaPassword.routeName);
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: MyColor.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                  //
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700),
                        onPressed: cekLogin,
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ))),
              )
            ],
          )),
    );
  }
}
