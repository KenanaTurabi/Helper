import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patientModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/widgets/patientFullDataWiddget.dart';

class Task {
  String name;
  String description;

  Task({required this.name, required this.description});

  // Add the fromJson constructor
  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'];
}

class DiagnosesPage extends StatefulWidget {
  Patient patient;
  bool isDark;
  Function updateState;

  DiagnosesPage(this.patient, this.isDark, this.updateState);

  @override
  _DiagnosesPageState createState() => _DiagnosesPageState();
}

class _DiagnosesPageState extends State<DiagnosesPage> {
  TextEditingController diagnosesController = TextEditingController();
  List<Task> tasks = [];
  bool isEditingDiagnoses = false;

  void updateTask(int index, String name, String description) {
    setState(() {
      tasks[index].name = name;
      tasks[index].description = description;
    });
  }

  // Function to fetch the treatment plan from the backend
  Future<void> fetchTreatmentPlan() async {
    final patientId = widget.patient.id; // Replace with the actual patient ID
    final url = 'http://192.168.1.3:5000/getTreatmentPlan/$patientId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          diagnosesController.text = data['diagnoses'] ?? '';
          tasks = List<Task>.from(
              data['tasks']?.map((x) => Task.fromJson(x)) ?? []);
        });
      } else {
        print(
            'Failed to fetch treatment plan. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during fetchTreatmentPlan: $error');
    }
  }

  // Function to save the data to the backend
  void saveData() async {
    final patientId = widget.patient.id; // Replace with the actual patient ID
    final diagnoses = diagnosesController.text;
    final taskNames = tasks.map((task) => task.name).toList();
    final taskDescriptions = tasks.map((task) => task.description).toList();

    final url = Uri.parse(
        'http://192.168.1.3:5000/saveTreatmentPlan'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'userId': patientId,
          'diagnoses': diagnoses,
          'tasks': tasks
              .map((task) =>
                  {'name': task.name, 'description': task.description})
              .toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Data saved successfully');
        Navigator.pop(context, true); // Navigate back to the previous screen

      } else {
        print('Failed to save data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTreatmentPlan(); // Fetch treatment plan when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnoses Page'),
      ),
      body: Padding(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diagnoses',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                isEditingDiagnoses = !isEditingDiagnoses;
                                if (!isEditingDiagnoses) {
                                  // Save or update the diagnoses here
                                  print(
                                      'Diagnoses updated: ${diagnosesController.text}');
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Add your delete action here
                              print('Delete Diagnoses');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  isEditingDiagnoses
                      ? TextFormField(
                          controller: diagnosesController,
                          decoration:
                              InputDecoration(labelText: 'Enter Diagnoses'),
                        )
                      : Text(
                          (diagnosesController.text.isNotEmpty
                              ? ' ${diagnosesController.text}'
                              : ''),
                        ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Treatment Plan Container
            Expanded(
              child: ListView(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        tasks.add(Task(
                            name: 'Task Name',
                            description: 'Task Description'));
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add Task',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff87bfff),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ...tasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final task = entry.value;
                    return TreatmentPlanContainer(
                      task: task,
                      onUpdate: (name, description) {
                        updateTask(index, name, description);
                      },
                    );
                  }).toList(),
                ],
              ),
            ),

            SizedBox(height: 30.0),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                  onPressed: () {
                    if (tasks.every((task) =>
                        task.name.isNotEmpty && task.description.isNotEmpty)) {
                      saveData();
                    } else {
                      print(
                          'Please provide names and descriptions for all tasks.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff87bfff),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TreatmentPlanContainer extends StatefulWidget {
  final Task task;
  final Function(String name, String description) onUpdate;

  TreatmentPlanContainer({required this.task, required this.onUpdate});

  @override
  _TreatmentPlanContainerState createState() => _TreatmentPlanContainerState();
}

class _TreatmentPlanContainerState extends State<TreatmentPlanContainer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEditingTask = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.task.name;
    descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
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
                'Task',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditingTask = !isEditingTask;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Add your delete action here
                      print('Delete Task');
                    },
                  ),
                ],
              ),
            ],
          ),
          isEditingTask
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      onChanged: (value) {
                        widget.task.name =
                            value; // Update the task name when editing
                      },
                      decoration: InputDecoration(labelText: 'Enter Task Name'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      onChanged: (value) {
                        widget.task.description =
                            value; // Update the task description when editing
                      },
                      decoration:
                          InputDecoration(labelText: 'Enter Task Description'),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${widget.task.name}'),
                    Text('Description: ${widget.task.description}'),
                  ],
                ),
        ],
      ),
    );
  }
}
