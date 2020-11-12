import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart';

class RequestManager {
  final String BASE_URL = Constants.domain;

  Future<http.Response> startPostRequest(String url, Map map) async{
    final headers = {
      "Content-Type": "application/json",
      "token": '${DataSingleton.instance.edUser.accessToken}'
    };
    try {
      var body = json.encode(map);
      var Response = await http.post(url, headers: headers, body: body);
      print(Response.body);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        return Response;
      } else if (Response.statusCode == 401) {
        String accessToken = await refreshToken();
        if (accessToken != "") {
          try {
            var Response = await http.post(url, headers: {
              "Content-Type": "application/json",
              "token": '${accessToken}'
            }, body: body);
            print(Response.body);
            return Response;
          } catch(_) {
            throw Exception('request post error');
          }
        }
        else {
          return Response;
        }
      } else {
        return Response;
      }
    } catch(_) {
      throw Exception('request post error');
    }
  }

  Future<http.Response> startPutRequest(String url, Map map) async{
    final headers = {
      "Content-Type": "application/json",
      "token": '${DataSingleton.instance.edUser.accessToken}'
    };
    try {
      var body = json.encode(map);
      var Response = await http.put(url, headers: headers, body: body);
      print(Response.body);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        return Response;
      } else if (Response.statusCode == 401) {
        String accessToken = await refreshToken();
        if (accessToken != "") {
          try {
            var Response = await http.put(url, headers: {
              "Content-Type": "application/json",
              "token": '${accessToken}'
            }, body: body);
            print(Response.body);
            return Response;
          } catch(_) {
            throw Exception('request put error');
          }
        }
        else {
          return Response;
        }
      } else {
        return Response;
      }
    } catch(_) {
      throw Exception('request put error');
    }
  }

  Future<http.Response> startDeleteRequest(String url) async{
    final headers = {
      "Content-Type": "application/json",
      "token": '${DataSingleton.instance.edUser.accessToken}',
    };
    try {
      print(headers);
      var Response = await http.delete(url, headers: headers);
      print(Response.body);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        return Response;
      } else if (Response.statusCode == 401) {
        String accessToken = await refreshToken();
        if (accessToken != "") {
          try {
            var Response = await http.delete(url, headers: {
              "Content-Type": "application/json",
              "token": '${accessToken}'
            });
            print(Response.body);
            return Response;
          } catch(_) {
            throw Exception('request delete error');
          }
        }
        else {
          return Response;
        }
      } else {
        return Response;
      }
    } catch(_) {
      throw Exception('request delete error');
    }
  }

  Future<http.Response> startGetRequest(String url) async{
    final headers = {
      "Content-Type": "application/json",
      "token": '${DataSingleton.instance.edUser.accessToken}',
    };
    try {
      print(headers);
      var Response = await http.get(url, headers: headers);
      print(Response.body);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        return Response;
      } else if (Response.statusCode == 401) {
        String accessToken = await refreshToken();
        if (accessToken != "") {
          try {
            var Response = await http.get(url, headers: {
              "Content-Type": "application/json",
              "token": '${accessToken}'
            });
            print(Response.body);
            return Response;
          } catch(_) {
            throw Exception('request get error');
          }
        }
        else {
          return Response;
        }
      } else {
        return Response;
      }
    } catch(_) {
      throw Exception('request get error');
    }
  }

  Future<String> refreshToken() async {
    try {
      String url = BASE_URL + "api/auth/refresh-token";
      Map map = {
        "refresh_token": '${DataSingleton.instance.edUser.refreshToken}'
      };
      var body = json.encode(map);
      var Response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "token": '${DataSingleton.instance.edUser.accessToken}'
      }, body: body);
      print(Response.body);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON["success"] == true) {
          var accessToken = responseJSON["data"]["accessToken"];
          var refreshToken = responseJSON["data"]["refreshToken"];
          UserRepository().saveToken(accessToken, refreshToken);
          DataSingleton.instance.edUser.accessToken = accessToken;
          DataSingleton.instance.edUser.refreshToken = refreshToken;
          return accessToken;
        }
        return "";
      } else if (Response.statusCode == 401) {
        DartNotificationCenter.post(channel: CHANNEL_NAME);
      }
      return "";
    } catch (_) {
      throw Exception('refresh token error');
    }
  }
}