import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/SessionModel.dart';
import 'package:flutter_application_1/widgets/SessionsList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SessionsPage extends StatefulWidget {
  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    // Fetch sessions from the backend when the widget is initialized
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/sessions'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['sessions'];

        setState(() {
          sessions = data.map((sessionData) {
            return Session(
              doctorname: sessionData['doctorname'] ?? 'DefaultDoctorName',
              doctorimage: sessionData['doctorimage'] ?? 'DefaultDoctorImage',
              subject: sessionData['subject'] ?? 'DefaultSubject',
              Session_Date: DateTime.tryParse(sessionData['Session_Date']) ?? DateTime.now(),
              time: sessionData['time'] ?? '',
            );
          }).toList();
        });
      } else {
        print('Failed to load sessions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching sessions: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10, right: 20),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Card(
                  color: Color(0xff87bfff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(
                        'Thought of the day',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        '“Taking care of your mental health is an act of self-love.” “You are worthy of happiness and peace of mind.”',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Upcoming Sessions",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: sessions.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SessionsList(
                        doctorname: sessions[index].doctorname,
                        doctorimage: sessions[index].doctorimage,
                        time: sessions[index].time,
                        Session_Date: sessions[index].Session_Date,
                        subject: sessions[index].subject,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
