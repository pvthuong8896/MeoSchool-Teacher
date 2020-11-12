import 'dart:typed_data';

import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/models/edtech_file.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';

class ImageAPI {
  final String BASE_URL = Constants.domain;

  Future<EdTechFile> uploadImageWithBytes(Uint8List data) async {
    try {
      String uploadURL = BASE_URL + "api/files/upload";
      final headers = {
        "token": '${DataSingleton.instance.edUser.accessToken}',
      };
      var request = new http.MultipartRequest("POST", Uri.parse(uploadURL));
      var multipartFile = new http.MultipartFile.fromBytes("file", data,
          filename: "thumbnail", contentType: new MediaType("image", "png"));

      request.files.add(multipartFile);
      request.headers.addAll(headers);

      var Response = await request.send();

      String responseBody = await Response.stream.bytesToString();
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        // String responseBody = await Response.stream.bytesToString();
        var responseJSON = json.decode(responseBody);
        print("response json " + responseJSON.toString());
        if (responseJSON['success'] == true) {
          return EdTechFile.fromJSON(responseJSON["data"]);
        } else {
          throw responseJSON['message'];
        }
      } else {
        var responseJSON = json.decode(responseBody);
        print("response json " + responseJSON.toString());
        throw "Tải ảnh lỗi, vui lòng thử lại.!!!";
      }
    } catch (e) {
      print("error " + e.toString());
      throw e.toString();
    }
  }

  Future<EdTechFile> postUploadImg(File imageFile) async {
    try {
      final headers = {
        "token": DataSingleton.instance.edUser.accessToken,
      };
      print("data " + imageFile.path);
      String uploadURL = '${BASE_URL}api/files/upload';
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var request = new http.MultipartRequest("POST", Uri.parse(uploadURL));
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipartFile);
      request.headers.addAll(headers);

      var Response = await request.send();

      String responseBody = await Response.stream.bytesToString();
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        // String responseBody = await Response.stream.bytesToString();
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return EdTechFile.fromJSON(responseJSON["data"]);
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw "Tải ảnh lỗi, vui lòng thử lại.";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<EdTechFile>> uploadMultiImage(List<Asset> assets) async {
    try {
      String uploadURL = BASE_URL + "api/files/uploads";
      final headers = {
        "token": '${DataSingleton.instance.edUser.accessToken}',
      };
      List<http.MultipartFile> _files = [];
      for (var asset in assets) {
        int MAX_WIDTH = 500; //keep ratio
        int height =
            ((500 * asset.originalHeight) / asset.originalWidth).round();

        ByteData byteData =
            await asset.requestThumbnail(MAX_WIDTH, height, quality: 80);

        if (byteData != null) {
          List<int> imageData = byteData.buffer.asUint8List();
          var multipartFile = new http.MultipartFile.fromBytes(
              "files", imageData,
              filename: asset.name);
          _files.add(multipartFile);
        }
      }
      var request = new http.MultipartRequest("POST", Uri.parse(uploadURL));
      request.files.addAll(_files);
      request.headers.addAll(headers);

      var Response = await request.send();

      String responseBody = await Response.stream.bytesToString();
      print(responseBody);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          List<EdTechFile> listImage = [];
          var responseList = responseJSON["data"] as List;
          listImage =
              responseList.map((item) => EdTechFile.fromJSON(item)).toList();
          return listImage;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw "Tải ảnh lỗi, vui lòng thử lại.";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
