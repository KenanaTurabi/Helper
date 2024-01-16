// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter_application_1/models/comment.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PostModel {
  final int postId;
  final String postContent;
  final String image;
  final String userName;
  final String? profileImage;
  List<CommentModel> comments; // New field for comments
  List<int> likes; // New field for likes
  String createdAt; // New field

  int likeCount;

  PostModel({
    required this.postId,
    required this.postContent,
    required this.image,
    required this.userName,
    required this.likeCount,
    required this.likes,
    this.profileImage,
    required this.createdAt,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as int? ??
          0, // Provide a default value (e.g., 0) if postId is null
      likeCount: map['likeCount'] as int? ?? 0,
      postContent: map['postContent'] ?? '',
      image: map['image'] ?? '',
      userName: map['userName'] ?? '',
      profileImage: map['profileImage'] ?? null,
      comments: (map['comments'] as List<dynamic>?)
              ?.map((comment) => CommentModel.fromMap(comment))
              .toList() ??
          [],
      likes: (map['likes'] as List<dynamic>?)
              ?.map((like) => like as int)
              .toList() ??
          [],
      createdAt: map['createdAt'] ?? '',
    );
  }
}


/*

class PostModel {
  final int postId;
  final String postContent;
  final String image;
  final String userName;
  final String? profileImage;
 // List<CommentModel> comments; // New field for comments



  // PostModel({
  //   required this.postId,
  //   required this.postContent,
  //   required this.image,
  //   required this.userName,
  //   this.profileImage,
  //   List<CommentModel>? comments,
  // }) : comments = comments ?? [];
  
 

  // factory PostModel.fromMap(Map<String, dynamic> map) {
  //   return PostModel(
  //     postId: map['postId'],
  //     postContent: map['postContent'],
  //     image: map['image'],
  //     userName: map['userName'],
  //     profileImage: map['profileImage'],
  //     comments: (map['comments'] as List<dynamic>?)
  //             ?.map((comment) => CommentModel.fromMap(comment))
  //             .toList() ??
  //         [],
  //   );
  // }
}
*/