import 'dart:core';

class ReportCategory {
  int report_type_id;
  int classroom_id;
  String name;
  String description;
  String icon;

  ReportCategory({
    this.report_type_id,
    this.classroom_id,
    this.name,
    this.description,
    this.icon,
  });

  ReportCategory.fromJSON(Map<String, dynamic> json) {
    this.report_type_id = json["report_type_id"];
    this.classroom_id = json["classroom_id"];
    this.name = json["name"];
    this.description = json["description"];
    this.icon = json["icon"];
  }
}
