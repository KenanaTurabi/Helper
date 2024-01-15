import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/Event.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class detail_session extends StatelessWidget {
  final String eventTitle;
  final DateTime eventDate;
  final Doctor? doctor;
  final String? availableTime;
  final String? meetingType;

  detail_session({
    required this.eventTitle,
    required this.eventDate,
    required this.doctor,
    required this.availableTime,
    required this.meetingType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Details'),
        backgroundColor: Color(0xff0E4C92),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ... Widget tree for displaying event details
          Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 5, right: 12, left: 12),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              children: [
                // ... Widget tree for displaying event details
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '$eventTitle',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 5, right: 12, left: 2),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center contents horizontally
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center contents horizontally
                        children: [
                          if (doctor != null)
                            Container(
                              child: CircleAvatar(
                                backgroundImage: doctor?.image != null
                                    ? AssetImage(
                                        'assets/images/${doctor!.image}')
                                    : AssetImage(
                                        'assets/images/download.png'), // Replace 'assets/default_image.jpg' with your default image path
                                maxRadius: 40,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 5, right: 12, left: 2),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center contents horizontally
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center contents horizontally
                        children: [
                          if (doctor != null)
                            Text(
                              ' ${doctor?.name ?? 'No Doctor Selected'}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0, // Change the size as needed
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
 
                //---------------------------------------------------------
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center contents horizontally
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center contents horizontally
                        children: [
                          if (meetingType != null)
                            Text(
                              ' ${meetingType ?? 'No meeting type Selected'}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0, // Change the size as needed
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 5, right: 12, left: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 30, // Adjust the size as needed

                          color: Color(0xff87bfff),
                        ),
                        SizedBox(width: 8), // Add a SizedBox to create space

                        Text(
                          ' ${DateFormat('yyyy-MM-dd').format(eventDate)}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.0, // Change the size as needed
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 30,
                          color: Color(0xff87bfff),
                        ),
                        SizedBox(width: 8), // Add a SizedBox to create space

                        Text(
                          '$availableTime',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.0, // Change the size as needed
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 5, right: 12, left: 12),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      // Cancel button styling
                      onPressed: () {},
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                    OutlinedButton(
                      // Join button styling
                      onPressed: () {},
                      child: Text(
                        'Join',
                        style:
                            TextStyle(color: Color(0xff87bfff), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
