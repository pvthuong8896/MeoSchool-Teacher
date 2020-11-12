import 'dart:core';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';

class User {
  int user_id;
  int school_id;
  String name;
  String avatar;
  String dob;
  String email;
  String phone_number;
  String accessToken;
  String refreshToken;
  String chatToken = "";
  String chatId = "";

  User({
    this.user_id,
    this.school_id,
    this.name,
    this.avatar,
    this.dob,
    this.email,
    this.phone_number,
    this.accessToken,
    this.refreshToken,
    this.chatToken,
    this.chatId
  });

  User.fromJSON(Map<String, dynamic> json) {
    user_id = json['profile']['user_id'];
    school_id = json['profile']['school_id'];
    name = json['profile']['name'];
    avatar = json['profile']['avatar'];
    dob = json['profile']['dob'];
    email = json['profile']['email'];
    phone_number = json['profile']['phone_number'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  User.updateProfileFromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    school_id = json['school_id'];
    name = json['name'];
    avatar = json['avatar'];
    dob = json['dob'];
    email = json['email'];
    phone_number = json['phone_number'];
    accessToken = DataSingleton.instance.edUser.accessToken;
    refreshToken = DataSingleton.instance.edUser.refreshToken;
  }

  User.fromComment(Map<String, dynamic> json) {
    user_id = json['user_id'];
    school_id = json['school_id'];
    name = json['name'];
    avatar = json['avatar'];
    dob = json['dob'];
    email = json['email'];
    phone_number = json['phone_number'];
  }
}