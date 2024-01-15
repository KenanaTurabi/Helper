import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/patientModel.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:flutter_application_1/widgets/patientWidget.dart';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;

class MyPatients extends StatefulWidget {
  bool isDark;
  Function updateState;
  MyPatients(this.isDark, this.updateState);

  @override
  State<MyPatients> createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {
  List<Patient> patients = []; // Add a list to store doctors

 @override
  void initState() {
    super.initState();
    _fetchPatients(); // Fetch doctors when the widget initializes
  }
    Future<void> _fetchPatients() async {
    try {
      // Fetch specialist ID from SharedPreferences
    final int? specialistId = await getUserId();

      // Make an HTTP request to fetch patients based on the specialist ID
      final response = await http.get(
        Uri.parse('http://localhost:5000/patientsBySpecialist/$specialistId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        setState(() {
          patients = data.map((item) => Patient.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (error) {
      print('Error fetching patients: $error');
    }
  }

 
  @override
  Widget build(BuildContext context) {
    CustomeAppBar customeAppBar =
        new CustomeAppBar(widget.isDark, widget.updateState);

    return Scaffold(
        appBar: AppBar(
                  title: Text('Patient imformation'),

           leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {

           Navigator.pop(context); // Navigate back to the previous screen

                
  
      },
        ),
        ),

        // TODO: implement build
        body: ListView(
      children: patients
          .map((patient) =>
             PatientWidget(patient, widget.isDark, widget.updateState))
          .toList(),
    ));
  }
}
