import 'dart:async';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/validators/login_validation.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/repository/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/repository/user_repository.dart';

class LoginBloc extends Bloc {
  // ignore: non_constant_identifier_names
  final UserAPI _user_api = UserAPI();

  StreamController _checkLoggedInController = new StreamController<String>.broadcast();
  StreamController _schoolCodeController = new StreamController<String>.broadcast();
  StreamController _usernameController = new StreamController<String>.broadcast();
  StreamController _passwordController = new StreamController<String>.broadcast();

  Stream get checkLoggedInStream => _checkLoggedInController.stream;
  Stream get schoolCodeStream => _schoolCodeController.stream;
  Stream get usernameStream => _usernameController.stream;
  Stream get passwordStream => _passwordController.stream;

  void checkLoggedIn() async {
    try {
      _checkLoggedInController.sink.add(LOADING);
      User userModel = await UserRepository().getUser();
      if (userModel.accessToken != null) {
        DataSingleton.instance.edUser = userModel;
        loginChat(userModel.chatId, userModel.chatToken);
        _checkLoggedInController.sink.add(DONE);
      } else {
        _checkLoggedInController.sink.add(EMPTY);
      }
    } catch(_) {
      _checkLoggedInController.sink.add(EMPTY);
    }
  }

  void loginChat(String userId, String token) async {
    await BlaChatSdk.instance.initBlaChatSDK(userId, token);
  }

  bool isValidSchoolCode(String schoolCode) {
    if(!LoginValidation.isValidSchoolId(schoolCode)) {
      _schoolCodeController.sink.addError("Mã trường không hợp lệ");
      return false;
    }
    _schoolCodeController.sink.add("");
    return true;
  }

  bool isValidUsername(String username) {
    if(!LoginValidation.isValidUsername(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }
    _usernameController.sink.add("");
    return true;
  }

  bool isValidPassword(String password) {
    if(!LoginValidation.isValidPassword(password)) {
      _passwordController.sink.addError("Mật khẩu không chính xác");
      return false;
    }
    _passwordController.sink.add("");

    return true;
  }

  bool isValidInfo(String schoolCode, String username, String password) {
    if(!LoginValidation.isValidSchoolId(schoolCode)) {
      return false;
    }
    if(!LoginValidation.isValidUsername(username)) {
      return false;
    }
    if(!LoginValidation.isValidPassword(password)) {
      return false;
    }
    return true;
  }

  Future<User> login(String schoolCode, String username, String password) async {
    return await _user_api.login(schoolCode, username, password);
  }

  void logout() async {
    _user_api.logout();
    await BlaChatSdk.instance.logoutBlaChatSDK();
  }

  void getChatToken(Function(String, String) onSuccess, Function(String) onError) {
    _user_api.getChatToken(onSuccess, onError);
  }

  void dispose() {
    _checkLoggedInController.close();
    _schoolCodeController.close();
    _usernameController.close();
    _passwordController.close();
  }

}