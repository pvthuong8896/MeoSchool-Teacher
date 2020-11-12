import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/notification/notification_widget.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/repository/index.dart';
import 'package:edtechteachersapp/src/repository/user_repository.dart';
import 'package:edtechteachersapp/src/resources/home/components/list_classroom.dart';
import 'package:edtechteachersapp/src/resources/login/index.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:edtechteachersapp/src/global/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/resources/drawer/drawer.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/resources/sliver/sliver_appbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepository _userRepository = UserRepository();
  TeacherBloc teacherBloc;
  LoginBloc loginBloc;
  NotificationBloc notificationBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer _timer;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    teacherBloc.getListClassRoom();
    notificationBloc.getAmountNewNotifications();
    firebaseCloudMessaging_Listeners();
    observerNotificationCenter();
    startTimer();
  }

  @override
  void dispose() {
    DartNotificationCenter.unsubscribe(observer: this, channel: CHANNEL_NAME);
    DartNotificationCenter.unregisterChannel(channel: CHANNEL_NAME);
    _timer.cancel();
    super.dispose();
  }

  void observerNotificationCenter() {
    DartNotificationCenter.registerChannel(channel: CHANNEL_NAME);
    DartNotificationCenter.subscribe(
      channel: CHANNEL_NAME,
      observer: this,
      onNotification: (_) {
        _userRepository.signOut();
        loginBloc.logout();
        DataSingleton.instance.edUser = null;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: teacherBloc.updateProfileTeacherSuccess,
        builder: (context, snapshot) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: EdTechColors.mainColor,
              elevation: 0,
              actions: [
                StreamBuilder(
                    stream: notificationBloc.numberOfNotificationController,
                    builder: (context, snapshot) {
                      return NotificationWidget().buildNotificationWidget(
                          context, EdTechColors.textWhiteColor);
                    })
              ],
              leading: IconButton(
                icon: Icon(Icons.sort,
                    size: EdTechIconSizes.medium,
                    color: EdTechColors.textWhiteColor),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Sliver().buildSliverAppBar(
                    "Lớp học",
                    EdTechColors.mainColor,
                    TextStyle(
                        fontSize: EdTechFontSizes.big,
                        fontWeight: EdTechFontWeight.semibold,
                        color: EdTechColors.textWhiteColor)),
              ),
            ),
            drawer: new Drawer(
              child: DrawerView(
                  userRepository: _userRepository, loginBloc: loginBloc),
            ),
            body: getBody()));
  }

  getBody() => StreamBuilder(
      stream: teacherBloc.listClassRoomController,
      builder: (context, snapshot) {
        if (snapshot.data == LOADING) {
          return LoadingDataView.showLoadingDataView(context, "Đang tải...");
        }
        if (snapshot.data == EMPTY) {
          return NodataView.showNodataView(
              context, "Chưa có lớp học nào được tạo.");
        }
        if (snapshot.data == DONE) {
          return ListClassRoom(listClassRoom: teacherBloc.listClassRoom);
        }
        return Container();
      });

  void startTimer() {
    _timer = new Timer.periodic(Duration(seconds: 20), (timer) {
      notificationBloc.getAmountNewNotifications();
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print('fcm token $token');
      UserAPI().updateFCMToken(token);
      updateFCMForChatSDK(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        openApp(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        openApp(message);
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void updateFCMForChatSDK(String fcmToken) async {
    await BlaChatSdk.instance.updateFCMToken(fcmToken);
  }

  void openApp(message) {
    LoadingDialog.showLoadingDialog(context, "Đang tải...");
    if (message['data']['noti_type'] == 'post') {
      UserAPI().getPostDetail(int.parse(message['data']['target_id']),
          (Post thisPost) {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PostDetailScreen(post: thisPost);
        }));
      }, (message) {
        LoadingDialog.hideLoadingDialog(context);
        ToastMessage.showToastMessage(context, message);
      });
    } else if (message['data']['noti_type'] == 'news') {
      _launchInWebViewWithJavaScript(
          '${Constants.domain}api/news/${message['data']['target_id']}/view');
    } else {
      LoadingDialog.hideLoadingDialog(context);
    }
  }

  Future<void> _launchInWebViewWithJavaScript(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
      LoadingDialog.hideLoadingDialog(context);
    } else {
      throw 'Could not launch $url';
    }
  }
}
