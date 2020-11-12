import 'dart:core';

class Teacher {
  int user_id;
  String name;
  String avatar;
  String dob;
  String email;
  String phone_number;
  String address;
  int school_id;

  Teacher({
    this.user_id,
    this.name,
    this.avatar,
    this.dob,
    this.email,
    this.phone_number,
    this.address,
    this.school_id,
  });

  Teacher.fromJSON(Map<String, dynamic> json) {
    user_id = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
    dob = json['dob'];
    email = json['email'];
    phone_number = json['phone_number'];
    address = json["address"];
    school_id = json['school_id'];
  }
}