// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _obscureText = true;
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Image.asset("assets/Logo_Main.png",
                  width: screenWidth * 0.5, height: screenHeight * 0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90, left: 10, right: 150),
            child: Text(
              "Set New Password",
              style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.03, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleVisibility,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Reconfirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleVisibility,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Center(
            child: SizedBox(
              width: screenWidth * 0.6,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 53, 156),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const NewPasswordScreen()));
                },
                child: Text("Change Password",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: screenHeight * 0.023,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
        ],
      ),
    ));
  }
}
