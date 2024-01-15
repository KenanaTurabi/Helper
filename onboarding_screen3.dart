import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/home.dart';

class OnboardingScreen3 extends StatefulWidget {
  // bool isDark;
  // Function updateState;
  // OnboardingScreen3(this.isDark, this.updateState);

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30.0),
            Image.asset(
              'assets/images/undraw_completed_tasks_vs6q (1).png', // Corrected asset path
              width: 400, // Adjust the width as needed
              height: 400, // Adjust the height as needed
            ),
            Text(
              'Ready to get started?',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 30.0, // Change the size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff87bfff), // Set the button's background color
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              ),
              onPressed: () {
                BottomNavigationBarExample.navigatorKey.currentState
                    ?.rebuildWidget();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavigationBarExample()
                      //  BottomNavigationBarExample(widget.isDark, widget.updateState)
                      ),
                );
              },
              child: Text(
                'Get Started',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15.0, // Change the size as needed
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
