import 'dart:core';

import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/eduser.dart';
import 'package:edtechteachersapp/src/models/index.dart';

class Report {
  String target;
  int report_id;
  int report_type_id;
  int classroom_id;
  String content;
  String created_at;
  User reporter = User();
  ReportCategory report_type;

  Report({
    this.target,
    this.report_id,
    this.report_type_id,
    this.classroom_id,
    this.content,
    this.created_at,
    this.reporter,
    this.report_type
  });

  Report.fromJSON(Map<String, dynamic> json) {
    this.target = json["target"];
    this.report_id = json["report_id"];
    this.report_type_id = json["report_type_id"];
    this.classroom_id = json["classroom_id"];
    this.content = json["content"];
    this.created_at = json["created_at"];
    if (json["reporter"] is Map<String, dynamic>) {
      this.reporter = User.fromComment(json["reporter"]);
    } else {
      final user = DataSingleton.instance.edUser;
      this.reporter = user;
    }
    if (json["report_type"] is Map<String, dynamic>) {
      this.report_type = ReportCategory.fromJSON(json["report_type"]);
    }
  }
}
