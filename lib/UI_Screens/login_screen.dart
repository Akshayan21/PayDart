//
// import "package:flutter/material.dart";
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pay_dart/UI_Screens/Institutions.dart';
// import 'package:pay_dart/UI_Screens/forget_password.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _obscureText = true;
//
//   void _toggleVisibility() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 50),
//               child: Center(
//                 child: Image.asset("assets/Logo_Main.png",
//                     width: screenWidth * 0.5, height: screenHeight * 0.2),
//               ),
//             ),
//             SizedBox(
//               height: screenHeight * 0.03,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 125, left: 10),
//               child: Text("Hey There!\nLogin To Continue",
//                   style: GoogleFonts.poppins(
//                       fontSize: 30, fontWeight: FontWeight.w500)),
//             ),
//             SizedBox(
//               height: screenHeight * 0.05,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   labelText: 'Username',
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: screenHeight * 0.05,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: TextField(
//                 obscureText: _obscureText,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   labelText: 'Password',
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility_off : Icons.visibility,
//                     ),
//                     onPressed: _toggleVisibility,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: screenHeight * 0.01,
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(left: 220.0),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ForgetPassword()),
//                   );
//                   },
//                   child: Text(
//                     "Forget Password?",
//                     style: GoogleFonts.poppins(
//                         fontSize: 15, fontWeight: FontWeight.w400),
//                   ),
//                 )),
//             SizedBox(
//               height: screenHeight * 0.03,
//             ),
//             SizedBox(
//               width: screenWidth * 0.6,
//               height: screenHeight * 0.06,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 15, 53, 156),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 onPressed: () async{
//                   // await http.post("http://localhost:3000/auth/login"),{
//                   //   email:
//                   // }
//                 },
//                 child: Text("Login",
//                     style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500)),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.09),
//             SizedBox(
//               width: screenWidth * 0.8,
//               height: screenHeight * 0.06,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 245, 152, 22),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const Institutions()),
//                   );
//                 },
//                 child: Text("Pay Fees",
//                     style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: screenHeight * 0.02,
//                         fontWeight: FontWeight.w500)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details_displaying_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    final url = Uri.parse("http://10.0.2.2:3000/auth/login");
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError("Please fill in both fields.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "esimno": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save token and username to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', responseData['token']);
        await prefs.setString('username', responseData['user']['esimno']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DetailsDisplayingScreen()),
        );
      } else {
        _showError("Invalid username or password.");
      }
    } catch (e) {
      _showError("Failed to login. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
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
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: const EdgeInsets.only(right: 125, left: 10),
              child: Text(
                "Hey There!\nLogin To Continue",
                style: GoogleFonts.poppins(
                    fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Username',
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: screenWidth * 0.6,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 53, 156),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
