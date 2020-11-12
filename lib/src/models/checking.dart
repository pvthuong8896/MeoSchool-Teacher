import 'dart:core';

class Checking {
  int checking_id;
  int student_id;
  int teacher_id;
  String checkin_image;
  String checkout_image;
  String date;
  String checkin_time;
  String checkout_time;
  bool checkin = false;
  bool checkout = false;
  bool absent = false;
  String created_at;
  String updated_at;

  Checking({
    this.checking_id,
    this.student_id,
    this.teacher_id,
    this.checkin_image,
    this.checkout_image,
    this.date,
    this.checkin_time,
    this.checkout_time,
    this.checkin,
    this.checkout,
    this.absent,
    this.created_at,
    this.updated_at
  });

  Checking.fromJSON(Map<String, dynamic> json) {
    this.checking_id = json["checking_id"];
    this.student_id = json["student_id"];
    this.teacher_id = json["teacher_id"];
    this.checkin_image = json["checkin_image"];
    this.checkout_image = json["checkout_image"];
    this.date = json["date"];
    this.checkin_time = json["checkin_time"];
    this.checkout_time = json["checkout_time"];
    this.checkin = json["checkin"];
    this.checkout = json["checkout"];
    this.absent = json["absent"];
    this.created_at = json["created_at"];
    this.updated_at = json["updated_at"];
  }
}