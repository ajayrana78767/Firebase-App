// ignore_for_file: must_be_immutable, override_on_non_overriding_member, unused_local_variable, use_build_context_synchronously, empty_catches

import 'package:firebase_app/ui/auth/posts/posts_screen.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  String verificationId;
  VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.lightBlue,
  //       title: const Text(
  //         "Verify",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       centerTitle: true,
  //     ),
  //     body: const Column(
  //       children: [],
  //     ),
  //   );
  // }
  final verifyCodeController = TextEditingController();
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Verify",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: verifyCodeController,
              decoration: const InputDecoration(hintText: '6 digit code'),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              color: Colors.lightBlue,
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: verifyCodeController.text.toString());
                    try {
                      await auth.signInWithCredential(credential);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostScreen()));
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      Utils().toastMessage(e.toString());
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Verify",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
