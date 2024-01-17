import 'package:flutter_application_1/screens/SessionsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/allDoctors.dart';
import 'package:flutter_application_1/screens/allPosts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/chatUsersModel.dart';
import 'package:flutter_application_1/widgets/conversationList.dart';
import 'package:flutter_application_1/screens/chatDetailPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/screens/detailScreen.dart';
import 'package:flutter_application_1/Event.dart';
import 'package:flutter_application_1/SecondScreen.dart';
import 'package:flutter_application_1/changeNotifier.dart';
import 'package:flutter_application_1/screens/QuestionsPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/validation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_application_1/widgets/RoomsList.dart';
import 'package:flutter_application_1/models/RoomsModel.dart';
import 'package:flutter_application_1/screens/SessionsPage.dart';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/screens/AddTreatmentPlan.dart';
import 'package:flutter_application_1/widgets/patientFullDataWiddget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/SessionsPage.dart';
import 'package:flutter_application_1/widgets/patientFullDataWiddget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/SessionsPage.dart';
import 'package:flutter_application_1/widgets/patientFullDataWiddget.dart';
import 'package:flutter_application_1/screens/moodtracking.dart';
import 'package:flutter_application_1/screens/MoodGraph.dart';

class TreatmentPlan extends StatefulWidget {
  bool isDark;
  Function updateState;

  TreatmentPlan(this.isDark, this.updateState);

  @override
  State<TreatmentPlan> createState() => _TreatmentPlanState();
}

class _TreatmentPlanState extends State<TreatmentPlan> {
  List<Task> tasks = [];
  String diagnosesText = 'No diagnoses';
  String name = 'no name';

  @override
  void initState() {
    super.initState();
    // Fetch treatment plan when the widget is initialized
    fetchTreatmentPlan();
  }

  Future<void> fetchTreatmentPlan() async {
    final int? userId = await getUserId();
    final url = 'http://192.168.1.3:5000/getTreatmentPlan/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(
            'Response data: $data'); // Add this line to print the data to the console

        setState(() {
          diagnosesText = data['treatmentPlan']['diagnoses'] ?? 'No diagnoses';
          tasks = List<Task>.from(
              data['treatmentPlan']['tasks']?.map((x) => Task.fromJson(x)) ??
                  []);
          name = data['patientName'] ?? 'No name';
        });
      } else {
        print(
            'Failed to fetch treatment plan. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during fetchTreatmentPlan: $error');
    }
  }

  Future<bool> hasEmojiForToday() async {
    final int? userId = await getUserId();
    final url = 'http://192.168.1.3:5000/hasEmojiForToday/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['hasEmojiForToday'] ?? false;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during fetch data: $error');
    }

    // Default to false in case of errors
    return false;
  }

  void navigateToMoodPage() {
    // Check if the user has an emoji for today
    hasEmojiForToday().then((hasEmoji) {
      if (hasEmoji) {
        // Navigate to MoodDiagramPage if the user has an emoji for today
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoodDiagramPage(),
          ),
        );
      } else {
        // Navigate to MoodSelectionPage if the user does not have an emoji for today
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoodSelectionPage(),
          ),
        );
      }
    });
  }

  Widget buildTaskContainer(Task task) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20),
              child: Text(
                'Welcome back, ' + name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:
                      navigateToMoodPage, // Use the navigateToMoodPage function

                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff87bfff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  ),
                  child: Text("Mood Tracking",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff0E4C92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  ),
                  child: Text("Upcoming Sessions",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),

            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Diagnoses',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              height: 2.0,
                              width:
                                  80.0, // Adjust the width of the line as needed
                              color: Color(0xff87bfff),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              diagnosesText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container for Tasks
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Treatment Plan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Colors.black, // Change text color to blue
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children:
                    tasks.map((task) => buildTaskContainer(task)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
