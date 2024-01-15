import 'package:flutter/material.dart';
import 'package:flutter_application_1/Event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/home.dart';


class SecondScreen extends StatefulWidget {
  bool isDark;
  Function updateState;
  final DateTime selectedDate;
  final List<String> availableTimes;
  final String? selectedMeetingType; // Add the selectedMeetingType parameter

  SecondScreen({
    required this.isDark, 
   required  this.updateState,
    required this.selectedDate,
    required this.availableTimes,
    this.selectedMeetingType,
    // Add this line to the constructor
  });

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descpController = TextEditingController();
  String? selectedTime;
  String? selectedMeetingType; // New variable to store the selected meeting type
 String currentWorkPlace="";

  @override
  void dispose() {
    titleController.dispose();
    descpController.dispose();
    super.dispose();
  }

  late Doctor? selectedDoctor = null; // Provide a default value
  late List<Doctor> specialists =
      []; // Use Doctor type for the specialists list

  @override
  void initState() {
    super.initState();
    fetchSpecialists();
  }

  Future<void> fetchSpecialists() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/specialists'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['specialists'];
        setState(() {
          // Convert Map<String, dynamic> to Doctor objects
          specialists = data.map((specialist) {
            final int specialistId = specialist['id'];
            return Doctor(
              name: specialist['name'],
              image: specialist['image'],
              specialistId: specialistId,
              currentworkingplace:specialist['CurrentWorkPlace'],
       

               // Make sure you have a userId property in your Doctor class
            );
          }).toList();
        });
      } else {
        print('Failed to load specialists');
      }
    } catch (error) {
      print('Error fetching specialists: $error');
    }
  }

  Future<void> bookAppointment() async {
    try {
      final int? userId = await getUserId(); //patientId
  final formattedDate =
        DateFormat("yyyy-MM-dd'T'00:00:00.000+00:00").format(widget.selectedDate);

      final response = await http.post(
        Uri.parse(
            'http://localhost:5000/appointments'), // Replace with your endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'patientId': userId, // Replace with the actual userId of the patient
          'specialistId': selectedDoctor
              ?.specialistId, // Replace with the actual userId of the specialist
          'meetingType': selectedMeetingType,
          'doctor': {
            'name': selectedDoctor?.name ?? '',
            'image': selectedDoctor?.image ?? '',
          },
          'eventTitle': 'Appointment', // Replace with the actual eventTitle
          'availableTimes':
              selectedTime ?? '', // Replace with the actual availableTimes
          'eventDate': formattedDate,
        }),
      );

      if (response.statusCode == 201) {
        // Appointment created successfully
        print('Appointment created successfully');
        // Optionally, you can navigate to another screen or show a success message.
      } else {
        // Handle other status codes or errors
        print('Failed to create appointment');
      }
    } catch (error) {
      print('Error creating appointment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
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
                    text: 'Book Appointment',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // buildTextField(controller: titleController, hint: 'Enter Title'),
            // SizedBox(height: 20.0),

            // Radio buttons for selecting meeting type
            Row(
              children: [
                Radio(
                  value: 'In-Clinic',
                  groupValue: selectedMeetingType,
                  onChanged: (String? value) {
                    setState(() {
                      selectedMeetingType = value;
                    });
                  },
                ),
                Text('In-Clinic'),
                SizedBox(width: 20.0),
                Radio(
                  value: 'Online Meeting',
                  groupValue: selectedMeetingType,
                  onChanged: (String? value) {
                    setState(() {
                      selectedMeetingType = value;
                    });
                  },
                ),
                Text('Online Meeting'),
              ],
            ),
            SizedBox(height: 30.0),

// Define a variable to hold the height of the selected doctor field
 Column(
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Select Doctor',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: Container(
                height: 50.0, // Set the height for the dropdown button
                child: DropdownButton<Doctor>(
                  value: selectedDoctor,
                  onChanged: (Doctor? value) {
                    setState(() {
                      selectedDoctor = value;
                    });
                  },
                          hint: Text('Select a Doctor'), // Set the initial text here

                  itemHeight: 80,
                  items: specialists.map((Doctor doctor) {
                    return DropdownMenuItem<Doctor>(
                      value: doctor,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/${doctor.image}'),
                                maxRadius: 20,
                              ),
                              SizedBox(width: 8.0),
                              Text(doctor.name),
                            ],
                          ),
                          // Display currentWorkPlace only in the dropdown list
                          if (selectedDoctor == null || selectedDoctor != doctor)
                            Row(
                              children: [
                                Text(doctor.currentworkingplace??''),
                              ],
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
                  SizedBox(height: 20.0),

 Column(
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Select Time',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: Container(
                height: 50.0, // Set the height for the dropdown button
                child: DropdownButton<String>(
                  value: selectedTime,
              onChanged: (String? value) {
                setState(() {
                  selectedTime = value;
                });
              },
                          hint: Text('Select Time'), // Set the initial text here

                  itemHeight: 80,
               items: widget.availableTimes.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
              ),
            ),
          ),
        ],
      ),
          
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff87bfff),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              ),
              onPressed: () {
             
                bookAppointment();


               Navigator.pop(context, true);
              },
              child: Text('Book Now'),
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
