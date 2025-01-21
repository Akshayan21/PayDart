import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_plus/date_picker_plus.dart'; // Import the date_picker_plus package
import 'package:intl/intl.dart'; // For date formatting

class AdmissionSeatSelection extends StatefulWidget {
  const AdmissionSeatSelection({super.key});

  @override
  State<AdmissionSeatSelection> createState() => _AdmissionSeatSelectionState();
}

class _AdmissionSeatSelectionState extends State<AdmissionSeatSelection> {
  // Form variables
  String? departement;
  String? referal;
  String? quota;
  TextEditingController dobController = TextEditingController();

  final List<String> quotaOptions = [
    'Govermant Quota',
    'Management Quota',
  ];

  // Dropdown options
  final List<String> departementOptions = [
    'B.Tech - IT',
    'B.Tech - AI&DS',
    'B.E - ECE',
    "B.E - BME",
    "B.Tech - AE",
    "B.E - CSE",
    "B.E - ME",
    "M.E - CSE",
    "B.E - Cyber Security",
    "M.E - ISE",
  ];
  final List<String> referalOptions = [
    "Direct",
    "Faculty",
    "Student",
    "Consultant",
    "Other",
  ];

  // Method to show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePickerDialog(
      context: context,
      minDate: DateTime(1900), // Start date for the picker
      maxDate: DateTime.now(), // End date for the picker (current date)
      initialDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  // Reusable method for generating form fields
  Widget buildTextField({
    required String label,
    required String hintText,
    required TextInputType inputType,
    TextEditingController? controller,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    double? fontSize,
    double? fieldHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: fieldHeight,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon),
                      onPressed: onSuffixTap,
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Reusable method for dropdown fields
  Widget buildDropdownField({
    required String label,
    required List<String> options,
    String? selectedValue,
    String hintText = "Select an option",
    ValueChanged<String?>? onChanged,
    double? fontSize,
    double? fieldHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: fieldHeight,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            hint: Text(hintText),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: onChanged,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double baseHeight =
        screenHeight / 720; // Base height for responsive scaling
    double fontSize = screenHeight * 0.02; // Responsive font size

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Seat",
              style: GoogleFonts.poppins(
                fontSize: fontSize * 1.5, // Adjust title size
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16 * baseHeight),

            buildDropdownField(
              label: "Select Departement",
              options: departementOptions,
              selectedValue: departement,
              onChanged: (newValue) => setState(() => departement = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            buildTextField(
              label: "Date Of Visited",
              hintText: "Enter  D.O.V",
              inputType: TextInputType.none,
              controller: dobController,
              readOnly: true,
              suffixIcon: Icons.calendar_today,
              onSuffixTap: () => _selectDate(context),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            buildDropdownField(
              label: "Referal",
              options: referalOptions,
              selectedValue: referal,
              onChanged: (newValue) => setState(() => referal = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Name field
            buildTextField(
              label: "Form Filled By ",
              hintText: "Enter the Name Who Filled the Form ",
              inputType: TextInputType.name,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            buildDropdownField(
              label: "Quota",
              options: quotaOptions,
              selectedValue: quota,
              onChanged: (newValue) => setState(() => quota = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 53, 156),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () {
                  // Handle button press
                },
                child: Text(
                  "Submit",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: fontSize * 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16 * baseHeight),
          ],
        ),
      ),
    );
  }
}
