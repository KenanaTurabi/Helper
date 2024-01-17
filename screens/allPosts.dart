import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared_preferences_helper.dart';
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
  late int? userId;

  Future<List<PostModel>> fetchPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.3:5000/GetAllPosts'));

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

  Future<Map<int, bool>> fetchLikeStatusForPosts(List<PostModel> posts) async {
    Map<int, bool> likeStatusMap = {};

    try {
      int? userId = await getUserId();
      print('Current User ID: $userId');

      for (PostModel post in posts) {
        final responseLike = await http.get(
          Uri.parse(
              'http://192.168.1.3:5000/posts/${post.postId}/likeStatus?userId=$userId'),
          headers: {'Content-Type': 'application/json'},
        );

        print(
            'Like Status Response for postId=${post.postId}: ${responseLike.statusCode} - ${responseLike.body}');

        if (responseLike.statusCode == 200) {
          final dynamic likeResponse = jsonDecode(responseLike.body);

          if (likeResponse is Map<String, dynamic> &&
              likeResponse.containsKey('isLiked') &&
              likeResponse.containsKey('likeCount')) {
            final bool userAlreadyLiked = likeResponse['isLiked'];
            print("********userAlreadyLiked: " +
                userAlreadyLiked.toString() +
                "********");
            likeStatusMap[post.postId] = userAlreadyLiked;
          } else {
            print(
                'Error checking like status for postId=${post.postId}: Incorrect response format');
            likeStatusMap[post.postId] =
                false; // Handle incorrect response format
          }
        } else {
          print(
              'Error checking like status for postId=${post.postId}: ${responseLike.statusCode}');
          likeStatusMap[post.postId] = false; // Handle non-200 status
        }
      }

      return likeStatusMap;
    } catch (error) {
      print('Error fetching like status: $error');
      // Handle other errors that might occur during the request
      return likeStatusMap;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize userId in initState
    getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
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
                return FutureBuilder<Map<int, bool>>(
                  future: fetchLikeStatusForPosts(posts),
                  builder: (context, likeStatusSnapshot) {
                    if (likeStatusSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (likeStatusSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${likeStatusSnapshot.error}'));
                    } else {
                      Map<int, bool> likeStatusMap =
                          likeStatusSnapshot.data ?? {};
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          bool isLiked =
                              likeStatusMap[posts[index].postId] ?? false;
                          print("is liked from all posts" + isLiked.toString());
                          return PostWidget(
                            posts[index],
                            isLiked: isLiked,
                          );
                        },
                      );
                    }
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
              MaterialPageRoute(
                  builder: (context) => InsertDataPage(context: context)),
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
