import 'dart:core';

import 'package:edtechteachersapp/src/models/index.dart';

class Student {
  int student_id;
  String code;
  String name;
  String address;
  String avatar;
  String dob;
  int school_id;
  bool isSelected = false;
  String created_at;
  String updated_at;
  var school;
  bool has_follower;
  Checking checking = new Checking();

  Student({
    this.student_id,
    this.code,
    this.name,
    this.address,
    this.avatar,
    this.dob,
    this.school_id,
    this.created_at,
    this.updated_at,
    this.school,
    this.has_follower,
    this.checking
  });


  Student.fromJSON(Map<String, dynamic> json) {
    this.student_id = json["student_id"];
    this.code = json["code"];
    this.name = json["name"];
    this.address = json["address"];
    this.avatar = json["avatar"];
    this.dob = json["dob"];
    this.school_id = json["school_id"];
    if (json["checking"] is Map<String, dynamic>) {
      this.checking = Checking.fromJSON(json["checking"]);
    }
  }

  Student.fromPostJSON(Map<String, dynamic> json) {
    this.student_id = json["student_id"];
    this.name = json["name"];
    this.avatar = json["avatar"];
  }

  Student.fromGetDetailJSON(Map<String, dynamic> json) {
    this.student_id = json["student_id"];
    this.code = json["code"];
    this.name = json["name"];
    this.address = json["address"];
    this.avatar = json["avatar"];
    this.dob = json["dob"];
    this.school_id = json["school_id"];
    this.created_at = json["created_at"];
    this.updated_at = json["updated_at"];
    this.school = json["school"];
    this.has_follower = json["has_follower"];
  }
}