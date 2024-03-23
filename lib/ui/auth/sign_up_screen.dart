// ignore_for_file: prefer_final_fields, unused_field, unnecessary_import, avoid_print, unused_local_variable

import 'package:firebase_app/ui/provider/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _islading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isshowPassword = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   nameController.dispose();
  //   passwordController.dispose();
  //   emailController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
     final provider=Provider.of<GoogleSignInProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "SignUp",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TextFormField(
              //   controller: nameController,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: const InputDecoration(
              //       prefixIcon: Icon(Icons.person), hintText: "Name"),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email), hintText: "Email"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _isshowPassword,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isshowPassword = !_isshowPassword;
                          });
                        },
                        icon: Icon(_isshowPassword
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    hintText: "password"),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                color: Colors.lightBlue,
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _islading = true;
                        });
                        _auth
                            .createUserWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString())
                            .then((value) {
                          setState(() {
                            _islading = false;
                          });
                        }).onError((error, stackTrace) {
                          print("$error");
                          //  Utils().toastMessage(error.toString());
                          Fluttertoast.showToast(
                            msg: "$error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.lightBlue,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          setState(() {
                            _islading = false;
                          });
                        });
                      }
                    },
                    child: _islading
                        ? const CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.white,
                          )
                        : const Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '-----------or-----------',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      print('hello');
                     
                      provider.googleLogin();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 162, 160, 160),
                              blurRadius: 9,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset('assets/icons/google_icon.svg'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 162, 160, 160),
                            blurRadius: 9,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset('assets/icons/facebook_icon.svg'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 162, 160, 160),
                            blurRadius: 9,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          SvgPicture.asset('assets/icons/instagram_icon2.svg'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
