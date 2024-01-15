import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/AcceptedDoctors.dart';
import 'package:flutter_application_1/screens/AllPatients.dart';
import 'package:flutter_application_1/screens/pendingDoctors.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'dart:convert';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isDark = false;
  int _currentIndex = 0;
  void updateState(bool newValue) {
    setState(() {
      isDark = newValue;
      print(isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomeAppBar customeAppBar = new CustomeAppBar(isDark, updateState);

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: PreferredSize(
          child: customeAppBar,
          preferredSize: Size.fromHeight(60),
        ),
        body: _getPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'All Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'Accepted Doctors',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pending),
              label: 'Pending Doctors',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return AllPatientsPage();
      case 1:
        return AcceptedDoctorsPage();
      case 2:
        return PendingDoctorsPage();
      default:
        return Container();
    }
  }
}
