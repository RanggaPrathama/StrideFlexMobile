import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/screen/login/login.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obsecured = true;
  bool _obscured2 = true;

  late String? errorMessage;
  late List<dynamic> listErrors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future<void> register() async {
    try {
      //print("masuk");
      Map<String, String> header = {
        "Content-Type": "application/json",
      };

      var url = Uri.parse("${Config.baseURL}/register");
      print(_controllerEmail.text);
      print(_controllerName.text);
      print(_controllerPassword.text);
      print(_controllerConfirmPassword.text);
      var response = await http.post(url,
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "nama_user": _controllerName.text,
            "email": _controllerEmail.text,
            "password": _controllerPassword.text,
            "confirmPassword": _controllerConfirmPassword.text,
          }));
      print(url);

      // if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Register Success !"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacementNamed(context, Login.routeName);
      } else if (data["error"] != null) {
        dynamic errors = data["error"];
        setState(() {
          errorMessage = errors;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$errorMessage"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ));
        // print("Failed  register: ${response.reasonPhrase}");
      } else {
        List<dynamic> errors = data["errors"];
        setState(() {
          listErrors = errors;
        });
        String combinedErrors = listErrors.map((e) => e['msg']).join('\n');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$combinedErrors"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ));
      }
      // } else {
      //   print("Failed to register: ${response.reasonPhrase}");
      //   print(response.statusCode);
      // }
    } catch (e) {
      print("error : $e");
    }
  }

  cekRegister() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      //print("aku ");
      _formKey.currentState!.save();
      register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                controller: _controllerName,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  labelText: "Name",
                  hintText: "Input Your Email ..",
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.person),
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
                  if (value!.isEmpty) {
                    return "Please Enter Your Email";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _controllerPassword,
                obscureText: _obsecured,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  labelText: "Password",
                  hintText: "Input Your Password ..",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecured = !_obsecured;
                        });
                      },
                      icon: Icon(_obsecured
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _controllerConfirmPassword,
                obscureText: _obscured2,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  labelText: "Password Verification",
                  hintText: "Input Your Password ..",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscured2 = !_obscured2;
                        });
                      },
                      icon: Icon(_obscured2
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
                  if (value != _controllerPassword.text) {
                    print("password not match");
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700),
                      onPressed: cekRegister,
                      // if (_formKey.currentState!.validate()) {
                      //   _formKey.currentState!.save();
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text("Saving"),
                      //   ));
                      //   Navigator.pushNamed(context, Login.routeName);
                      // }

                      child: Text(
                        "Register ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))),
            ),
            SizedBox(height: 20)
          ],
        ));
  }
}
