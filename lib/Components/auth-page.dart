import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Saha_Yatri/Components/loginOrregister.dart';
import 'package:Saha_Yatri/Components/verifyOrhome.dart';
import 'package:Saha_Yatri/Interfaces/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // user is logged in
        if (snapshot.hasData) {
          return const VerifyOrHome();
        }

        //user is not logged in
        else {
          return const LoginPage();
        }
      },
    ));
  }
}
