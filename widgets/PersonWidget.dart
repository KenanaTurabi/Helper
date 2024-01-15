import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Person.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;

class PersonWidget extends StatefulWidget {
  Person person;
  bool isDark;
  Function updateState;
  PersonWidget(this.person, this.isDark, this.updateState);
  @override
  State<PersonWidget> createState() => _PersonWidgetState();
}

class _PersonWidgetState extends State<PersonWidget> {
  void updateState(bool newValue) {
    setState(() {
      widget.isDark = newValue;
      print(widget.isDark);
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchUserData(widget.userId); // Fetch user when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    print('from personWIdget isDark =' + widget.isDark.toString());
    CustomeAppBar customeAppBar = new CustomeAppBar(widget.isDark, updateState);

    if (widget.person == null) {
      return Container(); // Return an empty container if person is null
    }

    // TODO: implement build
    return Theme(
      data: widget.isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: PreferredSize(
          child: customeAppBar,
          preferredSize: Size.fromHeight(60),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(children: [
              Container(
                padding: EdgeInsets.all(10),
                width: 300,
                height: 300,
                child: widget.person.photo != null
                    ? Image(
                        image: NetworkImage(widget.person.photo!),
                        fit: BoxFit.cover,
                      )
                    : Placeholder(), // Replace with a placeholder widget
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    widget.person.name ?? '', // Use the null-aware operator
                    style: TextStyle(
                      color: Color(0xff0E4C92),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff0E4C92),
                    ),
                  ),
                  Text(
                    "id: " +
                        (widget.person.id?.toString() ??
                            ''), // Use the null-aware operator
                    style: TextStyle(color: Color(0xff0E4C92)),
                  )
                ],
              ),
            ]),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "gender: " +
                            (widget.person.gender ??
                                ''), // Use the null-aware operator
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "mobile number: " +
                            (widget.person.mobileNumber?.toString() ??
                                ''), // Use the null-aware operator
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Full address: " +
                            (widget.person.FullAddress ??
                                ''), // Use the null-aware operator
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "age: " +
                            (widget.person.age?.toString() ??
                                ''), // Use the null-aware operator
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
