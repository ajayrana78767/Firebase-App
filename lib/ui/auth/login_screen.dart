// ignore_for_file: prefer_final_fields, unused_field, unnecessary_import, deprecated_member_use, avoid_print, unnecessary_null_comparison

//import 'package:firebase_app/notification_services.dart';
import 'package:firebase_app/ui/auth/login_with_phone_number.dart';
import 'package:firebase_app/ui/auth/posts/posts_screen.dart';
import 'package:firebase_app/ui/auth/sign_up_screen.dart';
import 'package:firebase_app/ui/forgot_password.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isshowPassword = true;
  final _auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      _isLoading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //  NotificationServices notificationServices = NotificationServices();
    // void initState() {
    //   super.initState();
    //   notificationServices.requestNotificationPermission();
    // }

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please fill a email";
                    }
                    return null;
                  },
                  controller: emailController,
                  // validator: (value) {
                  //   if (value==null || value.isEmpty) {
                  //      // Utils().toastMessage('Please enter a email');
                  //   }
                  //   return null;
                  // },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), hintText: "Email"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.length < 6 || value.isEmpty || value == null) {
                      return "please enter a password atleast 6 words";
                    }
                    return null;
                  },
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
                        // print(emailController)
                        if (_formKey.currentState!.validate()) {
                          login();
                          // Utils().toastMessage('Something went wrong');
                        } else {}
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            )),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          "Sign Up",
                          style:
                              TextStyle(color: Colors.lightBlue, fontSize: 16),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginWithPhoneNumber()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: const Center(
                      child: Text('Login with mobile'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
