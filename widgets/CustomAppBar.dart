// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomeAppBar extends StatefulWidget {
  bool isDark;
  Function updateState;
  CustomeAppBar(this.isDark, this.updateState);

  @override
  State<CustomeAppBar> createState() => _CustomeAppBarState();
}

class _CustomeAppBarState extends State<CustomeAppBar> {
  @override
  Widget build(BuildContext context) {
    print('form customeAppBar isDark=' + widget.isDark.toString());
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(300, 0, 0, 0),
              child: Text("CalmMind")),
          CupertinoSwitch(
            value: widget.isDark,
            onChanged: (newValue) {
              widget.updateState(newValue);
            },
            activeColor: Colors.blue, // Set the color when switch is ON
            trackColor: Colors.grey, // Set the color of the switch track
          )
        ],
      ),
      backgroundColor: Color(0xff0E4C92),
    );
  }
}
