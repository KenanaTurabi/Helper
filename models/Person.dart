import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Person {
  int? id;
  String? name;
  String? FullAddress;
  int? mobileNumber;
  int? age;
  String? photo;
  String? gender;
  Person(
      {this.id,
      this.name,
      this.FullAddress,
      this.mobileNumber,
      this.age,
      this.photo,
      this.gender});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'FullAddress': FullAddress,
      'mobileNumber': mobileNumber,
      'age': age,
      'photo': photo,
      'gender': gender,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      FullAddress:
          map['FullAddress'] != null ? map['FullAddress'] as String : null,
      mobileNumber:
          map['mobileNumber'] != null ? map['mobileNumber'] as int : null,
      age: map['age'] != null ? map['age'] as int : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);
}
