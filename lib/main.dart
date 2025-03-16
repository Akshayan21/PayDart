import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay_dart/UI_Screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
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

Future<void> requestStoragePermission() async {
  if (Platform.isAndroid) {
    // Check if storage permission is already granted
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return; // Permission already granted
    }

    // Request storage permission
    var result = await Permission.storage.request();
    if (!result.isGranted) {
      // If permission is denied, open app settings
      await openAppSettings();
    }
  }
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
