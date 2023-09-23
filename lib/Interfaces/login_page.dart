import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Saha_Yatri/Components/myDivider.dart';
import 'package:Saha_Yatri/Components/myIconButton.dart';
import 'package:Saha_Yatri/Interfaces/driversRegister.dart';
import 'package:Saha_Yatri/Interfaces/forgotPass.dart';
import 'package:Saha_Yatri/Interfaces/register-page.dart';
import '../consts/colors.dart';
import '../Components/textField.dart';
import '../consts/images.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  //Login in Method
  Future<void> logUserIn() async {
    // showing loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        });
//try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      //pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //Wrong Email/pass
      loginErrorMessage(e.code);
    }
  }

//Error Msg to user
  void loginErrorMessage(String message) {
    if (message == 'user-not-found' || message == 'wrong-password') {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Email or Password doesn't exists"),
            );
          });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isPassShown = true;
  IconData? passIcon() {
    if (isPassShown) {
      return Icons.remove_red_eye;
    } else if (!isPassShown) {
      return Icons.no_adult_content;
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text("Saha Yatri",
              style: TextStyle(
                  fontFamily: 'mainFont',
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: pWhite,
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          child: Column(children: [
            //Back button & SahaYatri logo
            Row(
              children: [
                const Spacer(),
                Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(busLogo)),
              ],
            ),

            //Welcome back
            const SizedBox(height: 50),
            const Text(
              "Welcome Back!",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'mainFont',
                  fontSize: 55,
                  fontWeight: FontWeight.bold),
            ),
            //Email
            const SizedBox(height: 45),
            reusableTextField(
              "Enter your Email",
              Icons.person_2_outlined,
              false,
              emailController,
            ),
            //pass
            const SizedBox(height: 10),
            reusableTextField("Enter your Password", Icons.lock_outline,
                isPassShown, passwordController, suffixIcon: passIcon(),
                onTap: () {
              setState(() {
                isPassShown = !isPassShown;
              });
            }),
            //forget pass
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const forgotPass(),
                      ));
                    },
                    child: const Text(
                      'Forgot Password?',
                      style:
                          TextStyle(color: Color.fromARGB(255, 109, 109, 109)),
                    ),
                  ),
                ],
              ),
            ),

            //Login button
            const SizedBox(height: 20),
            elevatedButtons(logUserIn, "Login", 50, w * 0.9),

            //Or login with
            const SizedBox(height: 30),
            Row(
              children: [
                myDivider(),
                const Text('Not a member?',
                    style: TextStyle(
                        color: Color.fromARGB(255, 82, 81, 81), fontSize: 15)),
                myDivider(),
              ],
            ),
            //Gmail,Facebook
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterView(),
                      ));
                    },
                    child: const Text("Register as User",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 24, 192, 122),
                        ))),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const driversRegisterView(),
                      ));
                    },
                    child: const Text("Register as Driver",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 24, 192, 122),
                        ))),
              ],
            )
          ]),
        ))));
  }
}
