// // ignore_for_file: prefer_const_constructors, unused_import
//
// import 'package:flutter/material.dart';
// import 'package:pay_dart/UI_Screens/login_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 133, 248)),
//         useMaterial3: true,
//       ),
//       home: LoginScreen(),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:pay_dart/UI_Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI_Screens/details_displaying_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(MyApp(
    initialScreen: token != null ? DetailsDisplayingScreen() : LoginScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 133, 248)),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Text("Welcome! You are logged in."),
      ),
    );
  }
}
