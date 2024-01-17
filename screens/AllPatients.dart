// AllPatientsPage.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/PatientModel.dart';

class AllPatientsPage extends StatefulWidget {
  @override
  _AllPatientsPageState createState() => _AllPatientsPageState();
}

class _AllPatientsPageState extends State<AllPatientsPage> {
  List<Patient> patients = []; // Use PatientModel here

  Future<List<Patient>> getAllPatients() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.3:5000/patients'));

    if (response.statusCode == 200) {
      final List<dynamic> patientsJsonList =
          json.decode(response.body) as List<dynamic>;

      return patientsJsonList.map((item) => Patient.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPatients().then((retrievedPatients) {
      setState(() {
        patients = retrievedPatients;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: getAllPatients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No patients available.');
        } else {
          List<Patient> patientList = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Patient ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Mobile Number')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Image')),
              ],
              rows: patientList
                  .map((patient) => DataRow(
                        cells: [
                          DataCell(Text(patient.id.toString())),
                          DataCell(Text(patient.name ?? '')),
                          DataCell(
                              Text(patient.mobileNumber?.toString() ?? '')),
                          DataCell(Text(patient.city ?? '')),
                          DataCell(Text(patient.image ?? '')),
                        ],
                      ))
                  .toList(),
            ),
          );
        }
      },
    );
  }
}
