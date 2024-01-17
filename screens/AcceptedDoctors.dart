import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/doctorModel.dart';
import 'package:http/http.dart' as http;

class AcceptedDoctorsPage extends StatefulWidget {
  @override
  _AcceptedDoctorsPageState createState() => _AcceptedDoctorsPageState();
}

class _AcceptedDoctorsPageState extends State<AcceptedDoctorsPage> {
  Future<List<Doctor>> getAcceptedDoctors() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.3:5000/doctors'));

    if (response.statusCode == 200) {
      final List<dynamic> doctorsJsonList =
          json.decode(response.body) as List<dynamic>;

      return doctorsJsonList
          .map((item) => Doctor.fromJson(item))
          .where((doctor) => !doctor.isPending!)
          .toList();
    } else {
      throw Exception('Failed to load accepted doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: getAcceptedDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No accepted doctors available.');
        } else {
          List<Doctor> doctorList = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Delete')),
                DataColumn(label: Text('Doctor ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Mobile Number')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Image')),
              ],
              rows: doctorList
                  .map((doctor) => DataRow(
                        cells: [
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                // Add logic to delete the doctor
                                deleteDoctor(doctor.id!);
                              },
                            ),
                          ),
                          DataCell(Text(doctor.id.toString())),
                          DataCell(Text(doctor.name ?? '')),
                          DataCell(Text(doctor.mobileNumber?.toString() ?? '')),
                          DataCell(Text(doctor.city ?? '')),
                          DataCell(Text(doctor.image ?? '')),
                        ],
                      ))
                  .toList(),
            ),
          );
        }
      },
    );
  }

  Future<void> deleteDoctor(int doctorId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.3:5000/doctors/$doctorId'),
      );

      if (response.statusCode == 200) {
        // Handle successful deletion
        print('Doctor deleted successfully');

        // Trigger a rebuild to refresh the page
        setState(() {});
      } else {
        throw Exception('Failed to delete doctor');
      }
    } catch (e) {
      print('Error: $e');
      // Handle other errors as needed
    }
  }
}
