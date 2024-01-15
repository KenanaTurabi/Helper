import 'package:flutter/cupertino.dart';

class Session {
  String? doctorname;
  String? doctorimage;
  String? subject;
  String? time;
  final DateTime? Session_Date;

  Session({
    this.doctorname,
    this.doctorimage,
    this.subject, // Update this
    this.time,
    required this.Session_Date,
  });
}
