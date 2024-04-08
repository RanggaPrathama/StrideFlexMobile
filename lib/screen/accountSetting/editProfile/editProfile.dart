import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  static String routeName = "/editProfile";

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _obsecured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Profile",
            style: headingText,
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: MyColor.secondaryColor, width: 2),
                          image: DecorationImage(
                            image: AssetImage("assets/image/fotoku.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 60,
                        bottom: 0,
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 25),
                            labelText: "Full Name",
                            hintText: "Input Your Full Name..",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.person),
                            ),

                            //floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                                //gapPadding: 10,
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade500, width: 2)),

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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 25),
                            labelText: "Email",
                            hintText: "Input Your Email ..",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.email_outlined),
                            ),

                            //floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                                //gapPadding: 10,
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade500, width: 2)),

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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 25),
                            labelText: "Phone",
                            hintText: "Input Your Phone ..",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.phone),
                            ),

                            //floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                                //gapPadding: 10,
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade500, width: 2)),

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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: _obsecured,

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 25),
                            labelText: "Password",
                            hintText: "Input Your Password ..",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.fingerprint),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obsecured = !_obsecured;
                                  });
                                },
                                icon: Icon(_obsecured
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            //floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                                //gapPadding: 10,
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade500, width: 2)),

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
                      SizedBox(height: 20),
                      CustomButton(
                          width: double.infinity,
                          height: 60,
                          text: "Edit Profile",
                          press: () {})
                    ],
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
