import 'dart:async';
import 'package:edtechteachersapp/src/blocs/bloc.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/repository/index.dart';

class NotificationBloc extends Bloc {
  final _user_api = UserAPI();
  int pageLoaded = 1;

  List<EdTechNotification> _listNotifications = [];
  StreamController _numberOfNotificationController = new StreamController<String>.broadcast();
  StreamController _listNotificationController = new StreamController<String>.broadcast();
  StreamController _loadMoreNotificationsController = new StreamController<String>.broadcast();

  Stream get numberOfNotificationController => _numberOfNotificationController.stream;
  Stream get listNotificationController => _listNotificationController.stream;
  Stream get loadMoreNotificationsController => _loadMoreNotificationsController.stream;

  List<EdTechNotification> get listNotifications => _listNotifications;

  void getListNotifications() {
    _listNotificationController.sink.add(LOADING);
    _user_api.getListNotification(1, (result){
      pageLoaded = 1;
      if (result.length > 0) {
        _listNotifications = result;
        _listNotificationController.sink.add(DONE);
      } else {
        _listNotifications = [];
        _listNotificationController.sink.add(EMPTY);
      }  
    }, (message) {
      _listNotifications = [];
      _listNotificationController.sink.add(EMPTY);
    });
  }

  void loadMoreNotifications() {
    pageLoaded += 1;
    _loadMoreNotificationsController.sink.add(LOADING);
    _user_api.getListNotification(pageLoaded, (result){
      if (result.length > 0) {
        _listNotifications += result;
        _loadMoreNotificationsController.sink.add(DONE);
        _listNotificationController.sink.add(DONE);
      } else {
        pageLoaded -= 1;
        _loadMoreNotificationsController.sink.add(EMPTY);
      }  
    }, (message) {pageLoaded -= 1;});
  }

  void clickSeenNotification(int index, int notificationId) {
    _user_api.clickSeenNotification(notificationId, (_){
      _listNotifications[index].has_seen = true;
      _listNotificationController.sink.add(DONE);
      DataSingleton.instance.numberOfNoti = 0;
      _numberOfNotificationController.sink.add("");
    }, (_){});
  }

  void getAmountNewNotifications() async {
    try {
      final result = await _user_api.getAmountNewNotifications();
      DataSingleton.instance.numberOfNoti = result;
      _numberOfNotificationController.sink.add(DONE);
    } catch (_) {

    }
  }

  void seeAllNotification() async {
    try {
      await _user_api.seeAllNotification();
    } catch (_) {

    }
  }

  void getPostDetail(int post_id, Function(Post) onSuccess, Function(String) onError) {
    _user_api.getPostDetail(post_id, onSuccess, onError);
  }

  void dispose() {
    _listNotificationController.close();
    _loadMoreNotificationsController.close();
    _numberOfNotificationController.close();
  }
}