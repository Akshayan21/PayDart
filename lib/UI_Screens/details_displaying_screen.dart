// ignore_for_file: unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsDisplayingScreen extends StatefulWidget {
  const DetailsDisplayingScreen({super.key});

  @override
  State<DetailsDisplayingScreen> createState() =>
      _DetailsDisplayingScreenState();
}

class _DetailsDisplayingScreenState extends State<DetailsDisplayingScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, left: 20.0, right: 300.0),
              child: Text(
                "Details",
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: screenHeight * 0.55,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 216, 216, 216),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Row(
              
            )
          ],
        ),
      ),
    );
  }
}
