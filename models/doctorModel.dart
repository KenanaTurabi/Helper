// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/animation.dart';

class Doctor {
  int? id;
  String? name;
  String? specialization;
  String? CurrentWorkPlace;
  int? experience;
  String? image;
  int? mobileNumber;
  bool? isPending;
  String? city;
  Doctor(
      {this.id,
      this.name,
      this.specialization,
      this.CurrentWorkPlace,
      this.experience,
      this.image,
      this.mobileNumber,
      this.isPending,
      this.city});
  Doctor.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    specialization = map['specialization'];
    CurrentWorkPlace = map['CurrentWorkPlace'];
    experience = map['experience'];
    image = map['image'];
    mobileNumber = map['mobileNumber'];
    city = map['city'];
    isPending = map['isPending'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['specialization'] = this.specialization;
    data['CurrentWorkPlace'] = this.CurrentWorkPlace;
    data['experience'] = this.experience;
    data['image'] = this.image;
    data['city'] = this.city;
    data['mobileNumber'] = this.mobileNumber;
    data['isPending'] = this.isPending;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'specialization': specialization,
      'CurrentWorkPlace': CurrentWorkPlace,
      'experience': experience,
      'image': image,
      'mobileNumber': mobileNumber,
      'city': city,
      'isPending': isPending,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> source) {
    return Doctor(
      id: source['id'],
      name: source['name'],
      specialization: source['specialization'],
      CurrentWorkPlace: source['CurrentWorkPlace'],
      experience: source['experience'],
      image: source['image'],
      mobileNumber: source['mobileNumber'],
      city: source['city'],
      isPending: source['isPending'],
    );
  }
}
