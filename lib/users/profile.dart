import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:Saha_Yatri/Interfaces/forgotPass.dart';
import 'package:path/path.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class ProfileScreen extends StatefulWidget {
  static final String path = "lib/screens/profile_screen.dart";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  logUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
//make a back button to go back to the screen
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          const CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(
                                'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                            //person network image
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // _selectPhotoAndUpload();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "userName".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: AutofillHints.name,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              //take an email from emailcontroller
                              'emailtext',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Personal Information'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(),
                      ),
                    );
                  }),
              ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const forgotPass(),
                      ),
                    );
                  }),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              const ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              TextButton(
                onPressed: () async {
                  //firebase logout
                  // await .signOut();

                  logUserOut();
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  void initState() {
    super.initState();
    // userNameController.text = '$userName';
    // emailController.text = '$emailtext';
  }

  String? _uploadedPhotoUrl;
  // final PhotoUploader _photoUploader = PhotoUploader();

  // void _capturePhotoAndUpload() async {
  //   final fileName = await _photoUploader.capturePhotoAndUploadToFirestore();
  //   if (fileName != null) {
  //     final url = await _photoUploader.getPhotoUrl(fileName);
  //     setState(() {
  //       _uploadedPhotoUrl = url.toString();
  //     });
  //   }
  // }

  // void _selectPhotoAndUpload() async {
  //   final fileName = await _photoUploader.selectPhotoAndUploadToFirestore();
  //   if (fileName != null) {
  //     final url = await _photoUploader.getPhotoUrl(fileName);
  //     setState(() {
  //       _uploadedPhotoUrl = url.toString();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var userNameController;
    var emailController;
    var phoneController;
    var addressController;
    var cityController;
    var stateController;
    var countryController;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _uploadedPhotoUrl != null
                ? Image.network(
                    _uploadedPhotoUrl!,
                    height: 200,
                  )
                : Container(),
            const SizedBox(height: 16),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () async {
            //     // Save changes to database or local storage
            //     await updateUserData(
            //       // auth.currentUser!.uid,
            //       userNameController.text,
            //       emailController.text,
            //       {},
            //     );
            //     // Update the user's name in the app
            //   },
            //   child: const Text("Save"),
            // ),
          ],
        ),
      ),
    );
  }
}

Future<void> updateUserData(String userId, String name, String email,
    Map<String, dynamic> userData) async {
  try {
    final userRef = FirebaseFirestore.instance.collection('Users').doc();
    await userRef.update({
      'First name': name,
      'Email': email,
      ...userData, // Spread operator to add any other fields to update
    });
    print('User data updated successfully');
  } catch (e) {
    print('Error updating user data: $e');
    throw e;
  }
}
