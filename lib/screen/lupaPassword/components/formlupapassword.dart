import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/screen/login/login.dart';

class ForgetForm extends StatefulWidget {
  const ForgetForm({super.key});

  @override
  State<ForgetForm> createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _controllerOldPassword = TextEditingController();
  TextEditingController _controllerNewPassword = TextEditingController();
  bool _obsecured = true;

  Future<void> forgetPassword() async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json; charset=UTF-8",
      };

      var url = Uri.parse("${Config.baseURL}/newPassword");
      var response = await http.put(url,
          headers: header,
          body: json.encode(<String, dynamic>{
            "email": _emailController.text,
            "password": _controllerOldPassword.text,
            "newPassword": _controllerNewPassword.text,
          }));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print(response.body);
        if (data["message"] == "Password updated") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("Password updated")));
          Navigator.pushNamed(context, Login.routeName);
        }
      } else {
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text("${data["message"]}")));
      }
    } catch (e) {
      print(e);
    }
  }

  void cekForget() {
    if (_formKey.currentState!.validate() && _formKey.currentState != null) {
      _formKey.currentState!.save();
      forgetPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                controller: _emailController,
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
                controller: _controllerOldPassword,
                obscureText: _obsecured,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  labelText: "Old Password",
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Your Password';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _controllerNewPassword,
                obscureText: _obsecured,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Your New Password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  labelText: "New Password",
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
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700),
                      onPressed: cekForget,
                      child: Text(
                        "Forget Password ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))),
            ),
            SizedBox(height: 10),
          ],
        ));
  }
}
