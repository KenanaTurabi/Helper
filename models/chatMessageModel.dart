import 'package:flutter/cupertino.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatUsers {
  final String name;
  final String messageText;
  final String imageURL; // Store asset path instead of URL
  final String time;

  ChatUsers({
    required this.name,
    required this.messageText,
    required this.imageURL, // Update this
    required this.time,
  });
}
