import 'dart:core';
import 'dart:io';

class EdTechFile {
  String file_id;
  String file_type;
  String file_url;
  File file;

  EdTechFile({
    this.file_id,
    this.file_type,
    this.file_url,
    this.file,
  });

  EdTechFile.fromJSON(Map<String, dynamic> json) {
    this.file_id = json["file_id"];
    this.file_type = json["file_type"];
    this.file_url = json["file_url"];
  }
}
