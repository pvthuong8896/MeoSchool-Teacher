import 'dart:core';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/eduser.dart';

class Comment {
  int comment_id;
  int user_id;
  int post_id;
  String content;
  String created_at;
  User user = User();

  Comment({
    this.comment_id,
    this.user_id,
    this.post_id,
    this.content,
    this.created_at,
    this.user
  });

  Comment.fromJSON(Map<String, dynamic> json) {
    this.comment_id = json["comment_id"];
    this.user_id = json["user_id"];
    this.post_id = json["post_id"];
    this.content = json["content"];
    this.created_at = json["created_at"];
    if (json["user"] is Map<String, dynamic>) {
      this.user = User.fromComment(json["user"]);
    } else {
      final user = DataSingleton.instance.edUser;
      this.user = user;
    }
  }
}
