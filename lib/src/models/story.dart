import 'dart:core';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/eduser.dart';

class Story {
  int id;
  int student_id;
  String type;
  String content;
  String created_at;
  User creator = User();

  Story({
    this.id,
    this.student_id,
    this.type,
    this.content,
    this.created_at,
    this.creator
  });

  Story.fromJSON(Map<String, dynamic> json) {
    this.id = json["id"];
    this.student_id = json["student_id"];
    this.type = json["type"];
    this.content = json["content"];
    this.created_at = json["created_at"];
    if (json["creator"] is Map<String, dynamic>) {
      this.creator = User.fromComment(json["creator"]);
    } else {
      final creator = DataSingleton.instance.edUser;
      this.creator = creator;
    }
  }
}
