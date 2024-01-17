import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/PostsModels.dart';
import 'package:flutter_application_1/models/comment.dart';
import 'package:flutter_application_1/screens/CommentsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter_application_1/shared_preferences_helper.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;
  bool isLiked;

  PostWidget(this.postModel, {required this.isLiked});
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isMounted = false; // Add this boolean flag
  final PageStorageBucket bucket = PageStorageBucket();

  String? userFullName = "";
  String? userImage = "";

  int? userId;
  List<CommentModel> comments = [];
  final Logger logger = Logger();
  String content = '';
  TextEditingController _textController = TextEditingController();
  GlobalKey<_PostWidgetState> key = GlobalKey();

  Future<void> fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/comment/${widget.postModel.postId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentsData = json.decode(response.body);

        List<Future<CommentModel>> commentsWithNames = [];
        commentsData.forEach((comment) {
          commentsWithNames.add(Future.sync(() async {
            String userName = await getUserFullName(comment['userId']);
            String userImage = await getUserImg(comment['userId']);
            print('User Image URL: $userImage');

            return CommentModel(
                content: comment['content'].toString(),
                postId: comment['postId'],
                userId: comment['userId'],
                commentOwnerName: userName,
                commentOwnerImage: userImage);
          }));
        });

        List<CommentModel> resolvedComments =
            await Future.wait(commentsWithNames);

        setState(() {
          comments = resolvedComments;
        });
      } else {
        print('Failed to fetch comments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comments: $error');
    }
  }

  Future<String> getUserFullName(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/User/$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final String userFullName = userData['fullname'];
        //  print('user name:' + userFullName);
        return userFullName;
      } else {
        print('Failed to load user details: ${response.statusCode}');
        return "Unknown";
      }
    } catch (error) {
      print('Error loading user details: $error');
      return "Unknown";
    }
  }

  Future<String> getUserImg(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/GetUserDetails/$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final String userimage = userData['image'];

        // Check if the image URL is not empty or null
        if (userimage != null && userimage.isNotEmpty) {
          return userimage;
        } else {
          print('User Image URL is empty or null');
          return "Unknown";
        }
      } else {
        print('Failed to load user details: ${response.statusCode}');
        return "Unknown";
      }
    } catch (error) {
      print('Error loading user details: $error');
      return "Unknown";
    }
  }

  Future<void> addComment() async {
    try {
      int? userId = await getUserId();
      print("user id:" + userId.toString());

      String ownerName = await getUserFullName(userId!) ?? "Unknown";
      String ownerImg = await getUserImg(userId) ?? "Unknown";

      print("user name2:" + ownerName);

      if (content.trim().isEmpty) {
        return;
      }

      final response = await http.put(
        Uri.parse('http://localhost:5000/comments/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'content': content,
          'postId': widget.postModel.postId,
          'userId': userId,
          'commentOwnerName': ownerName,
          'commentOwnerImage': ownerImg,
        }),
      );

      print('Server Response: ${response.statusCode} - ${response.body}');

      final dynamic decodedResponse = jsonDecode(response.body);

      if (decodedResponse != null && decodedResponse['comment'] != null) {
        final dynamic commentData = decodedResponse['comment'];

        if (commentData != null &&
            commentData['content'] != null &&
            commentData['postId'] != null &&
            commentData['userId'] != null &&
            commentData['commentOwnerName'] != null &&
            commentData['commentOwnerImage'] != null) {
          final String commentContent = commentData['content'].toString();
          final String commentPostId = commentData['postId'].toString();
          final String commentuserId = commentData['userId'].toString();
          final String commentcommentOwnerName =
              commentData['commentOwnerName'].toString();
          final String commentcommentOwnerImage =
              commentData['commentOwnerImage'].toString();

          // Check if the widget is still mounted before calling setState
          if (!mounted) return;

          setState(() {
            comments.add(CommentModel(
                content: commentContent,
                postId: int.parse(commentPostId),
                userId: int.parse(commentuserId),
                commentOwnerImage: commentcommentOwnerImage,
                commentOwnerName: commentcommentOwnerName));
            _textController.clear();
            content = '';
          });
        } else {
          print('Error adding comment: Comment data has incorrect types');
        }
      } else {
        print('Error adding comment: Comment data is null');
      }
    } catch (error) {
      // Check if the widget is still mounted before printing the error
      if (!mounted) return;
      print('Error adding comment: $error');
    }
  }

  void viewComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsScreen(comments),
      ),
    );
  }

  Future<void> toggleLike() async {
    try {
      int? userId = await getUserId();

      final response = await http.post(
        Uri.parse(
          'http://localhost:5000/posts/toggleLike/${widget.postModel.postId}',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
        }),
      );

      print('Server Response: ${response.statusCode} - ${response.body}');

      final dynamic decodedResponse = jsonDecode(response.body);

      if (decodedResponse != null &&
          decodedResponse['message'] != null &&
          decodedResponse['likeCount'] != null) {
        final String message = decodedResponse['message'].toString();
        final int updatedLikeCount = decodedResponse['likeCount'];

        setState(() {
          widget.isLiked = !widget.isLiked; // Toggle like status
          widget.postModel.likeCount = updatedLikeCount; // Update like count
        });
        print("Like Status:" + widget.isLiked.toString());

        print('Like Count: ' + widget.postModel.likeCount.toString());
      } else {
        print('Error toggling like: Incorrect response format');
      }
    } catch (error) {
      print('Error toggling like: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    key = GlobalKey(); // Initialize the GlobalKey in initState
    isMounted = true; // Set the flag to true in initState
    fetchComments();
    // checkLikeStatus(); // Call checkLikeStatus during initialization
    getUserId().then((userId) {
      print('Current User ID: $userId');
    });
  }

  @override
  void dispose() {
    isMounted = false; // Set the flag to false in dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      key: PageStorageKey<String>('post_${widget.postModel.postId}'),
      bucket: bucket,
      child: Column(
        // key: key, // Add a GlobalKey to uniquely identify this widget

        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.postModel.profileImage ?? "",
                  ),
                  radius: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.userName ?? "UnKnown",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.postModel.createdAt ?? "UnKnown",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.postModel.image),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: widget.isLiked ? Colors.red : Colors.grey,
                          size: 25,
                        ),
                        Text(widget.postModel.likeCount.toString() + " likes"),
                      ],
                    ),
                    onTap: () {
                      //await checkLikeStatus();
                      toggleLike();
                    },
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      viewComments();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text("View Comments"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    widget.postModel.postContent,
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w500),
                  )),
              Column(
                children: [
                  SizedBox(height: 5), // Add some space between the two rows
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          onChanged: (v) {
                            content = v;
                          },
                          decoration: InputDecoration(
                            hintText: 'Write your comment',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () async {
                          print(
                            'Before addComment: postId=${widget.postModel.postId}, content=$content',
                          );
                          int? userId = await getUserId();
                          print("user id:" + userId.toString());

                          await getUserFullName(userId!);
                          await getUserImg(userId);
                          print(
                            "user name2:" + (userFullName ?? "Unknown"),
                          );

                          await addComment();
                        },
                        child: Container(
                          child: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 2, 5, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display only the first comment under the post
                    comments.isNotEmpty
                        ? ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                comments[0].commentOwnerImage ??
                                    "", // Provide the image URL
                              ),
                              radius: 20,
                            ),
                            title: Text(comments[0].commentOwnerName),
                            subtitle: Text(comments[0].content),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Divider(
                thickness: 3,
                color: Colors.blue,
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
