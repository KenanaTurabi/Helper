import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin.dart';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  // bool isDark;
  // Function updateState;
  // Login(this.isDark, this.updateState);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> loginUser() async {
    //print('form login isDark=' + widget.isDark.toString());

    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.3:5000/login'), // Replace with your login endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if 'user' key exists in responseData
        if (responseData.containsKey('user')) {
          // Save userId in shared preferences
          await saveUserId(responseData['user']['userId']);
          await saveUserType(responseData['user']['userType']);

          final userType = await getUserType();
          if (userType == 'Admin') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      //    BottomNavigationBarExample(widget.isDark, widget.updateState)
                      BottomNavigationBarExample()),
            );
          }
        }
      } else if (response.statusCode == 404) {
        // User not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 401) {
        // Invalid password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid password'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error logging in: $error');
    }
  }

  Future<void> saveUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
  }

  Future<void> saveUserType(String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', userType);
  }

  @override
  Widget build(BuildContext context) {
    //print('form login isDark=' + widget.isDark.toString());

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 30.0), // Add padding top here
          child: Text(
            "Sign In",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color(0xff87bfff),
                fontSize: 20.0, // Change the size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
            color:
                Colors.black), // Change this color to your desired arrow color
        backgroundColor:
            Colors.white, // Change this color to your desired background color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 70.0), // Adjust the left padding as needed
              child: Text(
                "Please sign in to continue",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Color(
                                            0xff0E4C92), // Change the label text color here
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Color(0xff0E4C92),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(
                                                0xff0E4C92)), // Change the color as desired
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                      ),
                                      errorStyle: TextStyle(fontSize: 18.0),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(9.0)))))),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color(
                                      0xff0E4C92), // Change the label text color here
                                ),
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: Color(0xff0E4C92),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xff0E4C92),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                errorStyle: TextStyle(fontSize: 18.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(
                                          0xff0E4C92)), // Change the color as desired
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0))),
                              ),
                            ),
                          ),

                          Container(
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xff0E4C92), fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Center(
                            child: Container(
                              width: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  // Use ElevatedButton instead of FlatButton
                                  onPressed: () {
                                    loginUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(
                                        0xff87bfff), // Set the button's background color
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 40),
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
                          ),

                          // Center(
                          //   child: Padding(
                          //     padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          //     child: Center(
                          //       child: Text(
                          //         'Or Sign In with',
                          //         style: GoogleFonts.poppins(
                          //           textStyle: TextStyle(
                          //               fontSize: 16, color: Colors.black),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         20.0), // Add some space between the existing content and the new button

                          // Container(
                          //   width: size.height * 0.4,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(color: Colors.black),
                          //   ),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // Handle button tap
                          //       // Add your logic here
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             'assets/images/google-icon-2048x2048-czn3g8x8.png',
                          //             height:
                          //                 30.0, // Adjust the height as needed
                          //           ),
                          //           SizedBox(
                          //               width:
                          //                   10.0), // Add some space between the icon and text
                          //           Text(
                          //             'Google',
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16.0,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Padding(
                            padding: EdgeInsets.only(
                                top: 30.0), // Adjust the value as needed
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center horizontally
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Sign up',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff87bfff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
