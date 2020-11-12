import 'dart:core';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';

class Post {
  int author_id;
  int post_id;
  String content;
  String visible_with;
  int total_comments;
  int total_likes;
  String created_at;
  Teacher author;
  List<Student> students = [];
  ClassRoom classRoom;
  bool liked;
  int total_seens;
  bool seen;
  List<EdTechFile> files = [];
  String videoThumbnail;
  String videoUrl;

  Post({
    this.author_id,
    this.post_id,
    this.content,
    this.total_comments,
    this.total_likes,
    this.created_at,
    this.author,
    this.liked,
    this.visible_with,
    this.students,
    this.classRoom,
    this.total_seens,
    this.seen,
    this.videoThumbnail,
    this.videoUrl
  });

  Post.fromJSON(Map<String, dynamic> json) {
    this.author_id = json["author_id"];
    this.post_id = json["post_id"];
    this.content = json["content"];
    this.total_comments = json["total_comments"];
    this.total_likes = json["total_likes"];
    this.created_at = json["created_at"];
    this.liked = json["liked"];
    this.visible_with = json["visible_with"];
    this.total_seens = json["total_seens"];
    this.seen = json["seen"];
    this.videoThumbnail = json["video_thumbnail"];
    this.videoUrl = json["video_url"];
    if (this.visible_with == CLASS_ROOM) {
      this.classRoom = ClassRoom.fromPostJSON(json["classroom"]);
    } else if (this.visible_with == STUDENT) {
      var responseList = json["target_students"] as List;
      this.students = responseList.map((s) => Student.fromJSON(s)).toList();
    }
    var responseList = json["files"] as List;
    this.files = responseList.map((s) => EdTechFile.fromJSON(s)).toList();
    if (json["author"] is Map<String, dynamic>) {
      this.author = Teacher.fromJSON(json["author"]);
    } else {
      final user = DataSingleton.instance.edUser;
      final teacher = new Teacher(
          user_id: user.user_id,
          name: user.name,
          avatar: user.avatar,
          dob: user.dob,
          email: user.email,
          phone_number: user.phone_number,
          school_id: user.school_id);
      this.author = teacher;
    }
  }
}
