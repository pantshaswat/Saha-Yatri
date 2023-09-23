import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Saha_Yatri/Interfaces/about_us.dart';
import 'package:Saha_Yatri/Interfaces/fare.dart';
import 'package:Saha_Yatri/Interfaces/forgotPass.dart';
import 'package:Saha_Yatri/Interfaces/help_page.dart';
import 'package:Saha_Yatri/Interfaces/searchRoutes.dart';
import 'package:Saha_Yatri/drivers/Dprofile.dart';
import 'package:Saha_Yatri/users/uProfile.dart';

class NavigationDrawerDemo extends StatefulWidget {
  bool isDriver;
  NavigationDrawerDemo({Key? key, required this.isDriver}) : super(key: key);

  @override
  State<NavigationDrawerDemo> createState() => _NavigationDrawerDemoState();
}

class _NavigationDrawerDemoState extends State<NavigationDrawerDemo> {
  logUserOut() {
    FirebaseAuth.instance.signOut();
  }

//for user

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.isDriver == true ? "Driver" : "Passenger"),
            decoration: BoxDecoration(color: Colors.black),
            accountEmail: Text(
                //email
                user.email!),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.person,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              print(isDriver);
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => PersonalInfoPage(),
              //     ));
              // Implement your home logic here
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: const Text('Personal Information'),
            onTap: () {
              Navigator.pop(context);
              if (widget.isDriver) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInfoPage(),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => userInfoPage(),
                    ));
              }
              // Implement your personal information logic here
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => forgotPass(),
                  ));
              // Implement your change password logic here
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.attach_money_rounded),
            title: const Text('Fare Calculator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => myFare(),
                  ));
              // Implement your change password logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(),
                  ));
              // Implement your about logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpPage(),
                  ));
              // Implement your about logic here
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              logUserOut();
              // Implement your logout logic here
            },
          ),
        ],
      ),
    );
  }
}
