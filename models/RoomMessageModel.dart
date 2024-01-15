import 'package:flutter/cupertino.dart';

class RoomMessage {
  String messageContent;
  String messageType;
  RoomMessage({required this.messageContent, required this.messageType});
}

class Room {
  final String name;
  final String doctorname;

  Room({required this.name, required this.doctorname});
}
