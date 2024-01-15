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



  class RoomPage extends StatelessWidget {
    List<Room> Rooms = [
    Room(name: "Depression", doctorname: "Philip Fox"),
    Room(name: "PTSD", doctorname: "Jacob Pena"),
    Room(name: "Anxiety", doctorname: "Debra Hawkins"),
    Room(name: "Schizophrenia", doctorname: "Andrey Jones"),
    Room(name: "Eating Disorder", doctorname: "Glady's Murphy"),
    Room(name: "Bipolar Disorder", doctorname: "Jane Russel"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey
          .shade100, // Set the background color of the entire page to white
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Rooms",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    //add new room
                    // Container(
                    //   padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                    //   height: 30,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Color(0xffd2e6fd),
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(Icons.add, color: Color(0xff0E4C92), size: 20),
                    //       SizedBox(width: 2),
                    //       Text(
                    //         "Add New",
                    //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            // Add your ListView.builder here
            ListView.builder(
              itemCount: Rooms.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return RoomsList(
                  name: Rooms[index].name,
                  doctorname: Rooms[index].doctorname,
                );
              },
            ),
          ],
        ),
      ),
    );
    }
    }