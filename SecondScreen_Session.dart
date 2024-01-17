import 'package:flutter/material.dart';
import 'package:flutter_application_1/Event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/home.dart';

class SecondScreen_Session extends StatefulWidget {
  bool isDark;
  Function updateState;
  final DateTime selectedDate;
  final List<String> availableTimes;
  final String? selectedMeetingType;

  SecondScreen_Session({
    required this.isDark,
    required this.updateState,
    required this.selectedDate,
    required this.availableTimes,
    this.selectedMeetingType,
  });

  @override
  _SecondScreen_SessionState createState() => _SecondScreen_SessionState();
}

class _SecondScreen_SessionState extends State<SecondScreen_Session> {
  final TextEditingController titleController = TextEditingController();
  String? selectedTime;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> createSession() async {
    try {
      final int? userId = await getUserId(); //patientId

      final int? specialistId = userId; // Replace with the actual specialistId

      final String subject = titleController.text;
      final String time = selectedTime ?? '';
      final String formattedDate = DateFormat("yyyy-MM-dd'T'00:00:00.000+00:00")
          .format(widget.selectedDate);

      final Map<String, dynamic> sessionData = {
        'specialistId': specialistId,
        'subject': subject,
        'time': time,
        'Session_Date': formattedDate,
      };

      final response = await http.post(
        Uri.parse(
            'http://192.168.1.3:5000/create-session'), // Replace with your backend endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(sessionData),
      );

      if (response.statusCode == 201) {
        // Session created successfully
        print('Session created successfully');
        // Optionally, you can navigate to another screen or show a success message.
      } else {
        // Handle other status codes or errors
        print('Failed to create session');
      }
    } catch (error) {
      print('Error creating session: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Session'), // Change the title
        backgroundColor: Color(0xff0E4C92),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Create Session', // Change the text
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Textfield for entering event title
            buildTextField(
              controller: titleController,
              hint: 'Enter Event Title',
            ),
            SizedBox(height: 20.0),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Time',
                border: OutlineInputBorder(),
              ),
              value: selectedTime,
              onChanged: (String? value) {
                setState(() {
                  selectedTime = value;
                });
              },
              items: widget.availableTimes.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff87bfff),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              ),
              onPressed: () {
                createSession(); // Changed function name

                Navigator.pop(context, true);
              },
              child: Text('Create Session'), // Changed button text
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller, String? hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint ?? '',
        border: OutlineInputBorder(),
      ),
    );
  }
}
