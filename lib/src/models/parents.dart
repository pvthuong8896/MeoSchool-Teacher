import 'dart:core';

class Parents {
  int user_id;
  String name;
  String avatar;
  String address;
  String phone_number;
  bool isSelected = false;

  Parents({
    this.user_id,
    this.name,
    this.address,
    this.avatar,
    this.phone_number
  });


  Parents.fromJSON(Map<String, dynamic> json) {
    this.user_id = json["user_id"];
    this.name = json["name"];
    this.address = json["address"];
    this.avatar = json["avatar"];
    this.phone_number = json["phone_number"];
  }
}