import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/myDivider.dart';
import '../Components/myIconButton.dart';
import '../Components/textField.dart';
import '../consts/colors.dart';
import '../consts/images.dart';

class driversRegisterView extends StatefulWidget {
  const driversRegisterView({super.key});

  @override
  _driversRegisterViewState createState() => _driversRegisterViewState();
}

class _driversRegisterViewState extends State<driversRegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final busCompanyController = TextEditingController();
  final busNumberController = TextEditingController();
  final busColorController = TextEditingController();
  final busCapacityController = TextEditingController();
  final driverContactNumController = TextEditingController();
  String? selectedRoute;
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
          driverContactNumController.text.trim().isNotEmpty &&
          busCompanyController.text.trim().isNotEmpty &&
          busNumberController.text.trim().isNotEmpty &&
          busColorController.text.trim().isNotEmpty &&
          busCapacityController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty &&
          selectedRoute != null) {
        if (_passwordController.text == _confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              //adding names and email
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

          addUserDetails(
              firstNameController.text.trim(),
              lastNameController.text.trim(),
              _emailController.text.trim(),
              driverContactNumController.text.trim(),
              busCompanyController.text.trim(),
              busNumberController.text.trim(),
              busColorController.text.trim(),
              busCapacityController.text.trim());

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
        // print("Email already Exists");
      }
    }
  }

  addUserDetails(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String busCompany,
      String busNumber,
      String busColor,
      String busCapacity) async {
    await FirebaseFirestore.instance.collection('Drivers').doc(email).set({
      'First Name': firstName,
      'Last Name': lastName,
      'Phone Number': phoneNumber,
      'Bus Company': busCompany,
      'Bus Number': busNumber,
      'Bus Color': busColor,
      'Bus Capacity': busCapacity,
      'Email': email,
      'isDriver': false,
      'latitude': 0,
      'longitude': 0,
      'route': selectedRoute,
    });
  }

  void initState() {
    super.initState();
    checkDriver();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    driverContactNumController.dispose();
    busCompanyController.dispose();
    busNumberController.dispose();
    busColorController.dispose();
    busCapacityController.dispose();
    super.dispose();
  }

  List<dynamic> allRoutee = [];
  void checkDriver() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Route details').get();
    setState(() {
      querySnapshot.docs.map((doc) => allRoutee.add(doc.id)).toList();
    });
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
            // SahaYatri logo
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

            const Text(
              "Register Here!",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'mainFont',
                  fontSize: 55,
                  fontWeight: FontWeight.bold),
            ),
            //first name
            const SizedBox(height: 5),
            reusableTextField(
              "Enter your First Name",
              Icons.person_2_outlined,
              false,
              firstNameController,
            ),
            //last name
            const SizedBox(height: 5),
            reusableTextField(
              "Enter your Last Name",
              Icons.person_2_outlined,
              false,
              lastNameController,
            ),
            //Phone number
            const SizedBox(height: 5),
            reusableTextField(
              "Enter your Phone Number",
              Icons.call,
              false,
              driverContactNumController,
            ),
            //Bus company
            const SizedBox(height: 5),
            reusableTextField(
                "Bus Company", Icons.train, false, busCompanyController),
            //Bus number
            const SizedBox(height: 5),
            reusableTextField(
              "Bus Number eg: Ba 3 kha 2212",
              Icons.train,
              false,
              busNumberController,
            ),
            //Bus color
            const SizedBox(height: 5),
            reusableTextField(
              "Bus Color",
              Icons.train,
              false,
              busColorController,
            ),
            //Bus capacity
            const SizedBox(height: 5),
            reusableTextField(
              "Bus Capacity",
              Icons.train,
              false,
              busCapacityController,
            ),
            //Email
            const SizedBox(height: 5),
            reusableTextField(
              "Enter your Email",
              Icons.mail,
              false,
              _emailController,
            ),
            //pass
            const SizedBox(height: 5),
            reusableTextField("Enter your Password", Icons.lock_outlined,
                isPassShown, _passwordController, suffixIcon: passIcon(),
                onTap: () {
              setState(() {
                isPassShown = !isPassShown;
              });
            }),
            //confirm pass
            const SizedBox(height: 5),
            reusableTextField("Confirm your Password", Icons.lock_outlined,
                isConPassShown, _confirmPasswordController,
                suffixIcon: conPassIcon(), onTap: () {
              setState(() {
                isConPassShown = !isConPassShown;
              });
            }),
            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Your Route : ",
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<String>(
                  value: selectedRoute,
                  items: allRoutee.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRoute = value;
                    });
                  },
                ),
              ],
            ),
            //Register button
            const SizedBox(height: 15),
            elevatedButtons(registerUser, "Register", 50, w * 0.9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already a Driver? "),
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
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ))));
  }
}
