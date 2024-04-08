import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/screen.dart';
import 'package:strideflex_application_1/screen/homepage/homepage.dart';
import 'package:strideflex_application_1/screen/lupaPassword/lupapassword.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = ['EROR 1', 'EROR 2'];
  @override
  Widget build(BuildContext context) {
    bool? remember = false;

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: TextFormField(
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
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "Please Enter Your Email";
                //   }
                //   return null;
                // },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  labelText: "Password",
                  hintText: "Input Your Password ..",
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.lock_outline_rounded),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Saving"),
                          ));
                          Navigator.pushNamed(context, MyScreen.routeName);
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))),
            )
          ],
        ));
  }
}
