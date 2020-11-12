import 'dart:core';

class ClassRoom {
  int classroom_id;
  int subject_id;
  String name;
  Subject subject;
  int school_id;
  String icon;
  int total_parents;
  int total_students;

  ClassRoom({
    this.classroom_id,
    this.subject_id,
    this.name,
    this.subject,
    this.school_id,
    this.icon,
    this.total_parents,
    this.total_students
  });

  ClassRoom.fromJSON(Map<String, dynamic> json) {
    this.classroom_id = json["classroom_id"];
    this.subject_id = json["subject_id"];
    this.name = json["name"];
    this.subject = Subject.fromJSON(json["subject"]);
    this.school_id = json["school_id"];
    this.icon = json["icon"];
    this.total_parents = json["total_parents"];
    this.total_students = json["total_students"];
  }

  ClassRoom.fromPostJSON(Map<String, dynamic> json) {
    this.classroom_id = json["classroom_id"];
    this.name = json["name"];
    this.icon = json["icon"];
  }
}

class Subject {
  int subject_id;
  String name;
  String description;
  int school_id;

  Subject({
    this.subject_id,
    this.name,
    this.description,
    this.school_id,
  });

  Subject.fromJSON(Map<String, dynamic> json) {
    this.subject_id = json["subject_id"];
    this.name = json["name"];
    this.description = json["description"];
    this.school_id = json["school_id"];
  }
}