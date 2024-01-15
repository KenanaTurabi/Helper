import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/allDoctors.dart';
import 'package:flutter_application_1/screens/Mypatients.dart';
import 'package:flutter_application_1/screens/allPosts.dart';
import 'package:flutter_application_1/welcomePage.dart';
import 'package:flutter_application_1/widgets/PersonWidget.dart';
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
import 'package:flutter_application_1/models/Person.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/screens/treatmentPlanPage.dart';
import 'package:flutter_application_1/screens/calendarPage.dart';
import 'package:flutter_application_1/screens/CalendarPage_specialist.dart';

import 'package:flutter_application_1/screens/roomPage.dart';
import 'package:flutter_application_1/screens/chatPage.dart';

import 'models/Person.dart';

class BottomNavigationBarExample extends StatefulWidget {
  // bool isDark;
  // Function updateState;
  // BottomNavigationBarExample(this.isDark, this.updateState);

  static final GlobalKey<_BottomNavigationBarExampleState> navigatorKey =
      GlobalKey<_BottomNavigationBarExampleState>();

  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation.

  // Define color constants as static members of the class.
  static const Color blackCoffee =
      Color(0xFF352d39); // Dark brownish-black color.
  static const Color eggPlant = Color(0xFF6d435a); // Eggplant purple color.
  static const Color celeste = Color(0xFFb1ede8); // Light blue-green color.
  static const Color babyPowder = Color(0xFFFFFcF9); // Soft off-white color.
  static const Color ultraRed = Color(0xFFFF6978); // Bright red color.
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  final PageController _pageController =
      PageController(); // Declare a PageController
  void rebuildWidget() {
    setState(() {});
  }

  bool shouldShowTreatmentPlanIcon = false; // Add this line

  int _selectedIndex = 0;
  late List<BottomNavigationBarItem> _navigationBarItems;

  void changePagenav(int index) {
    context.read<PageControllerProvider>().setPage(index);
  }

  @override
  void initState() {
    super.initState();
    _loadNavigationBarItems();
  }

  Future<bool> _shouldShowTreatmentPlanIcon() async {
    final userType = await getUserType();
    return userType != 'specialist';
  }

  Future<void> _loadNavigationBarItems() async {
    final items = await _buildNavigationBarItems();
    final shouldShowTreatmentPlanIcon = await _shouldShowTreatmentPlanIcon();

    setState(() {
      _navigationBarItems = items;
      this.shouldShowTreatmentPlanIcon = shouldShowTreatmentPlanIcon;
    });
  }

