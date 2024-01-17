import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:convert';

class CommentModel {
  final String content;
  final int postId; // Add this field to store the post ID
  final int userId; // Add this field to store the post ID
  final String commentOwnerName; // Add this field to store the post ID
  final String commentOwnerImage;
  CommentModel(
      {required this.content,
      required this.postId,
      required this.userId,
      required this.commentOwnerImage,
      required this.commentOwnerName});

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
        content: map['content'],
        postId: map['postId'],
        userId: map['userId'],
        commentOwnerName: map['commentOwnerName'],
        commentOwnerImage: map['commentOwnerImage']);
  }
}
