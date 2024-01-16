import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/screens/allPosts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/shared_preferences_helper.dart';

class InsertDataPage extends StatefulWidget {
  final BuildContext context;
  InsertDataPage({required this.context});
  @override
  _InsertDataPageState createState() => _InsertDataPageState();
}

class _InsertDataPageState extends State<InsertDataPage> {
  TextEditingController contentController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  int? userId;

  @override
  void initState() {
    super.initState();
    getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  Future<void> _submitData() async {
    if (userId == null) {
      print('User ID is null. Please check SharedPreferences.');
      return;
    }

    String content = contentController.text;
    String imageUrl = imageUrlController.text;

    // You can do something with the entered content and image URL
    print('Content: $content');
    print('Image URL: $imageUrl');

    // Send data to the API
    await _addPostToServer(content, imageUrl, userId!);

    // Navigate back to the AllPosts page
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BottomNavigationBarExample()),
    );
    // Navigator.push(
    // context, MaterialPageRoute(builder: (context) => AllPosts()));
  }

  Future<void> _addPostToServer(
      String content, String imageUrl, int userId) async {
    final DateTime now = DateTime.now();
    final String formattedDate = now.toLocal().toString();
    // Define your API endpoint
    final apiUrl = 'http://localhost:5000/Posts/add';

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'postContent': content,
      'image': imageUrl,
      'userId': userId,
      'postId': 0, // Provide a default value or generate dynamically
      'likeCount': 0,
      'createdAt': formattedDate,
    };

    try {
      // Make the HTTP request
      final response = await http.put(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody));

      if (response.statusCode == 201) {
        print('Post added successfully');
      } else {
        print('Failed to add post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
