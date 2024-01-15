//flutter run -d windows -t lib/main.dart --dart-define=FLUTTER_WINDOW_SIZE=200x400

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/screens/admin.dart';
import 'package:flutter_application_1/welcomePage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/repositories/PersonalInfo.dart';
import 'package:flutter_application_1/repositories/doctorsData.dart';
import 'package:flutter_application_1/repositories/postsData.dart';
import 'package:flutter_application_1/screens/allDoctors.dart';
import 'package:flutter_application_1/screens/allPosts.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:flutter_application_1/widgets/PersonWidget.dart';
import 'package:flutter_application_1/widgets/addPost.dart';
import 'package:flutter_application_1/widgets/docotFullDataWidget.dart';
import 'package:flutter_application_1/widgets/doctorWidget.dart';
import 'package:flutter_application_1/widgets/postWidget.dart';
import 'package:flutter_application_1/changeNotifier.dart';
import 'package:flutter_application_1/welcomePage.dart';
import 'package:flutter_application_1/screens/chatDetailPage.dart';
import 'package:flutter_application_1/models/chatUsersModel.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowMinSize(const Size(460, 820));
  setWindowMaxSize(Size.infinite);
  runApp(
    ChangeNotifierProvider(
      create: (context) => PageControllerProvider(),
      child: CombinedApp(),
    ),
  );
}

class CombinedApp extends StatelessWidget {
  const CombinedApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined App',
      theme: ThemeData(),
      home: CombinedScreen(),
      routes: {
        '/chatDetailPage': (context) => ChatDetailPage(),
        // You can add other routes here as needed
      },
    );
  }
}

class CombinedScreen extends StatefulWidget {
  @override
  State<CombinedScreen> createState() => _CombinedScreenState();
}

class _CombinedScreenState extends State<CombinedScreen> {
  bool isDark = false;

  void updateState(bool newValue) {
    setState(() {
      isDark = newValue;
      print(isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('form main isDark=' + isDark.toString());

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        //  extendBody: true,
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(60),
        //   child: CustomeAppBar(isDark, updateState),
        // ),
        body:
            //AdminPage(isDark, updateState),
            // BottomNavigationBarExample(isDark, updateState),
            // WelcomeScreen(isDark, updateState),
            WelcomeScreen(),
        // PersonWidget(allPersons[1], isDark, updateState),
        // Other widgets/screens can be added here based on your requirements
      ),
    );
  }
}
