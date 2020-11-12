import 'package:edtechteachersapp/src/global/configs/constant.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:edtechteachersapp/src/repository/index.dart';

class UserAPI {
  final String BASE_URL = Constants.domain;
  final headersLogin = {
    "Content-Type": "application/json",
  };

  Future<User> login(String schoolId, String username, String password) async {
    try {
      String url = BASE_URL + "api/auth/login/teacher";
      Map map = {
        "username": username,
        "password": password,
        "school_code": schoolId
      };
      var body = json.encode(map);
      var Response = await http.post(url, headers: headersLogin, body: body);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final user = User.fromJSON(responseJSON['data']);
          return user;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getChatToken(
      Function(String, String) onSuccess, Function(String) onError) async {
    try {
      String url = BASE_URL + "api/chat/token";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          String token = responseJSON['data']["token"];
          String chat_id = responseJSON['data']["chat_id"];
          onSuccess(token, chat_id);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future logout() async {
    try {
      String url = BASE_URL + "api/auth/logout";
      Map map = {};
      var _ = await RequestManager().startPostRequest(url, map);
    } catch (_) {}
  }

  Future<List<ClassRoom>> getListClassRoom() async {
    try {
      String url = BASE_URL +
          "api/classrooms?page=1&size=20&has_teacher=${DataSingleton.instance.edUser.user_id}";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listClassrooms"] as List;
          var listClass =
              responseList.map((item) => ClassRoom.fromJSON(item)).toList();
          return listClass;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getListParents(int class_id, Function(List<Parents>) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/classrooms/$class_id/parents?page=1&size=20";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listParents"] as List;
          var listParents =
              responseList.map((item) => Parents.fromJSON(item)).toList();
          onSuccess(listParents);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<List<Student>> getListStudentsInClass(int classId) async {
    try {
      String url = BASE_URL +
          "api/classrooms/$classId/students?page=1&size=20&checking=true";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listStudents"] as List;
          var listStudents =
              responseList.map((item) => Student.fromJSON(item)).toList();
          return listStudents;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getListTeachersInClass(int classId) async {
    try {
      String url = BASE_URL + "api/classrooms/$classId/teachers";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listTeachers"] as List;
          var listTeachers =
              responseList.map((item) => Teacher.fromJSON(item)).toList();
          return listTeachers;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getListConnectParents(
      int classId, Function onSuccess, Function(String) onError) async {
    try {
      String url = BASE_URL + "api/classrooms/$classId/connects";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var _listNotConnected = responseJSON["data"]["not_connected"] as List;
          var _listWaiting = responseJSON["data"]["waiting"] as List;
          var _listConnected = responseJSON["data"]["connected"] as List;
          var listNotConnected =
              _listNotConnected.map((item) => Student.fromJSON(item)).toList();
          var listWaiting =
              _listWaiting.map((item) => Student.fromJSON(item)).toList();
          var listConnected =
              _listConnected.map((item) => Student.fromJSON(item)).toList();
          onSuccess(listNotConnected, listWaiting, listConnected);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future postSendInvitaion(String _email, String _studentCode,
      Function(String) onSuccess, Function(String) onError) async {
    try {
      String url = BASE_URL + "api/parents/invitation";
      Map<String, String> apiMap = {
        "email": _email.trim(),
        "student_code": _studentCode
      };
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          onSuccess("Gửi thành công");
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future putUpdateProfile(
      String _name,
      String _email,
      String _dob,
      String _phoneNumber,
      String _avatarUrl,
      Function(User) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/auth/profile";
      Map<String, String> apiMap = {
        "name": _name.trim(),
        "phone_number": _phoneNumber.trim(),
        "email": _email.trim(),
        "dob": _dob.trim(),
        "avatar": _avatarUrl.trim()
      };
      var Response = await RequestManager().startPutRequest(url, apiMap);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final user = User.updateProfileFromJson(responseJSON["data"]);
          onSuccess(user);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<Student> getStudentDetail(int studentId) async {
    try {
      String url = BASE_URL + "api/students/$studentId";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          Student student = Student.fromGetDetailJSON(responseJSON['data']);
          return student;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future putUpdateStudentProfile(
      String _name,
      String _dob,
      String _address,
      String _avatarUrl,
      int _studentId,
      Function(Student) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/students/$_studentId";
      Map<String, String> apiMap = {
        "name": _name.trim(),
        "dob": _dob.trim(),
        "address": _address.trim(),
        "avatar": _avatarUrl.trim(),
      };
      var Response = await RequestManager().startPutRequest(url, apiMap);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final student = Student.fromJSON(responseJSON["data"]);
          onSuccess(student);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<Post> createVideoPost(
      String target,
      int classroomId,
      List<Student> students,
      String content,
      String videoThumbnail,
      String videoUrl) async {
    try {
      String url = BASE_URL + "api/posts";
      Map<String, dynamic> apiMap = {
        "content": content,
        "video_thumbnail": videoThumbnail,
        "video_url": videoUrl
      };
      if (target == CLASS_ROOM) {
        apiMap["classroom_id"] = json.encode(classroomId);
      } else {
        List<int> studentsIdString = [];
        for (var i = 0; i < students.length; i++) {
          studentsIdString.add(students[i].student_id);
        }
        Iterable<int> studentsId = studentsIdString;
        apiMap["student_ids"] = studentsId;
      }
      print(apiMap);
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final post = Post.fromJSON(responseJSON['data']);
          return post;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Post> updateVideoPost(
      int postId,
      int target,
      int classroom_id,
      List<Student> students,
      String content,
      String videoThumbnail,
      String videoUrl) async {
    try {
      String url = BASE_URL + "api/posts/" + postId.toString();
      Map<String, dynamic> apiMap = {
        "content": content,
        "video_thumbnail": videoThumbnail,
        "video_url": videoUrl
      };
      if (target == 0) {
        apiMap["classroom_id"] = json.encode(classroom_id);
      } else {
        List<int> studentsIdString = [];
        for (var i = 0; i < students.length; i++) {
          studentsIdString.add(students[i].student_id);
        }
        Iterable<int> studentsId = studentsIdString;
        apiMap["student_ids"] = studentsId;
      }
      print(apiMap);
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final post = Post.fromJSON(responseJSON['data']);
          return post;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Post> createPost(String target, int classroomId, List<Student> students,
      String content, List<EdTechFile> files) async {
    try {
      String url = BASE_URL + "api/posts";
      Map<String, dynamic> apiMap = {"content": content};
      if (target == CLASS_ROOM) {
        apiMap["classroom_id"] = json.encode(classroomId);
      } else {
        List<int> studentsIdString = [];
        for (var i = 0; i < students.length; i++) {
          studentsIdString.add(students[i].student_id);
        }
        Iterable<int> studentsId = studentsIdString;
        apiMap["student_ids"] = studentsId;
      }
      List<String> filesIDString = [];
      for (var i = 0; i < files.length; i++) {
        filesIDString.add(files[i].file_id);
      }
      Iterable<String> filesId = filesIDString;
      apiMap["files"] = filesId;
      print(apiMap);
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final post = Post.fromJSON(responseJSON['data']);
          return post;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Post> updatePost(int postId, int target, int classroom_id,
      List<Student> students, String content, List<EdTechFile> files) async {
    try {
      String url = BASE_URL + "api/posts/${postId}";
      Map<String, dynamic> apiMap = {"content": content};
      if (target == 0) {
        apiMap["classroom_id"] = json.encode(classroom_id);
      } else {
        List<int> studentsIdString = [];
        for (var i = 0; i < students.length; i++) {
          studentsIdString.add(students[i].student_id);
        }
        Iterable<int> studentsId = studentsIdString;
        apiMap["student_ids"] = studentsId;
      }
      List<String> filesIDString = [];
      for (var i = 0; i < files.length; i++) {
        filesIDString.add(files[i].file_id);
      }
      Iterable<String> filesId = filesIDString;
      apiMap["files"] = filesId;
      apiMap["video_thumbnail"] = '';
      apiMap["video_url"] = '';
      print(apiMap);
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final post = Post.fromJSON(responseJSON['data']);
          return post;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future deletePost(int post_id) async {
    try {
      String url = BASE_URL + "api/posts/${post_id}";
      var Response = await RequestManager().startDeleteRequest(url);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Post>> getListPosts(int classId, int studentId, int lastId,
      bool isStudentMode, bool loadMore) async {
    try {
      String url = "";
      if (isStudentMode) {
        url = BASE_URL +
            "api/posts?size=${Constants.rest_api_size}&student_id=$studentId" +
            (loadMore ? "&last_id=$lastId" : "");
      } else {
        url = BASE_URL +
            "api/posts?size=${Constants.rest_api_size}&classroom_id=$classId" +
            (loadMore ? "&last_id=$lastId" : "");
      }
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listPosts"] as List;
          var listPost =
              responseList.map((item) => Post.fromJSON(item)).toList();
          return listPost;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getPostDetail(
      int postID, Function(Post) onSuccess, Function(String) onError) async {
    try {
      String url = BASE_URL + "api/posts/$postID?has_seen=true";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          onSuccess(Post.fromJSON(responseJSON["data"]));
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future getListComment(int post_id, int page,
      Function(List<Comment>) onSuccess, Function(String) onError) async {
    try {
      String url =
          BASE_URL + "api/posts/${post_id}/comments?page=$page&size=10";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listComments"] as List;
          var listComment =
              responseList.map((item) => Comment.fromJSON(item)).toList();
          if (listComment.length > 0) {
            onSuccess(listComment);
          } else {
            onError("");
          }
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future clickLikePost(int post_id) async {
    try {
      String url = BASE_URL + "api/posts/${post_id}/likes";
      Map<String, String> apiMap = {};
      var Response = await RequestManager().startPutRequest(url, apiMap);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Comment> createComment(int post_id, String content) async {
    try {
      String url = BASE_URL + "api/posts/${post_id}/comments";
      Map<String, String> apiMap = {"content": content};
      var Response = await RequestManager().startPostRequest(url, apiMap);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final comment = Comment.fromJSON(responseJSON['data']);
          return comment;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw (json.decode(Response.body)["message"]);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future deleteComment(int comment_id, Function(String) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/comments/${comment_id}";
      var Response = await RequestManager().startDeleteRequest(url);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          onSuccess("Xoá thành công");
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<Comment> editComment(int comment_id, String content) async {
    try {
      String url = BASE_URL + "api/comments/${comment_id}";
      Map<String, String> apiMap = {"content": content};
      var Response = await RequestManager().startPutRequest(url, apiMap);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final comment = Comment.fromJSON(responseJSON['data']);
          return comment;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw (json.decode(Response.body)["message"]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future updateFCMToken(String fcm) async {
    try {
      String url = BASE_URL + "api/auth/fcm";
      Map<String, String> apiMap = {"fcm_token": fcm};
      var Response = await RequestManager().startPutRequest(url, apiMap);
      print(Response.statusCode);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {}
      } else {
        //
      }
    } catch (e) {
      //
    }
  }

  Future getListNotification(
      int page,
      Function(List<EdTechNotification>) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/notifications?page=$page&size=10";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["listNotifications"] as List;
          var listNotifications = responseList
              .map((item) => EdTechNotification.fromJSON(item))
              .toList();
          onSuccess(listNotifications);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future clickSeenNotification(int notificationId, Function(String) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/notifications/$notificationId/seen";
      Map<String, String> apiMap = {};
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          onSuccess("Thành công");
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<int> getAmountNewNotifications() async {
    try {
      String url = BASE_URL + "api/notifications/count";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return responseJSON['data']['count'];
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> seeAllNotification() async {
    try {
      String url = BASE_URL + "api/notifications/seen-all";
      Map<String, String> apiMap = {};
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return true;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  //----------------------------- CHAT -----------------------------

  Future createChannel(
      String channelName,
      List<int> parents_ids,
      int type,
      String avatar,
      Map<String, dynamic> custom_data,
      Function(String) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/chat/channel";
      Iterable<int> user_ids = parents_ids;
      Map<String, dynamic> apiMap = {
        "channelName": channelName,
        "user_ids": user_ids,
        "type": type,
        "avatar": avatar,
        "custom_data": custom_data
      };
      print(apiMap);
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          onSuccess("Tạo thành công");
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // -------------------------CHECKIN/CHECKOUT------------------------
  Future checkingStudent(
      int studentId,
      String image,
      int classroom_id,
      String status,
      Function(Checking) onSuccess,
      Function(String) onError) async {
    try {
      String url = BASE_URL + "api/checking";
      Map<String, dynamic> apiMap = {
        "student_id": studentId,
        "status": status,
        "classroom_id": classroom_id
      };
      if (image != "") {
        apiMap["image"] = image;
      }
      print(apiMap);
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var checking = Checking.fromJSON(responseJSON['data']);
          onSuccess(checking);
        } else {
          onError(responseJSON['message']);
        }
      } else {
        onError(json.decode(Response.body)["message"]);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<List<Checking>> getCheckingListHistory(
      int studentId, int classroom_id, bool loadMore, int lastId) async {
    try {
      String url = BASE_URL +
          "api/checking?size=${Constants.rest_api_size}&student_id=$studentId&classroom_id=$classroom_id" +
          (loadMore ? "&last_id=$lastId" : "");
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["checking_lists"] as List;
          return responseList.map((item) => Checking.fromJSON(item)).toList();
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw (json.decode(Response.body)["message"]);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // ----------------------------REPORT--------------------------
  Future<ReportCategory> createCategoryReport(
      int classroom_id, String name, String icon, String description) async {
    try {
      String url = BASE_URL + "api/report-types";
      Map<String, String> apiMap = {
        "classroom_id": json.encode(classroom_id),
        "name": name,
        "icon": icon,
        "description": description
      };
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final report = ReportCategory.fromJSON(responseJSON['data']);
          return report;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Report> createReport(int classroom_id, int student_id,
      int report_type_id, String target, String content) async {
    try {
      String url = BASE_URL + "api/reports";
      Map<String, String> apiMap = {
        "report_type_id": json.encode(report_type_id),
        "target": target,
        "content": content,
        "classroom_id": json.encode(classroom_id),
      };
      if (target == STUDENT) {
        apiMap["student_id"] = json.encode(student_id);
      }
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final report = Report.fromJSON(responseJSON['data']);
          return report;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ReportCategory>> getListCategoryReport(
      int classroom_id, String type) async {
    try {
      String url = BASE_URL +
          "api/report-types?classroom_id=${classroom_id}" +
          (type != "" ? "&type=general" : "");
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["reportTypes"] as List;
          var listCategory = responseList
              .map((item) => ReportCategory.fromJSON(item))
              .toList();
          return listCategory;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future editReportCategory(int report_type_id, String content) async {
    try {
      String url = BASE_URL + "api/report-types/${report_type_id}";
      Map<String, String> apiMap = {"name": content, "description": ""};
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future deleteReportCategory(int report_type_id) async {
    try {
      String url = BASE_URL + "api/report-types/${report_type_id}";
      var Response = await RequestManager().startDeleteRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Report>> getListReport(String target, String from, String to,
      int classroom_id, int student_id, bool loadMore, int lastId) async {
    try {
      String url = BASE_URL;
      if (target == CLASS_ROOM) {
        url = BASE_URL +
            "api/reports?size=20&from=$from&to=$to&classroom_id=${classroom_id}" +
            (loadMore ? "&last_id=$lastId" : "");
      } else {
        url = BASE_URL +
            "api/reports?size=20&from=$from&to=$to&classroom_id=${classroom_id}&student_id=${student_id}" +
            (loadMore ? "&last_id=$lastId" : "");
      }
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["reports"] as List;
          var listReport =
              responseList.map((item) => Report.fromJSON(item)).toList();
          return listReport;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future editReport(int report_id, String content) async {
    try {
      String url = BASE_URL + "api/reports/${report_id}";
      Map<String, String> apiMap = {
        "content": content,
      };
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future deleteReport(int reportId) async {
    try {
      String url = BASE_URL + "api/reports/$reportId";
      var Response = await RequestManager().startDeleteRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<String>> getListIconReport() async {
    try {
      String url = BASE_URL + "api/report-icons";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["icons"] as List;
          var listIcons = responseList.map((item) => (item as String)).toList();
          return listIcons;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Story>> getListStory(int student_id, String type) async {
    try {
      String url = BASE_URL + "api/students/${student_id}/stories?type=${type}";
      var Response = await RequestManager().startGetRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          var responseList = responseJSON["data"]["stories"] as List;
          var listStory =
              responseList.map((item) => Story.fromJSON(item)).toList();
          return listStory;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Story> createStory(int student_id, String type, String content) async {
    try {
      String url = BASE_URL + "api/stories";
      Map<String, String> apiMap = {
        "student_id": json.encode(student_id),
        "type": type,
        "content": content,
      };
      var Response = await RequestManager().startPostRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          final story = Story.fromJSON(responseJSON['data']);
          return story;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future deleteStory(int story_id) async {
    try {
      String url = BASE_URL + "api/stories/${story_id}";
      var Response = await RequestManager().startDeleteRequest(url);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future editStory(int story_id, String content) async {
    try {
      String url = BASE_URL + "api/stories/${story_id}";
      Map<String, String> apiMap = {
        "content": content,
      };
      var Response = await RequestManager().startPutRequest(url, apiMap);
      if (Response.statusCode >= 200 && Response.statusCode <= 300) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        if (responseJSON['success'] == true) {
          return;
        } else {
          throw responseJSON['message'];
        }
      } else {
        throw json.decode(Response.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
