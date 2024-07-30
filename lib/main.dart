// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pay_dart/UI_Screens/Dashboard.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 133, 248)),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}
