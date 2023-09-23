import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Saha_Yatri/Interfaces/myMap.dart';
import 'package:Saha_Yatri/Interfaces/searchRoutes.dart';

class VerifyOrHome extends StatefulWidget {
  const VerifyOrHome({super.key});

  @override
  State<VerifyOrHome> createState() => _VerifyOrHomeState();
}

class _VerifyOrHomeState extends State<VerifyOrHome> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again later."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? SearchPage()
      : Scaffold(
          appBar: AppBar(title: const Text("Verify your Email")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "A verification mail has been sent to your Email",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: 380,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 23, 17, 17),
                          side: const BorderSide(
                              width: 1, color: Color.fromARGB(255, 72, 71, 71)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      icon: const Icon(Icons.email),
                      label: const Text("Resent Email"),
                      onPressed:
                          canResendEmail ? sendVerificationEmail : () {}),
                ),
                const Text(
                  "Wait for some time before pressing again",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                ),
                TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 25),
                    ))
              ],
            ),
          ),
        );
}
