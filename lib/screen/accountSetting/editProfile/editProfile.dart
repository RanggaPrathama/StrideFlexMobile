import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import "package:mime/mime.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/config.dart';
import 'package:strideflex_application_1/screen/deleteAccount/deleteAccount.dart';
import 'package:strideflex_application_1/widget/customButton.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  static String routeName = "/editProfile";

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  bool _obsecured = true;
  int? idUser;
  String? namaUser;
  String? emailUser;
  int? phoneNumber;
  Map<String, dynamic> userList = {};
  File? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> pilihImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> getUserAPI(int idUser) async {
    var url = Uri.parse("${Config.baseURL}/profile/$idUser");
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var data = json["data"];
      setState(() {
        userList = data;
      });
      print(userList);
    }
  }

  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString("token") ?? "";
    if (token.isNotEmpty) {
      decodeToken(token);
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    int id_user = payload["id_user"];
    String nama_user = payload["nama_user"];
    String email_user = payload["email"];
    //int phone_number = payload["phoneNumber"];
    setState(() {
      idUser = id_user;
      namaUser = nama_user;
      emailUser = email_user;
      //phoneNumber = phone_number;
    });
    getUserAPI(id_user);
  }

  Future<void> updateProfile(int idUser) async {
    Map<String, String> headers = {"Content-Type": "multipart/form-data"};
    print("aku disini masuuuk");
    //print(idUser);

    var url = Uri.parse("${Config.baseURL}/profile/update/$idUser");
    var request = http.MultipartRequest('PATCH', url);

    if (_image != null) {
      // print(_image!.path);
      // Get MIME type of the file
      final mimeType = lookupMimeType(_image!.path);
      print('MIME type: $mimeType');

      // Add file with MIME type
      request.files.add(await http.MultipartFile.fromPath('file', _image!.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null));
    }
    request.fields["phoneNumber"] = _telephoneController.text;
    request.fields["nama_user"] = _namaController.text;
    print("Request : $request");
    try {
      var response = await request.send();
      print(response);

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        print('Profile updated: $jsonResponse');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text("Profile Update Successfully")));
      } else {
        var responseData = await response.stream.bytesToString();
        print('Error: ${response.statusCode}');
        print('Error response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Update Profile Failed")));
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void cekProfile() {
    print("aku disini");
    if (_formKey.currentState!.validate() && _formKey.currentState != null) {
      _formKey.currentState!.save();
      updateProfile(idUser!);
    }
  }

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
                              color: MyColor.secondaryColor, width: 3),
                          // image: DecorationImage(
                          //   image: AssetImage("assets/image/fotoku.jpg"),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(_image!, fit: BoxFit.cover))
                            : (userList["gambar_profile"] != null &&
                                    userList["gambar_profile"] != "")
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                        "${Config.baseURL}/images/profile/${userList["gambar_profile"]}",
                                        fit: BoxFit.cover))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset("assets/image/user.png",
                                        fit: BoxFit.cover)),
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
                            onPressed: pilihImage,
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
                          controller: _namaController,
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 25),
                            labelText: "$namaUser",
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
                              labelText: "$emailUser",
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
                              enabled: false),
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
                          controller: _telephoneController,
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 25),
                            labelText: userList["phoneNumber"] != null
                                ? "${userList["phoneNumber"]}"
                                : "Phone",
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 10, horizontal: 5),
                      //   child: TextFormField(
                      //     style: Theme.of(context).textTheme.bodySmall,
                      //     keyboardType: TextInputType.emailAddress,
                      //     obscureText: _obsecured,
                      //
                      //     decoration: InputDecoration(
                      //       contentPadding: EdgeInsets.symmetric(
                      //           vertical: 22, horizontal: 25),
                      //       labelText: "Password",
                      //       hintText: "Input Your Password ..",
                      //       prefixIcon: const Padding(
                      //         padding: EdgeInsets.only(left: 10.0),
                      //         child: Icon(Icons.fingerprint),
                      //       ),
                      //       suffixIcon: IconButton(
                      //           onPressed: () {
                      //             setState(() {
                      //               _obsecured = !_obsecured;
                      //             });
                      //           },
                      //           icon: Icon(_obsecured
                      //               ? Icons.visibility_off
                      //               : Icons.visibility)),
                      //       //floatingLabelBehavior: FloatingLabelBehavior.always,
                      //       enabledBorder: OutlineInputBorder(
                      //           //gapPadding: 10,
                      //           borderRadius: BorderRadius.circular(40),
                      //           borderSide: BorderSide(
                      //               color: Colors.grey.shade500, width: 2)),
                      //
                      //       focusedBorder: OutlineInputBorder(
                      //         //gapPadding: 10,
                      //         borderSide: BorderSide(
                      //           color: Colors.blue,
                      //           width: 2,
                      //         ),
                      //         borderRadius: BorderRadius.circular(40),
                      //       ),
                      //     ),
                      //     // validator: (value) {
                      //     //   if (value!.isEmpty) {
                      //     //     return "Please Enter Your Email";
                      //     //   }
                      //     //   return null;
                      //     // },
                      //   ),
                      // ),Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 10, horizontal: 5),
                      //   child: TextFormField(
                      //     style: Theme.of(context).textTheme.bodySmall,
                      //     keyboardType: TextInputType.emailAddress,
                      //     obscureText: _obsecured,
                      //
                      //     decoration: InputDecoration(
                      //       contentPadding: EdgeInsets.symmetric(
                      //           vertical: 22, horizontal: 25),
                      //       labelText: "Password",
                      //       hintText: "Input Your Password ..",
                      //       prefixIcon: const Padding(
                      //         padding: EdgeInsets.only(left: 10.0),
                      //         child: Icon(Icons.fingerprint),
                      //       ),
                      //       suffixIcon: IconButton(
                      //           onPressed: () {
                      //             setState(() {
                      //               _obsecured = !_obsecured;
                      //             });
                      //           },
                      //           icon: Icon(_obsecured
                      //               ? Icons.visibility_off
                      //               : Icons.visibility)),
                      //       //floatingLabelBehavior: FloatingLabelBehavior.always,
                      //       enabledBorder: OutlineInputBorder(
                      //           //gapPadding: 10,
                      //           borderRadius: BorderRadius.circular(40),
                      //           borderSide: BorderSide(
                      //               color: Colors.grey.shade500, width: 2)),
                      //
                      //       focusedBorder: OutlineInputBorder(
                      //         //gapPadding: 10,
                      //         borderSide: BorderSide(
                      //           color: Colors.blue,
                      //           width: 2,
                      //         ),
                      //         borderRadius: BorderRadius.circular(40),
                      //       ),
                      //     ),
                      //     // validator: (value) {
                      //     //   if (value!.isEmpty) {
                      //     //     return "Please Enter Your Email";
                      //     //   }
                      //     //   return null;
                      //     // },
                      //   ),
                      // ),
                      SizedBox(height: 20),
                      CustomButton(
                          width: double.infinity,
                          height: 60,
                          text: "Edit Profile",
                          press: cekProfile),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, DeleteAccount.routeName,
                                arguments:
                                    DeleteAccountArguments(idUser: idUser!));
                          },
                          child: Text(
                            "Delete Account",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ))
                    ],
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