  Future<List<BottomNavigationBarItem>> _buildNavigationBarItems() async {
    final shouldShowTreatmentPlanIcon = await _shouldShowTreatmentPlanIcon();

    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Room',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_rounded),
        label: 'Chats',
      ),
      if (shouldShowTreatmentPlanIcon)
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist_outlined),
          label: 'Treatment plan',
        ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month_rounded),
        label: 'Calendar',
      ),
    ];

    return items;
  }

  bool isDark = false;

  void updateState(bool newValue) {
    setState(() {
      isDark = newValue;
      print(isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('from BottomNavigationBarExample isDark =' + isDark.toString());
    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        drawer: NavDrawer(isDark, updateState),
        appBar: AppBar(
          title: Text(
            'CalmMind',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ),
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ),
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
            CupertinoSwitch(
              value: isDark,
              onChanged: (newValue) {
                print('Switch value changed to: $newValue');
                updateState(newValue);
              },
              activeColor: Colors.blue, // Set the color when switch is ON
              trackColor: Colors.grey, // Set the color of the switch track
            )
          ],
          backgroundColor: Color(0xff0E4C92),
        ),
        body: PageView(
          controller: context.watch<PageControllerProvider>().pageController,
          children: <Widget>[
            // Home Page
            _buildHomePage(),
            // Room Page
            buildRoomsPage(),
            // Chats Page
            _buildChatsPage(),
            // Treatment Plan Page (conditionally included)
            if (shouldShowTreatmentPlanIcon) _buildTreatmentPlanPage(),
            // Calendar Page
            _buildCalendarPage(),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _navigationBarItems,
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff0E4C92),
          unselectedItemColor: Colors.black54,
          onTap: (int index) {
            changePagenav(index); // Call the changePage function
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the PageController when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildHomePage() {
    AllPosts allposts = new AllPosts();
    return allposts;
  }

  Widget _buildTreatmentPlanPage() {
    TreatmentPlan treatmentplan = new TreatmentPlan(isDark, updateState);
    return treatmentplan;
  }

  Widget _buildCalendarPage() {
    return FutureBuilder<String?>(
      future: getUserType(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If still waiting for data, return a loading indicator or another widget
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there is an error fetching data, handle it appropriately
          return Text('Error: ${snapshot.error}');
        } else {
          // Data is available, check the user type
          final userType = snapshot.data;
          if (userType == 'specialist') {
            // If user is a specialist, return CalendarPage_Session
            return CalendarPage_specialist(
              isDark: isDark,
              updateState: updateState,
            );
          } else if (userType == 'patient') {
            // If user is a patient, return CalendarPage
            return CalendarPage(
              isDark: isDark,
              updateState: updateState,
            );
          } else {
            // Handle other user types or show a default page
            return Text('Unsupported user type');
          }
        }
      },
    );
  }

  Widget buildRoomsPage() {
    RoomPage roompage = new RoomPage();
    return roompage;
  }

  Widget _buildChatsPage() {
    ChatPage chatpage = new ChatPage();
    return chatpage;
  }
}

class NavDrawer extends StatefulWidget {
  bool isDark;
  Function updateState;
  NavDrawer(this.isDark, this.updateState);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Person? person;

  void changePage(int index, BuildContext context) {
    context.read<PageControllerProvider>().setPage(index);
  }

//  Future<Person> fetchUserData(int userId) async {
//   try {
//     final response = await http.get(
//       Uri.parse('http://localhost:5000/User/$userId'),
//     );
//     print('Response Status Code: ${response.statusCode}');

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> userData = json.decode(response.body);
//       return Person.fromMap(userData);
//     } else {
//       throw Exception('Failed to load user data');
//     }
//   } catch (error) {
//     print('Error fetching user data: $error');
//     throw error; // Rethrow the error so that the caller can handle it
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'CalmMind Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Color(0xff87bfff),
            ),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ),
              icon: CircleAvatar(
                backgroundColor:
                    Colors.blue, // Set the desired background color
                child: Container(
                  width: 50, // Adjust the width and height as needed
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/image1.jpg',
                      ), // Use a square image
                      fit: BoxFit
                          .cover, // Make sure the image covers the entire circle
                    ),
                  ),
                ),
              ),
            ),
            title: Text('Profile'),
            onTap: () async {
              // int? userId = await getUserId();
              // person = fetchUserData(userId);
              // print("userId=" + userId.toString());
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (_) => PersonWidget(person, widget.isDark, widget.updateState)));

              // Handle the 'Profile' navigation
            },
          ),
          FutureBuilder<String?>(
            future: getUserType(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, return a loading indicator or placeholder
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If there's an error in the Future, handle it here
                return Text('Error: ${snapshot.error}');
              } else {
                // If the Future has completed successfully, get the result
                String? userType = snapshot.data;
                print('User Type: $userType');

                // Based on user type, return the appropriate ListTile
                if (userType == 'patient') {
                  return ListTile(
                    leading: Icon(Icons.psychology_outlined),
                    title: Text('Specialists'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            AllDoctors(widget.isDark, widget.updateState))),
                  );
                } else if (userType == 'specialist') {
                  return ListTile(
                    leading: Icon(Icons.people),
                    title: Text('My Patients'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            MyPatients(widget.isDark, widget.updateState))),
                  );
                }

                // Default case or handle other user types
                return SizedBox.shrink();
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Rooms'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              changePage(1, context); // Navigate to the 'Rooms' page (index 1)
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_rounded),
            title: Text('Chats'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              changePage(2, context);
              // Handle the 'Filter' navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.checklist_outlined),
            title: Text('Treatment Plan'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              changePage(3, context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month_rounded),
            title: Text('Calendar'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              changePage(4, context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Log out'),
            onTap: () {
              // Replace the current route with a new WelcomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      //   WelcomeScreen(widget.isDark, widget.updateState),
                      WelcomeScreen(),
                ),
              );
            },
          ),
          // Rest of the ListTile items
        ],
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    /* Clear the search field */
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xff0E4C92),
      ),
    );
  }
}
