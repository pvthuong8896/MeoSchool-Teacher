import 'dart:async';
import 'package:edtechteachersapp/src/models/edtech_file.dart';
import 'package:edtechteachersapp/src/repository/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'dart:io';

class ChatBloc extends Bloc {
  final _user_api = UserAPI();
  final _image_api = ImageAPI();

  StreamController _onNewMessageController = new StreamController<String>.broadcast();
  StreamController _onNewChannelController = new StreamController<String>.broadcast();
  StreamController _onShowStickerController = new StreamController<String>.broadcast();
  StreamController _onTypingController = new StreamController<String>.broadcast();

  Stream get onNewMessageController => _onNewMessageController.stream;
  Stream get onNewChannelController => _onNewChannelController.stream;
  Stream get onShowStickerController => _onShowStickerController.stream;
  Stream get onTypingController => _onTypingController.stream;

  bool onNewMessageListener() {
    _onNewMessageController.sink.add("");
    return true;
  }

  bool onNewChannelListener() {
    _onNewChannelController.sink.add("");
    return true;
  }

  bool onShowStickerListener() {
    _onShowStickerController.sink.add("");
    return true;
  }

  bool onTypingListener() {
    _onTypingController.sink.add("");
    return true;
  }

  void createChannel(String channelName, List<int> parents_ids, int type, String avatar, Map<String, dynamic> custom_data, Function(String) onSuccess, Function(String) onError) {
    _user_api.createChannel(channelName, parents_ids, type, avatar, custom_data, onSuccess, onError);
  }

  Future<EdTechFile> uploadImage(File imageFile) async {
    var file = await _image_api.postUploadImg(imageFile);
    return file;
  }

  void dispose() {
    _onNewMessageController.close();
    _onNewChannelController.close();
    _onShowStickerController.close();
    _onTypingController.close();
  }
}