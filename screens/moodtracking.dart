import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/MoodGraph.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'dart:convert';

class MoodSelectionPage extends StatefulWidget {
  @override
  _MoodSelectionPageState createState() => _MoodSelectionPageState();
}

class _MoodSelectionPageState extends State<MoodSelectionPage> {
  late String selectedEmoji;

  @override
  void initState() {
    super.initState();
    selectedEmoji = '😊'; // Default emoji
  }

  Future<void> sendMoodToBackend(String moodValue) async {
    final int? userId = await getUserId(); //patientId
    print(moodValue);
    print(userId);

    final url = Uri.parse('http://192.168.1.3:5000/insertmood/$userId');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'moodValue': moodValue}), // Use jsonEncode
        headers: {'Content-Type': 'application/json'}, // Specify content type
      );

      if (response.statusCode == 200) {
        print('Mood successfully sent to the backend');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoodDiagramPage(),
          ),
        );
        // You can handle the success as needed
      } else {
        print('Failed to send mood to the backend');
        // Handle the failure scenario
      }
    } catch (error) {
      print('Error sending mood to the backend: $error');
      // Handle the error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Mood'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
        children: [
          Text(
            "How do you feel today?",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              EmojiList(onEmojiSelected: (emoji) {
                setState(() {
                  selectedEmoji = emoji;
                });
                print('Selected emoji: $emoji');
              }),
            ],
          ),
          SizedBox(height: 50.0),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                // Use ElevatedButton instead of FlatButton
                onPressed: () {
                  sendMoodToBackend(selectedEmoji);
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color(0xff87bfff), // Set the button's background color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),

                child: Text(
                  "Next",
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
    );
  }
}

class EmojiList extends StatefulWidget {
  final Function(String) onEmojiSelected;

  const EmojiList({Key? key, required this.onEmojiSelected}) : super(key: key);

  @override
  _EmojiListState createState() => _EmojiListState();
}

class _EmojiListState extends State<EmojiList> {
  late String selectedEmoji;

  @override
  void initState() {
    super.initState();
    selectedEmoji = '😊'; // Default emoji
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: EmojiListWidget.emojis.length,
              itemBuilder: (context, index) {
                final emoji = EmojiListWidget.emojis[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEmoji = emoji;
                      });
                      widget.onEmojiSelected(selectedEmoji);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: selectedEmoji == emoji
                            ? Color(0xff87bfff)
                            : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class EmojiListWidget {
  static const List<String> emojis = [
    '😂',
    '😊',
    '😇',
    '🥺',
    '😢',
    '😡',

    // Add more emojis as needed
  ];
}
