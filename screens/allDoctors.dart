import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/doctorModel.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/widgets/doctorWidget.dart';

class AllDoctors extends StatefulWidget {
  bool isDark;
  Function updateState;
  AllDoctors(this.isDark, this.updateState);

  @override
  State<AllDoctors> createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  List<Doctor> doctors = []; // Add a list to store doctors

  @override
  void initState() {
    super.initState();
    _fetchDoctors(); // Fetch doctors when the widget initializes
  }

  Future<void> _fetchDoctors() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.3:5000/Doctors'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;

      setState(() {
        doctors = data.map((item) => Doctor.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    // CustomeAppBar customeAppBar =
    //     new CustomeAppBar(widget.isDark, widget.updateState);

    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(60),
        //   child: customeAppBar,
        // ),

        // TODO: implement build
        body: ListView(
      children: doctors
          .map((doctor) =>
              DoctorWidget(doctor, widget.isDark, widget.updateState))
          .toList(),
    ));
  }
}
