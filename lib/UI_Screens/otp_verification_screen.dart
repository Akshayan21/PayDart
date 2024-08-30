// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pay_dart/UI_Screens/new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 10, right: 200),
              child: Text(
                "Enter The OTP",
                style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.03, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                "Enter The OTP Which is sent To Your Registered Email Id",
                style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.02, fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            OtpTextField(
              fieldWidth: screenWidth * 0.15,
              fieldHeight: screenHeight * 0.2,
              keyboardType: TextInputType.number,
              numberOfFields: 4,
              borderColor: Color.fromARGB(255, 45, 133, 248),
              borderRadius: BorderRadius.circular(20.0),
              showFieldAsBox: true,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {},
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 45, 133, 248),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 45, 133, 248),
                    ),
                  )), // end onSubmit
            ),
            SizedBox(
              height: screenHeight * 0.02,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewPasswordScreen()));
                  },
                  child: Text("Verify OTP",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
