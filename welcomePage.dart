import 'package:flutter/material.dart';
import 'package:flutter_application_1/body.dart';

class WelcomeScreen extends StatefulWidget {
  //bool isDark;
  //Function updateState;
  //WelcomeScreen(this.isDark, this.updateState);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // print('form welcome screen isDark=' + widget.isDark.toString());

    return Scaffold(
      body: Body(),
      // Body(widget.isDark, widget.updateState),
    );
  }
}
