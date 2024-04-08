import 'package:flutter/material.dart';
import 'package:strideflex_application_1/screen/login/login.dart';
import 'package:strideflex_application_1/screen/register/register.dart';

class ForgetForm extends StatefulWidget {
  const ForgetForm({super.key});

  @override
  State<ForgetForm> createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  final _formKey = GlobalKey<FormState>();

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
                  if (value!.isEmpty) {
                    return "Please Enter Your Email";
                  }
                  return null;
                },
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Saving"),
                          ));
                          Navigator.pushNamed(context, Login.routeName);
                        }
                      },
                      child: Text(
                        "Continue ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))),
            ),
            SizedBox(height: 30),
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
          ],
        ));
  }
}
