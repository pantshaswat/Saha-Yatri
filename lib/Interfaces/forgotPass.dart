import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/textField.dart';
import '../consts/colors.dart';
import '../consts/images.dart';

class forgotPass extends StatefulWidget {
  const forgotPass({super.key});

  @override
  State<forgotPass> createState() => _forgotPassState();
}

class _forgotPassState extends State<forgotPass> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Password Reset link has been sent to your email"),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: pWhite,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          //SahaYatri logo
          Row(
            children: [
              const Spacer(),
              const Text("Saha Yatri",
                  style: TextStyle(fontFamily: 'mainFont', fontSize: 25)),
              Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(busLogo)),
            ],
          ),

          //Forgot password?
          const SizedBox(height: 80),

          const Text(
            "Forgot Password?",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'mainFont',
                fontSize: 50,
                fontWeight: FontWeight.bold),
          ),
          //Email
          const SizedBox(height: 80),
          reusableTextField("Enter your Email", Icons.person_2_outlined, false,
              emailController),
          //pass

          //ForgotPassword button
          const SizedBox(height: 30),
          elevatedButtons(passwordReset, "Send Link", 50, w * 0.9),

          //Don't have account?  Register now
          const SizedBox(height: 130),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Remember Password? "),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Login",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 24, 192, 122),
                      )))
            ],
          )
        ]),
      )),
    );
  }
}
