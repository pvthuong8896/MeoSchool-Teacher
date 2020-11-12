import 'dart:async';
import 'dart:typed_data';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/repository/index.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostBloc extends Bloc {
  final _user_api = UserAPI();
  final _image_api = ImageAPI();
  List<Post> _listPosts = [];
  int pagePostsLoaded = 1;
  int commentsPageLoaded = 1;

  StreamController _listPostController = new StreamController<String>.broadcast();
  StreamController _postTargetController = new StreamController<String>.broadcast();
  StreamController _clickLikeController = new StreamController<String>.broadcast();
  StreamController _listCommentController = new StreamController<String>.broadcast();
  StreamController _loadMoreCommentsController = new StreamController<String>.broadcast();
  StreamController _clickCommentController = new StreamController<Comment>.broadcast();
  StreamController _uploadImageController = new StreamController<String>.broadcast();

  Stream get listPostController => _listPostController.stream;
  Stream get postTargetController => _postTargetController.stream;
  Stream get clickLikeController => _clickLikeController.stream;
  Stream get listCommentController => _listCommentController.stream;
  Stream get loadMoreCommentsController => _loadMoreCommentsController.stream;
  Stream get clickCommentController => _clickCommentController.stream;
  Stream get uploadImageController => _uploadImageController.stream;

  List<Post> get listPosts => _listPosts;
  Future<Post> createPost(String target, int classroomId, List<Student> students,
      String content, List<EdTechFile> files) async {
    var newPost = await _user_api.createPost(
        target, classroomId, students, content, files);
    this.appendNewPost(newPost);
    return newPost;
  }

  Future<Post> createVideoPost(
      String target,
      int classroomId,
      List<Student> students,
      String content,
      String videoThumbnail,
      String videoUrl) async {
    var newPost = await _user_api.createVideoPost(
        target, classroomId, students, content, videoThumbnail, videoUrl);
    this.appendNewPost(newPost);
    return newPost;
  }

  Future<Post> updatePost(int postId, int target, int classroom_id,
      List<Student> students, String content, List<EdTechFile> files) async {
    var newPost = await _user_api.updatePost(
        postId, target, classroom_id, students, content, files);
    for (var i = 0; i < _listPosts.length; i++) {
      if (_listPosts[i].post_id == newPost.post_id) {
        _listPosts[i] = newPost;
      }
    }
    _listPostController.sink.add(DONE);
    return newPost;
  }

  Future<Post> updateVideoPost(int postId, int target, int classroom_id,
      List<Student> students, String content, String videoThumbnail,
      String videoUrl) async {
    var newPost = await _user_api.updateVideoPost(
        postId,
        target,
        classroom_id,
        students,
        content,
        videoThumbnail,
        videoUrl);
    for (var i = 0; i < _listPosts.length; i++) {
      if (_listPosts[i].post_id == newPost.post_id) {
        _listPosts[i] = newPost;
      }
    }
    _listPostController.sink.add(DONE);
    return newPost;
  }

  Future deletePost(int post_id) async {
    try {
      await _user_api.deletePost(post_id);
      for (var i = 0; i <= _listPosts.length; i++) {
        if(_listPosts[i].post_id == post_id) {
          _listPosts.removeAt(i);
          break;
        }
      }
      _listPostController.sink.add(DELETE);
    } catch (e) {
    }
  }

  void uploadImageStates() {
    _uploadImageController.sink.add(DONE);
  }

  void getPostDetail(int postId) {
    _user_api.getPostDetail(postId, (_) {}, (_) {});
  }

  Future getListPostsForClass() async {
    try {
      _listPosts = [];
      _listPostController.sink.add(LOADING);
      final result = await _user_api.getListPosts(
          DataSingleton.instance.classSelected.classroom_id,
          -1,
          -1,
          false,
          false);
      _listPosts = result;
      _listPostController.sink.add(DONE);
    } catch (e) {
      _listPosts = [];
      _listPostController.sink.add(EMPTY);
      throw e.toString();
    }
  }

  Future loadMorePostsForClass() async {
    try {
      _listPostController.sink.add(LOADING);
      final result = await _user_api.getListPosts(
          DataSingleton.instance.classSelected.classroom_id,
          -1,
          listPosts.last.post_id,
          false,
          true);
      _listPosts.addAll(result);
      _listPostController.sink.add(DONE);
    } catch (e) {
      _listPostController.sink.add(EMPTY);
      throw e.toString();
    }
  }

  Future getListPostsForStudent(int studentId) async {
    try {
      _listPosts = [];
      _listPostController.sink.add(LOADING);
      final result = await _user_api.getListPosts(-1, studentId, -1, true, false);
      _listPosts = result;
      _listPostController.sink.add(DONE);
    } catch (e) {
      _listPosts = [];
      _listPostController.sink.add(EMPTY);
      throw e.toString();
    }
  }

  Future loadMorePostsForStudent(int studentId) async {
    try {
      _listPostController.sink.add(LOADING);
      final result = await _user_api.getListPosts(
          -1,
          studentId,
          listPosts.last.post_id,
          true,
          true);
      _listPosts.addAll(result);
      _listPostController.sink.add(DONE);
    } catch (e) {
      _listPostController.sink.add(EMPTY);
      throw e.toString();
    }
  }

  void getListComment(
      int postId, Function(List<Comment>) onSuccess, Function(String) onError) {
    _listCommentController.sink.add(LOADING);
    _user_api.getListComment(postId, 1, (results) {
      commentsPageLoaded = 1;
      _listCommentController.sink.add(DONE);
      onSuccess(results);
    }, (message) {
      _listCommentController.sink.add(EMPTY);
      onError("Lỗi tải bình luận");
    });
  }

  void loadMoreComments(
      int postId, Function(List<Comment>) onSuccess, Function(String) onError) {
    commentsPageLoaded += 1;
    _loadMoreCommentsController.sink.add(LOADING);
    _user_api.getListComment(postId, commentsPageLoaded, (results) {
      onSuccess(results);
      _loadMoreCommentsController.sink.add(DONE);
      _listCommentController.sink.add(DONE);
    }, (message) {
      commentsPageLoaded -= 1;
      _loadMoreCommentsController.sink.add(EMPTY);
    });
  }

  Future<Comment> clickComment(int postId, String content) async {
    var comment = await _user_api.createComment(postId, content);
    for (var i = 0; i < _listPosts.length; i++) {
      if (_listPosts[i].post_id == postId) {
        _listPosts[i].total_comments = _listPosts[i].total_comments + 1;
        break;
      }
    }
    _clickLikeController.sink.add("");
    return comment;
  }

  void clickDeleteComment(
      int comment_id, Function(String) onSuccess, Function(String) onError) {
    _user_api.deleteComment(comment_id, (result) {
      _listCommentController.sink.add(DONE);
      onSuccess("Xoá bình luận thành công");
    }, (message) {
      _listCommentController.sink.add(DONE);
      onError("Xoá bình luận lỗi");
    });
  }

  Future<Comment> clickEditComment(int comment_id, String content) async {
    var comment = await _user_api.editComment(comment_id, content);
    return comment;
  }

  Future clickLikeButton(int post_id) async {
    await _user_api.clickLikePost(post_id);
    for (var i = 0; i < _listPosts.length; i++) {
      if (_listPosts[i].post_id == post_id) {
        if (_listPosts[i].liked) {
          _listPosts[i].total_likes = _listPosts[i].total_likes - 1;
        } else {
          _listPosts[i].total_likes = _listPosts[i].total_likes + 1;
        }
        _listPosts[i].liked = !_listPosts[i].liked;
        break;
      }
    }
    _clickLikeController.sink.add("");
  }

  void handleTargetStudent() {
    _postTargetController.sink.add("");
  }

  Future<EdTechFile> uploadImageWithBytes(Uint8List data) async {
    var file = await _image_api.uploadImageWithBytes(data);
    return file;
  }

  Future<EdTechFile> uploadImage(File imageFile) async {
    var file = await _image_api.postUploadImg(imageFile);
    return file;
  }

  Future<List<EdTechFile>> uploadMulImage(List<Asset> assets) async {
    var file = await _image_api.uploadMultiImage(assets);
    return file;
  }

  void appendNewPost(Post newPost) {
    _listPosts.insert(0, newPost);
    _listPostController.sink.add(DONE);
  }

  void dispose() {
    _listPostController.close();
    _postTargetController.close();
    _clickLikeController.close();
    _listCommentController.close();
    _loadMoreCommentsController.close();
    _clickCommentController.close();
    _uploadImageController.close();
  }
}
