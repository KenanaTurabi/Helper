import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatefulWidget {
  // bool isDark;
  // Function updateState;
  // Body(this.isDark, this.updateState);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    //print('form body isDark=' + widget.isDark.toString());

    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome to,",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 28.0, // Change the size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "CalmMind",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color(0xff87bfff),
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Image.asset(
            'assets/images/psychotherapy-session-7492714-6138991.webp', // Corrected asset path
            width: 350, // Adjust the width as needed
            height: 350, // Adjust the height as needed
          ),
          SizedBox(height: 30.0),
          Container(
            width: size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                // Use ElevatedButton instead of FlatButton
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Login();
                        // Login(widget.isDark, widget.updateState);
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color(0xff0E4C92), // Set the button's background color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                ),
                child: Text(
                  "Sign in",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                // Use ElevatedButton instead of FlatButton
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Signup();
                        //   Signup(widget.isDark, widget.updateState);
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color(0xff87bfff), // Set the button's background color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                ),
                child: Text(
                  "Create account",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
