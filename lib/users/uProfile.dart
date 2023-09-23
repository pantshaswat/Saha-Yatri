import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Saha_Yatri/Interfaces/searchRoutes.dart';

import '../drivers/Dprofile.dart';

class userInfoPage extends StatefulWidget {
  @override
  _userInfoPageState createState() => _userInfoPageState();
}

class _userInfoPageState extends State<userInfoPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      // Retrieve the document containing the user's data
      DocumentSnapshot snapshot = await _userRef
          .doc(user?.email)
          .get(); // Replace 'userId' with the actual user ID

      if (snapshot.exists) {
        // Get the data from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Set the data as hint text for the respective fields
        userNameController.text = data['First Name'] ?? '';
        lastNameController.text = data['Last Name'] ?? '';
        if (!mounted) return;
        setState(() {});
      }
    } catch (e) {
      print('Error retrieving driver data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //define a set

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Personal Information",
          style: TextStyle(
            fontFamily: 'mainFont',
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "User",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "${userNameController.text} ${lastNameController.text} ",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${user?.email}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              textfield(
                Controller: userNameController,
                hinttext: "${user?.displayName}",
                labeltext: 'First Name',
                icon: Icons.person,
              ),
              textfield(
                Controller: lastNameController,
                hinttext: "Last Name",
                labeltext: 'Last Name',
                icon: Icons.person,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                //decoration with round edges
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  primary: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  updateUserData(user?.email, userNameController.text,
                      lastNameController.text);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserData(
    String email,
    String firstName,
    String lastName,
  ) async {
    if (userNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all")),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.email)
          .set({
            'Email': email,
            'First Name': firstName,
            'Last Name': lastName,
          }, SetOptions(merge: true))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User updated")),
              ))
          .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Something wrong. Please try later")),
              ));
    }
  }
}
