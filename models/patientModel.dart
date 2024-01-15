// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/animation.dart';

class Patient {
  int? id;
  String? name;
  String? image;
  int? mobileNumber;
  String? city;

  Patient(
      {this.id,
      this.name,
      this.image,
      this.mobileNumber,
      this.city});
  Patient.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    image = map['image'];
    mobileNumber = map['mobileNumber'];
    city = map['city'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['city'] = this.city;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'mobileNumber': mobileNumber,
      'city': city,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> source) {
    return Patient(
      id: source['id'],
      name: source['name'],
      image: source['image'],
      mobileNumber: source['mobileNumber'],
      city: source['city'],
    );
  }
}
