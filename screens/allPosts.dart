import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/addPost.dart';
import 'package:flutter_application_1/widgets/postWidget.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/PostsModels.dart';

class AllPosts extends StatefulWidget {
  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/GetAllPosts'));

      if (response.statusCode == 200) {
        final List<dynamic> postsJsonList =
            json.decode(response.body) as List<dynamic>;

        return postsJsonList.map((item) => PostModel.fromMap(item)).toList();
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<PostModel>>(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No posts available.'));
              } else {
                List<PostModel> posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostWidget(posts[index]);
                  },
                );
              }
            },
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InsertDataPage()),
            );
          },
          backgroundColor: Colors.blue,
          mini: true,
          child: Icon(Icons.add),
        )
      ],
    );
  }
}
