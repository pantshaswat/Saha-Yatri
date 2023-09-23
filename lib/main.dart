import 'package:flutter/material.dart';
import 'package:Saha_Yatri/Components/auth-page.dart';
import 'package:Saha_Yatri/Components/verifyOrhome.dart';
import 'package:Saha_Yatri/Interfaces/driversRegister.dart';
import 'package:Saha_Yatri/Interfaces/fare.dart';
import 'package:Saha_Yatri/Interfaces/register-page.dart';
import 'package:Saha_Yatri/Interfaces/routeCalculator.dart';
import 'package:Saha_Yatri/Interfaces/searchRoutes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'consts/Routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await getRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/verifyOrHome': (context) => const VerifyOrHome(),
      },
    );
  }
}
