// import 'package:flutter/src/widgets/framework.dart';
// import 'package:main/Interfaces/register-page.dart';

// import '../Interfaces/login_page.dart';

// class LoginOrRegister extends StatefulWidget {
//   const LoginOrRegister({super.key});

//   @override
//   State<LoginOrRegister> createState() => _LoginOrRegister();
// }

// class _LoginOrRegister extends State<LoginOrRegister> {
//   //initially show welcome page
//   bool showLoginPage = true;

//   //toogle between welcome and login page
//   void togglePages() {
//     setState(() {
//       showLoginPage = !showLoginPage;
//     });
//   }
//   //toogle between login and register page

//   @override
//   Widget build(BuildContext context) {
//     if (showLoginPage) {
//       return LoginPage(
//         onTap: togglePages,
//       );
//     } else {
//       return RegisterView(
//         onTap: togglePages,
//       );
//     }
//   }
// }
