import 'dart:core';

class EdTechNotification {
  int notification_id;
  int user_id;
  String title;
  String noti_type;
  int target_id;
  bool has_seen;
  String created_at;

  EdTechNotification({
    this.notification_id,
    this.user_id,
    this.title,
    this.noti_type,
    this.target_id,
    this.has_seen,
    this.created_at,
  });

  EdTechNotification.fromJSON(Map<String, dynamic> json) {
    this.notification_id = json["notification_id"];
    this.user_id = json["user_id"];
    this.title = json["title"];
    this.noti_type = json["noti_type"];
    this.target_id = json["target_id"];
    this.has_seen = json["has_seen"];
    this.created_at = json["created_at"];
  }
}