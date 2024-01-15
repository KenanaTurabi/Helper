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


 class CalendarPage extends StatefulWidget {
  final bool isDark;
  final Function updateState;

  CalendarPage({required this.isDark, required this.updateState});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}


class _CalendarPageState extends State<CalendarPage> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedCalendarDate = DateTime.now();
  DateTime _initialCalendarDate = DateTime(DateTime.now().year - 1, 1, 1);
  DateTime _lastCalendarDate = DateTime(DateTime.now().year + 1, 12, 31);
  DateTime selectedCalendarDate = DateTime.now(); // Initialize here
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descpController = TextEditingController();
  Event? myEvents; // Define the type of myEvents
 
  List<Event> events = [];
  Map<DateTime, List<Event>> mySelectedEvents = {};


  Map<DateTime, List<Event>> groupAppointmentsByDate(List<Event> appointments) {
    Map<DateTime, List<Event>> groupedAppointments = {};

    for (var appointment in appointments) {
      DateTime date = appointment.eventDate;

      // If the date is not already a key in the map, add it with an empty list
      groupedAppointments.putIfAbsent(date, () => []);

      // Add the appointment to the list corresponding to the date
      groupedAppointments[date]!.add(appointment);
    }

    return groupedAppointments;
  }

// Assuming this is a method where you want to fetch and display appointments
  void loadAppointments() async {
    final int? userId = await getUserId();

    try {
      print('Fetching appointments for userId: $userId');

      // Check if userId is not null before making the request
      if (userId != null) {
        List<Event> appointments = await fetchAppointments(userId);

        print('Appointments loaded: $appointments');

        // Assuming mySelectedEvents is a Map<DateTime, List<Event>>
        setState(() {
          // Clear existing events for the user
          mySelectedEvents.clear();

          // Group appointments by date
          for (var appointment in appointments) {
            final date = appointment.eventDate;
            if (date != null) {
              mySelectedEvents[date] = [
                ...mySelectedEvents[date] ?? [],
                appointment
              ];
            }
          }
        });

        print('mySelectedEvents after loading: $mySelectedEvents');
      } else {
        print('User ID is null. Cannot fetch appointments.');
       
      }
    } catch (error) {
      print('Error loading appointments: $error');
  
    }
  }

// Function to fetch appointments for a specific patientId
  Future<List<Event>> fetchAppointments(int? userId) async {
    try {
      if (userId == null) {
        print('Error: UserId is null.');
        return []; 
      }

      final response = await http
          .get(Uri.parse('http://localhost:5000/appointments/$userId'));

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body)['appointments'];

        List<Event> appointments = data.map((appointment) {
          // Ensure that 'meetingType' is a non-null String or provide a default value.
          final String? meetingType =
              appointment['meetingType'] ?? 'DefaultMeetingType';

          // Ensure that 'eventTitle' is a non-null String.
          final String eventTitle =
              appointment['eventTitle'] ?? 'DefaultEventTitle';

          // Ensure that 'eventDate' is a non-null String and can be parsed to DateTime.
          final String? serverDateString = appointment['eventDate'];
           final String? Currentworkingplace=appointment['currentWorkplace'];

          final DateTime eventDate = serverDateString != null
              ? DateTime.tryParse(serverDateString) ?? DateTime.now()
              : DateTime.now();

          final String? availableTimes =
              appointment['availableTimes'] ?? 'DefaultAvailableTimes';

          // Ensure that 'doctor' is a Map and contains the required fields.
          final Map<String, dynamic>? doctorData = appointment['doctor'];
          final Doctor? doctor = doctorData != null
              ? Doctor(
                  name: doctorData['name'] ?? 'DefaultDoctorName',
                  image: doctorData['image'] ?? 'DefaultDoctorImage',
                  specialistId: doctorData['specialistId'] ??  -1, // Provide a default value or handle differently
                  currentworkingplace:Currentworkingplace,

                )
              : null;

          return Event(
            meetingType: meetingType,
            doctor: doctor,
            eventTitle: eventTitle,
            availabletimes: availableTimes,
            eventDate: eventDate,
          );
        }).toList();

        return appointments;
      } else {
        print(
            'Failed to load appointments. Status code: ${response.statusCode}');
        return []; // or return null or an empty list based on your logic
      }
    } catch (error) {
      print('Error fetching appointments: $error');
      return []; // or return null or an empty list based on your logic
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize selectedCalendarDate with a default value.
    selectedCalendarDate = DateTime.now();

    // ... other initialization code ...
    loadAppointments();
  }

  List<Event> _listOfDayEvents(DateTime? selectedCalendarDate) {
    if (selectedCalendarDate == null) {
      return [];
    }

    print('Selected Calendar Date: $selectedCalendarDate');

    // Retrieve the list of events for the selected calendar date
    // from the mySelectedEvents map, or initialize an empty list.
    final selectedDateEvents = mySelectedEvents[selectedCalendarDate] ?? [];

    print('Appointments for $selectedCalendarDate: $selectedDateEvents');

    return selectedDateEvents;
  }

  void _navigateToAddEventScreen() async {
    // Use Navigator.push to navigate to 'SecondScreen'.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(
          isDark:widget.isDark,updateState:widget.updateState,
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
          ]
        ),
      ),
    );
   if(result==true){
        loadAppointments();

   }
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
    loadAppointments();

  return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _navigateToAddEventScreen(), // Define the onPressed action.
        child: Icon(
          Icons.edit,
          color: Color(0xff0E4C92),
        ),
        backgroundColor:
            Colors.white, // Background color of the button.
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
    calendarFormat: _calendarFormat,
    focusedDay: _focusedCalendarDate,
    firstDay: _initialCalendarDate,
    lastDay: _lastCalendarDate,
    eventLoader: (day) {
      // Implement your logic to load events for the specified day
      return mySelectedEvents[day] ?? [];
    },
    // ... (Other existing properties)

    selectedDayPredicate: (currentSelectedDate) {
      return isSameDay(selectedCalendarDate, currentSelectedDate);
    },
    onDaySelected: (selectedDay, focusedDay) {
      if (!isSameDay(selectedCalendarDate, selectedDay)) {
        setState(() {
          selectedCalendarDate = selectedDay;
          _focusedCalendarDate = focusedDay;
        });
        loadAppointments();
      }
    },

    calendarStyle: CalendarStyle(
      selectedDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff87bfff),
      ),
      todayDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 175, 210, 249),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detail(
                          // eventTitle: myEvents.eventTitle,
                          meetingType: myEvents.meetingType,
                          eventTitle: "Appointment",
                          availableTime: myEvents.availabletimes,
                          eventDate: selectedCalendarDate!,
                          doctor: myEvents.doctor,
                        ),
                      ),
                    );
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