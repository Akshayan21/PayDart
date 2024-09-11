// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:pay_dart/UI_Screens/Institutions.dart';
import 'package:pay_dart/UI_Screens/details_displaying_screen.dart';
import 'package:pay_dart/UI_Screens/details_fetching_screen.dart';
import 'package:pay_dart/UI_Screens/forget_password.dart';
import 'package:pay_dart/UI_Screens/login_screen.dart';
import 'package:pay_dart/UI_Screens/new_password_screen.dart';
import 'package:pay_dart/UI_Screens/otp_verification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 133, 248)),
        useMaterial3: true,
      ),
      home: DetailsFetchingScreen(),
    );
  }
}
