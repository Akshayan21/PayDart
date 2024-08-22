// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_dart/UI_Screens/details_fetching_screen.dart';

class Institutions extends StatefulWidget {
  const Institutions({super.key});

  @override
  State<Institutions> createState() => _InstitutionsState();
}

class _InstitutionsState extends State<Institutions> {
  // Variable to track the index of the currently selected card
  int _selectedCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // List of institution names
    final List<String> institutionNames = [
      "Sri Shanmugha College of Engineering and Technology",
      "Sri Shanmugha College of Pharmacy",
      "Sri Shanmugha College of Nursing For Women",
      "Sri Shanmugha College of Engineering and Technology ",
      "Sri Shanmugha Institute of Medical Science and Research",
    ];

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 160),
              child: Text(
                "Select Institution",
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            // Generate cards dynamically
            Column(
              children: List.generate(institutionNames.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Update the selected card index
                      _selectedCardIndex = index;
                    });
                  },
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: _selectedCardIndex == index
                            ? Color.fromARGB(255, 245, 152, 22)
                            : Colors
                                .transparent, // Highlight only the selected card
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        institutionNames[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: screenHeight * 0.09),

            SizedBox(
              width: screenWidth * 0.5,
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
                          builder: (context) => const DetailsFetchingScreen()));
                },
                child: Text(
                  "Proceed",
                  style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
