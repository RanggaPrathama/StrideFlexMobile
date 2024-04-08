import 'package:flutter/material.dart';
import 'package:strideflex_application_1/screen/login/login.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                //keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  labelText: "Password Verification",
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
                          Navigator.pushNamed(context, Login.routeName);
                        }
                      },
                      child: Text(
                        "Register ",
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
