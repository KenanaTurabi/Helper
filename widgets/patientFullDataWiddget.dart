import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:flutter_application_1/screens/AddTreatmentPlan.dart';
import 'package:flutter_application_1/screens/MyPatients.dart';

import '../models/patientModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class patientFullDataWiddget extends StatefulWidget {
  Patient patient;
  bool isDark;
  Function updateState;
  patientFullDataWiddget(this.patient, this.isDark, this.updateState);

  @override
  State<patientFullDataWiddget> createState() => _patientFullDataWiddgetState();
}

class _patientFullDataWiddgetState extends State<patientFullDataWiddget> {
  List<Task> tasks = [];
  String diagnosesText = 'No diagnoses';

  void updateState(bool newValue) {
    setState(() {
      widget.isDark = newValue;
      print(widget.isDark);
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch treatment plan when the widget is initialized
    fetchTreatmentPlan();
  }

  Future<void> fetchTreatmentPlan() async {
    final url = 'http://192.168.1.3:5000/getTreatmentPlan/${widget.patient.id}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the response body and update the state with the diagnoses and tasks
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          diagnosesText = data['diagnoses'] ?? 'No diagnoses';
          tasks = List<Task>.from(
              data['tasks']?.map((x) => Task.fromJson(x)) ?? []);
        });
      } else {
        // Handle error cases here
        print(
            'Failed to fetch treatment plan. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error during fetchTreatmentPlan: $error');
      print(widget.patient.id);
    }
  }

  void _navigateTo() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DiagnosesPage(widget.patient, widget.isDark, widget.updateState),
      ),
    );
    if (result != null && result) {
      fetchTreatmentPlan();
    }
  }

  Widget buildTaskContainer(Task task) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(task.description),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('from doctorFullData isDark =' + widget.isDark.toString());
    CustomeAppBar customeAppBar = new CustomeAppBar(widget.isDark, updateState);
    // TODO: implement build

    return Theme(
      data: widget.isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Patient imformation'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30),
            // color: Colors.grey.shade100,
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400,
                        child: Image(
                          image: AssetImage(
                              'assets/images/${widget.patient.image}'),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.patient.name ?? "No Name",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(14.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Text(
                                      "Mobile Number ",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(widget.patient.mobileNumber
                                        .toString()!),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      "Country ",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(widget.patient.city!),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Treatment Plan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 14, // Change left to right
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            _navigateTo();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Color(0xff87bfff),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
// Diagnoses Container
                              Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Diagnoses',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(diagnosesText),
                                  ],
                                ),
                              ),

// Container for Tasks
                              Padding(
                                padding: EdgeInsets.only(top: 12.0, left: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tasks',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: tasks
                                      .map((task) => buildTaskContainer(task))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
