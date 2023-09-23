import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Saha_Yatri/Interfaces/searchRoutes.dart';

// FirebaseStorage storage = FirebaseStorage.instance;

// //access first name from database
// String? firstName = FirebaseFirestore.instance
//     .collection('Users')
//     .doc()
//     .get()
//     .then((doc) => doc.get('firstName')) as String?;

class DProfileScreen extends StatefulWidget {
  static final String path = "lib/screens/profile_screen.dart";

  @override
  State<DProfileScreen> createState() => _DProfileScreenState();
}

class _DProfileScreenState extends State<DProfileScreen> {
  String? uploadedPhotoUrl =
      'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

  void get_photo() async {
    var doc = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    if (doc.exists &&
        doc.data() != null &&
        doc.data()!.containsKey('photoUrl')) {
      setState(() {
        this.uploadedPhotoUrl = doc.get('photoUrl');
      });
    }
  }

  // final PhotoUploader _photoUploader = PhotoUploader();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_photo();
  }

  // void _capturePhotoAndUpload() async {
  //   final fileName = await _photoUploader.capturePhotoAndUploadToFirestore();
  // //   if (fileName != null) {
  // //     final url = await _photoUploader.getPhotoUrl(fileName);
  // //     setState(() {
  // //       uploadedPhotoUrl = url.toString();
  // //     });
  // //   }
  // // }

  // void _selectPhotoAndUpload() async {
  //   final fileName = await _photoUploader.selectPhotoAndUploadToFirestore();
  //   if (fileName != null) {
  //     final url = await _photoUploader.getPhotoUrl(fileName);
  //     setState(() {
  //       uploadedPhotoUrl = url.toString();
  //     });
  //   }
  // }

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
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                uploadedPhotoUrl ??
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // _selectPhotoAndUpload();

                                //push image url to database firebase in reference
                                // FirebaseFirestore.instance
                                //     .collection('Users')
                                //     .doc(user?.email)
                                //     .set({
                                //   'photoUrl': uploadedPhotoUrl,
                                // });
                                //snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Photo Updated'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "userName",
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
                              'user',
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
                  //padding

                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: const Text('Personal Information'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(),
                      ),
                    );
                  }),

              //sized box
              const SizedBox(
                height: 10,
              ),
              ListTile(
                  leading: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  title: const Text('Change Password'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ForgotPassword(),
                    //   ),
                    // );
                  }),

              const SizedBox(
                height: 10,
              ),
              const ListTile(
                leading: Icon(Icons.location_on, color: Colors.black),
                title: Text('Location'),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),

              const ListTile(
                leading: Icon(Icons.settings, color: Colors.black),
                title: Text('Settings'),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const ListTile(
                leading: Icon(Icons.help, color: Colors.black),
                title: Text('Help'),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const ListTile(
                leading: Icon(Icons.info, color: Colors.black),
                title: Text('About'),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  //firebase logout
                  // auth.signOut();

                  Navigator.pushReplacementNamed(context, '/welcome');
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Log out',
                    //red box
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
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
  TextEditingController busNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController busColorController = TextEditingController();
  TextEditingController busNumberController = TextEditingController();
  TextEditingController busCompanyController = TextEditingController();
  TextEditingController busCapacity = TextEditingController();
  String? selectedRoutes;
  final CollectionReference _driverRef =
      FirebaseFirestore.instance.collection('Drivers');

  List<dynamic> allRoutes = [];
  String? route;
  void checkDriver() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Route details').get();
    setState(() {
      querySnapshot.docs.map((doc) => allRoutes.add(doc.id)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getDriverData();
    checkDriver();
  }

  void getDriverData() async {
    try {
      // Retrieve the document containing the user's data
      DocumentSnapshot snapshot = await _driverRef
          .doc(user?.email)
          .get(); // Replace 'userId' with the actual user ID

      if (snapshot.exists) {
        // Get the data from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Set the data as hint text for the respective fields
        userNameController.text = data['First Name'] ?? '';
        lastNameController.text = data['Last Name'] ?? '';
        emailController.text = data['Email'] ?? '';
        phoneController.text = data['Phone Number'] ?? '';
        busColorController.text = data['Bus Color'] ?? '';
        busNumberController.text = data['Bus Number'] ?? '';
        busCompanyController.text = data['Bus Company'] ?? '';
        busCapacity.text = data['Bus Capacity']?.toString() ?? '';
        if (!mounted) return;
        setState(() {
          route = data['route'] ?? '';
        });
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
        title: const Text("Personal Information"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Driver",
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
              textfield(
                Controller: phoneController,
                hinttext: "Phone Number",
                labeltext: "Phone",
                icon: Icons.phone,
              ),
              textfield(
                Controller: busCompanyController,
                hinttext: "Bus Company",
                labeltext: "Bus Company",
                icon: Icons.train,
              ),
              textfield(
                Controller: busColorController,
                hinttext: "Bus Color",
                labeltext: "Bus Color",
                icon: Icons.train,
              ),
              textfield(
                Controller: busNumberController,
                hinttext: "Bus Number",
                labeltext: "Bus Number",
                icon: Icons.train,
              ),
              textfield(
                Controller: busCapacity,
                hinttext: "Bus Capacity",
                labeltext: "Bus Capacity",
                icon: Icons.train,
              ),
              const SizedBox(height: 5),
              Text("Your route: $route"),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select Your Route : ",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: selectedRoutes,
                    items: allRoutes.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoutes = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                  updateUserData(
                      user?.email,
                      userNameController.text,
                      phoneController.text,
                      busColorController.text,
                      busCompanyController.text,
                      busNumberController.text,
                      busCapacity.text,
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
    String phoneNumber,
    String busColor,
    String busCompany,
    String busNumber,
    String busCapacity,
    String lastName,
  ) async {
    if (selectedRoutes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your route")),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('Drivers')
          .doc(user?.email)
          .set({
            'Email': email,
            'First Name': firstName,
            'Last Name': lastName,
            'Phone Number': phoneNumber,
            'Bus Company': busCompany,
            'Bus Color': busColor,
            'Bus Number': busNumber,
            'isDriver': true,
            'Bus Capacity': busCapacity,
            'route': selectedRoutes,
          }, SetOptions(merge: true))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User updated")),
              ))
          .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User updated")),
              ));
    }
  }
}

class textfield extends StatefulWidget {
  textfield({
    Key? key,
    required TextEditingController Controller,
    required this.hinttext,
    required this.labeltext,
    this.icon,
    this.obscureText = false,
  })  : _Controller = Controller,
        super(key: key);

  final TextEditingController _Controller;
  final String hinttext;
  final bool obscureText;
  final String? labeltext;
  IconData? icon;

  @override
  _textfieldState createState() => _textfieldState();
}

class _textfieldState extends State<textfield> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  _obscureText = true;
                });
              },
              onTap: () {
                setState(() {
                  _obscureText = false;
                });
              },
              child: TextField(
                obscureText: _obscureText && widget.obscureText,
                decoration: InputDecoration(
                  prefixIcon: Icon(widget.icon),
                  hintText: widget.hinttext,
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w100,
                    color: Colors.grey,
                  ),
                  labelText: widget.labeltext,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                ),
                controller: widget._Controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
