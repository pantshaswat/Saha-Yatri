import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Saha_Yatri/Components/verifyOrhome.dart';
import 'package:Saha_Yatri/Interfaces/driversRegister.dart';
import '../Components/myDivider.dart';
import '../Components/myIconButton.dart';
import '../Components/textField.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../main.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool isUserRegistered = false;
  Future<void> registerUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        });
    try {
      String errorMessage;
      if (firstNameController.text.trim().isNotEmpty &&
          lastNameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty) {
        if (_passwordController.text == _confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              //adding names and email
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

          addUserDetails(firstNameController.text.trim(),
              lastNameController.text.trim(), _emailController.text.trim());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Verify your email")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords doesn't match")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All fields are Mandatory")),
        );
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email already exists")),
        );
        Navigator.pop(context);
        //print("Email already Exists");
      }
    }
  }

  addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('Users').doc(email).set({
      'First Name': firstName,
      'Last Name': lastName,
      'Email': email,
    });
  }

  void initstate() {
    super.initState();
    isUserRegistered = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  bool isPassShown = true;
  bool isConPassShown = true;
  IconData? passIcon() {
    if (isPassShown) {
      return Icons.remove_red_eye;
    } else if (!isPassShown) {
      return Icons.no_adult_content;
    }
  }

  IconData? conPassIcon() {
    if (isConPassShown) {
      return Icons.remove_red_eye;
    } else if (!isConPassShown) {
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

            //Register Here!
            const SizedBox(height: 15),
            const Text(
              "Register Here!",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'mainFont',
                  fontSize: 55,
                  fontWeight: FontWeight.bold),
            ),
            //first name
            const SizedBox(height: 10),
            reusableTextField("Enter your First Name", Icons.person_2_outlined,
                false, firstNameController),
            //last name
            const SizedBox(height: 10),
            reusableTextField("Enter your Last Name", Icons.person_2_outlined,
                false, lastNameController),
            //Email
            const SizedBox(height: 10),
            reusableTextField(
                "Enter your Email", Icons.mail, false, _emailController),
            //pass
            const SizedBox(height: 10),
            reusableTextField("Enter your Password", Icons.lock_outlined,
                isPassShown, _passwordController, suffixIcon: passIcon(),
                onTap: () {
              setState(() {
                isPassShown = !isPassShown;
              });
            }),
            //confirm pass
            const SizedBox(height: 10),
            reusableTextField("Confirm your Password", Icons.lock_outlined,
                isConPassShown, _confirmPasswordController,
                suffixIcon: conPassIcon(), onTap: () {
              setState(() {
                isConPassShown = !isConPassShown;
              });
            }),

            //Register button
            const SizedBox(height: 10),
            elevatedButtons(registerUser, "Register", 50, w * 0.9),

            //Or Register with
            const SizedBox(height: 20),
            Row(
              children: [
                myDivider(),
                const Text('Already a user?',
                    style: TextStyle(
                        color: Color.fromARGB(255, 82, 81, 81), fontSize: 15)),
                myDivider(),
              ],
            ),
            //Gmail,Facebook
            const SizedBox(height: 10),

            //Don't have account?  Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Login now",
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
