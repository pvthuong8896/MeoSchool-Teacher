import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edtechteachersapp/src/models/index.dart';

class UserRepository {
  UserRepository();

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    prefs.remove('user_id');
    prefs.remove('school_id');
    prefs.remove('name');
    prefs.remove('avatar');
    prefs.remove('dob');
    prefs.remove('email');
    prefs.remove('phone_number');
    prefs.remove('chatToken');
    prefs.remove('chatId');
  }

  Future<void> saveDataUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', user.accessToken);
    prefs.setString('refreshToken', user.refreshToken);
    prefs.setInt('user_id', user.user_id);
    prefs.setInt('school_id', user.school_id);
    prefs.setString("name", user.name);
    prefs.setString("avatar", user.avatar);
    prefs.setString("dob", user.dob);
    prefs.setString('email', user.email);
    prefs.setString('phone_number', user.phone_number);
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("accessToken");
    final refreshToken = prefs.getString("refreshToken");
    final userId = prefs.getInt("user_id");
    final schoolId = prefs.getInt("school_id");
    final name = prefs.getString("name");
    final avatar = prefs.getString("avatar");
    final dob = prefs.getString("dob");
    final email = prefs.getString("email");
    final phoneNumber = prefs.getString("phone_number");
    final chatToken = prefs.getString("chatToken");
    final chatId = prefs.getString("chatId");

    return User(
        user_id: userId,
        school_id: schoolId,
        name: name,
        avatar: avatar,
        dob: dob,
        email: email,
        phone_number: phoneNumber,
        accessToken: accessToken,
        refreshToken: refreshToken,
        chatToken: chatToken,
        chatId: chatId);
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", accessToken);
    prefs.setString("refreshToken", refreshToken);
  }

  Future<void> saveChatDataUser(String chatToken, String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("chatToken", chatToken);
    prefs.setString("chatId", chatId);
  }

  Future<String> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
