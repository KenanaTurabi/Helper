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
import 'package:flutter_application_1/screens/detailScreen_specialist.dart';
import 'package:flutter_application_1/screens/detail_session.dart';

import 'package:flutter_application_1/Event.dart';
import 'package:flutter_application_1/SecondScreen_Session.dart';
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

class CalendarPage_specialist extends StatefulWidget {
  final bool isDark;
  final Function updateState;
  List<Event> loadedAppointments = [];
  List<Event> loadedSessions = [];

  CalendarPage_specialist({required this.isDark, required this.updateState});

  @override
  State<CalendarPage_specialist> createState() =>
      _CalendarPage_specialistState();
}

class _CalendarPage_specialistState extends State<CalendarPage_specialist> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedCalendarDate = DateTime.now();
  DateTime _initialCalendarDate = DateTime(DateTime.now().year - 1, 1, 1);
  DateTime _lastCalendarDate = DateTime(DateTime.now().year + 1, 12, 31);
  DateTime selectedCalendarDate = DateTime.now();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descpController = TextEditingController();
  Event? myEvents;
  List<Event> events = [];
  Map<DateTime, List<Event>> mySelectedEvents = {};

  // Assuming this is a method where you want to fetch and display appointments
// Change the return type to Future<List<Event>> instead of void
  Future<List<Event>> loadAppointments() async {
    final int? userId = await getUserId();

    try {
      print('Fetching appointments for specialistId: $userId');

      if (userId != null) {
        List<Event> appointments = await fetchAppointments(userId);

        print('Appointments loaded: $appointments');

        setState(() {
          // Add only new appointments to the existing list
          widget.loadedAppointments.addAll(appointments.where((appointment) =>
              !widget.loadedAppointments.contains(appointment)));
        });

        print('Appointments after loading: $widget.loadedAppointments');

        // Return the loaded appointments
        return appointments;
      } else {
        print('User ID is null. Cannot fetch appointments.');
        // Return an empty list if there is an issue
        return [];
      }
    } catch (error) {
      print('Error loading appointments: $error');
      // Return an empty list if there is an error
      return [];
    }
  }

  // Updated fetchAppointments function
  Future<List<Event>> fetchAppointments(int? userId) async {
    try {
      if (userId == null) {
        print('Error: UserId is null.');
        return [];
      }

      final response = await http.get(Uri.parse(
          'http://192.168.1.3:5000/appointments_specialists/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['appointments'];

        List<Event> appointments = data.map((appointment) {
          final String? meetingType =
              appointment['meetingType'] ?? 'DefaultMeetingType';
          final String eventTitle = 'Appointment';
          final String? availableTimes =
              appointment['availableTimes'] ?? 'DefaultAvailableTimes';

          final Map<String, dynamic>? doctorData = appointment['doctor'];
          final Doctor? doctor = doctorData != null
              ? Doctor(
                  name: doctorData['name'] ?? 'DefaultDoctorName',
                  image: doctorData['image'] ?? 'DefaultDoctorImage',
                  specialistId: doctorData['specialistId'] ?? -1,
                )
              : null;

          final Map<String, dynamic>? patientData = appointment['patient'];
          final Patient? patient = patientData != null
              ? Patient(
                  name: patientData['name'] ?? 'DefaultPatientName',
                  image: patientData['image'] ?? 'DefaultPatientImage',
                  patientId: patientData['patientId'] ?? -1,
                )
              : null;

          return Event(
            meetingType: meetingType,
            doctor: doctor,
            patient: patient,
            eventTitle: eventTitle,
            availabletimes: availableTimes,
            eventDate:
                DateTime.tryParse(appointment['eventDate']) ?? DateTime.now(),
          );
        }).toList();

        return appointments;
      } else {
        print(
            'Failed to load appointments. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching appointments: $error');
      return [];
    }
  }

  // Assuming this is a method where you want to fetch and display appointments
// Change the return type to List<Event> instead of void
  Future<List<Event>> loadsessions() async {
    final int? userId = await getUserId();

    try {
      print('Fetching sessions for specialistId: $userId');

      if (userId != null) {
        List<Event> sessions = await fetchsessions(userId);

        print('Sessions loaded: $sessions');

        setState(() {
          // Remove existing sessions for the selected date
          widget.loadedSessions.removeWhere((session) =>
              session.eventDate?.day == selectedCalendarDate.day &&
              session.eventDate?.month == selectedCalendarDate.month &&
              session.eventDate?.year == selectedCalendarDate.year);

          // Add only new sessions to the existing list
          widget.loadedSessions.addAll(sessions);
        });

        print('Sessions after loading: $widget.loadedSessions');

        // Return the loaded sessions
        return sessions;
      } else {
        print('User ID is null. Cannot fetch sessions.');
        // Return an empty list if there is an issue
        return [];
      }
    } catch (error) {
      print('Error loading sessions: $error');
      // Return an empty list if there is an error
      return [];
    }
  }

  // Updated fetchAppointments function
  Future<List<Event>> fetchsessions(int? userId) async {
    try {
      if (userId == null) {
        print('Error: UserId is null.');
        return [];
      }

      final response =
          await http.get(Uri.parse('http://192.168.1.3:5000/sessions/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['sessions'];

        List<Event> appointments = data.map((appointment) {
          final String? meetingType = '';
          final String eventTitle =
              appointment['subject'] ?? 'DefaultEventTitle';
          final String? availableTimes =
              appointment['time'] ?? 'DefaultAvailableTimes';

          final Doctor? doctor = Doctor(
            name: appointment['doctorname'] ?? 'DefaultEventTitle',
            image: appointment['doctorimage'] ?? 'DefaultEventTitle',
            specialistId: appointment['specialistId'] ?? -1,
          );

          return Event(
            meetingType: meetingType,
            doctor: doctor,
            eventTitle: eventTitle,
            availabletimes: availableTimes,
            eventDate: DateTime.tryParse(appointment['Session_Date']) ??
                DateTime.now(),
          );
        }).toList();

        return appointments;
      } else {
        print('Failed to load sessions. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching sessions: $error');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize selectedCalendarDate with a default value.
    selectedCalendarDate = DateTime.now();

    // ... other initialization code ...
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      // Load appointments and sessions
      final appointments = await loadAppointments();
      final sessions = await loadsessions();

      // Group appointments and sessions by date
      final Map<DateTime, List<Event>> allEvents = {};

      for (var appointment in appointments) {
        final date = appointment.eventDate;
        if (date != null) {
          allEvents[date] = [...allEvents[date] ?? [], appointment];
        }
      }

      for (var session in sessions) {
        final date = session.eventDate;
        if (date != null) {
          allEvents[date] = [...allEvents[date] ?? [], session];
        }
      }

      // Update mySelectedEvents with the loaded data
      setState(() {
        mySelectedEvents.clear();
        mySelectedEvents.addAll(allEvents);

        // Explicitly load events for the current day
        _listOfDayEvents(selectedCalendarDate);
      });
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  List<Event> _listOfDayEvents(DateTime? selectedCalendarDate) {
    if (selectedCalendarDate == null) {
      return [];
    }

    print('Selected Calendar Date: $selectedCalendarDate');

    // Load events for the current day
    if (mySelectedEvents[selectedCalendarDate] == null) {
      mySelectedEvents[selectedCalendarDate] = [];
      setState(() {
        mySelectedEvents[selectedCalendarDate] =
            _listOfDayEvents(selectedCalendarDate);
      });
    }

    // Retrieve the list of events for the selected calendar date
    final selectedDateEvents = mySelectedEvents[selectedCalendarDate] ?? [];

    print('Appointments for $selectedCalendarDate: $selectedDateEvents');

    return selectedDateEvents;
  }

  void _navigateToAddEventScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen_Session(
          isDark: widget.isDark,
          updateState: widget.updateState,
          selectedDate: selectedCalendarDate,
          availableTimes: [
            '8:00 AM',
            '9:00 AM',
            '10:00 AM',
            '11:00 AM',
            '1:00 PM',
            '2:00 PM',
            '3:00 PM',
            '4:00 PM',
            '5:00 PM',
          ],
        ),
      ),
    );

    if (result == true) {
      loadAllData();
    }
  }

  // Asynchronous function to reload sessions
  Future<void> _reloadSessions(Map<DateTime, List<Event>> allEvents) async {
    final sessions = await loadsessions();

    for (var session in sessions) {
      final date = session.eventDate;
      if (date != null) {
        allEvents[date] = [...allEvents[date] ?? [], session];
      }
    }

    // Clear existing events and add all events from loadedAppointments and loadedSessions
    mySelectedEvents.clear();
    mySelectedEvents.addAll(allEvents);
  }

// This function creates and returns a TextField widget with specified properties.
  Widget buildTextField(
      {String? hint, required TextEditingController controller}) {
    // Create a TextField widget with the provided controller.
    return TextField(
      controller: controller,
      textCapitalization:
          TextCapitalization.words, // Capitalize each word in the input.
      decoration: InputDecoration(
        labelText: hint ??
            '', // Set the label text to the provided hint, or empty if not provided.
        focusedBorder: OutlineInputBorder(
          // Define the border when the TextField is focused.
          borderSide: const BorderSide(
              color: Colors.black, width: 1.5), // Border color and width.
          borderRadius: BorderRadius.circular(10.0), // Border radius.
        ),
        enabledBorder: OutlineInputBorder(
          // Define the border when the TextField is not focused.
          borderSide: const BorderSide(
              color: Colors.black, width: 1.5), // Border color and width.
          borderRadius: BorderRadius.circular(10.0), // Border radius.
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _navigateToAddEventScreen(), // Define the onPressed action.
        child: Icon(
          Icons.edit,
          color: Color(0xff0E4C92),
        ),
        backgroundColor: Colors.white, // Background color of the button.
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card widget for displaying content with a card-like design.
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: TableCalendar(
                calendarFormat: _calendarFormat, // Define the calendar format.

                focusedDay:
                    _focusedCalendarDate, // Set the focused calendar day.
                // today's date
                firstDay:
                    _initialCalendarDate, // Set the earliest possible date.
                lastDay: _lastCalendarDate, // Set the latest allowed date.
                eventLoader: (day) {
                  // Implement your logic to load events for the specified day
                  return mySelectedEvents[day] ?? [];
                },
                selectedDayPredicate: (currentSelectedDate) {
                  return isSameDay(selectedCalendarDate, currentSelectedDate);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedCalendarDate, selectedDay)) {
                    setState(() {
                      selectedCalendarDate = selectedDay;
                      _focusedCalendarDate = focusedDay;
                    });
                  }
                },

                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(
                        0xff87bfff), // Change this to your desired color for today's date
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 175, 210,
                        249), // Change this to your desired color for today's date
                  ),
                ),
              ),
            ),
            // Map over a list of events and display them as ListTiles.

            // ... (List item styling and onTap actions)

            ..._listOfDayEvents(selectedCalendarDate!).map(
              (myEvents) => GestureDetector(
                onTap: () {
                  if (selectedCalendarDate != null) {
                    ///meetingType
                    if (myEvents.meetingType == '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => detail_session(
                            eventTitle: myEvents.eventTitle,
                            meetingType: myEvents.meetingType,
                            availableTime: myEvents.availabletimes,
                            eventDate: selectedCalendarDate!,
                            doctor: myEvents.doctor,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => detail_specialist(
                            eventTitle: myEvents.eventTitle,
                            meetingType: myEvents.meetingType,
                            availableTime: myEvents.availabletimes,
                            eventDate: selectedCalendarDate!,
                            patient: myEvents.patient,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: ListTile(
                    // add rounded border to list item
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff87bfff),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                    // in trailing add forward icon
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black87,
                    ),

                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${myEvents.eventTitle}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Text('${myEvents.availabletimes}'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
