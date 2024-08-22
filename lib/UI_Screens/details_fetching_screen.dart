// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsFetchingScreen extends StatefulWidget {
  const DetailsFetchingScreen({super.key});

  @override
  State<DetailsFetchingScreen> createState() => _DetailsFetchingScreenState();
}

class _DetailsFetchingScreenState extends State<DetailsFetchingScreen> {
  // Variable to hold the generated CAPTCHA
  String captchaCode = '';
  // Controller to capture user input for CAPTCHA
  final TextEditingController captchaController = TextEditingController();
  // Variable to show an error message if validation fails
  String errorMessage = '';
  // Variable to track if the CAPTCHA has been used
  bool isCaptchaUsed = false;

  @override
  void initState() {
    super.initState();
    // Generate the initial CAPTCHA when the screen loads
    captchaCode = generateCaptcha();
  }

  // Function to generate a random CAPTCHA
  String generateCaptcha() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  // Function to validate the CAPTCHA
  void validateCaptcha() {
    setState(() {
      if (isCaptchaUsed) {
        // If CAPTCHA has already been used
        errorMessage = 'This CAPTCHA has already been used. Please refresh.';
      } else if (captchaController.text == captchaCode) {
        // If CAPTCHA is correct and not used
        errorMessage = ''; // Clear any previous error messages
        isCaptchaUsed = true; // Mark the CAPTCHA as used
        print("CAPTCHA validation successful!");
        // You can navigate to another screen or perform other tasks here
      } else {
        // If CAPTCHA is incorrect
        errorMessage = 'Invalid CAPTCHA. Please try again.';
      }
    });
  }

  // Function to refresh the CAPTCHA
  void refreshCaptcha() {
    setState(() {
      if (!isCaptchaUsed) {
        // Generate a new CAPTCHA only if the current one is not used
        captchaCode = generateCaptcha();
        errorMessage = ''; // Clear any error message
      } else {
        errorMessage = 'The current CAPTCHA is already used. Please refresh the page.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 210),
              child: Text(
                "Fetch Details",
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Enter your SIN Number',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Container(
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.5,
                    color: Colors.amber,
                    alignment: Alignment.center,
                    child: Text(
                      captchaCode, // Display the generated CAPTCHA here
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                TextButton(
                  onPressed: refreshCaptcha, // Call the refresh function
                  child: Text(
                    "Refresh",
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 255, 78, 78),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 210),
              child: SizedBox(
                width: screenWidth * 0.5,
                child: TextField(
                  controller: captchaController, // Capture user input
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Enter Captcha',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            // Display an error message if CAPTCHA validation fails
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  errorMessage,
                  style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            SizedBox(
              width: screenWidth * 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 53, 156),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: validateCaptcha, // Validate CAPTCHA when clicked
                child: Text(
                  "Proceed",
                  style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
