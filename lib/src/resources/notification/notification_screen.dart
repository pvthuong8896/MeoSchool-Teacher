import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc notificationBloc;
  ScrollController _scrollNotificationsController;
  List<EdTechNotification> listNotifications = [];

  @override
  void initState() {
    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    notificationBloc.getListNotifications();
    notificationBloc.seeAllNotification();
    _scrollNotificationsController = ScrollController();
    _scrollNotificationsController.addListener(_scrollPostsListener);
  }

  _scrollPostsListener() {
    if (_scrollNotificationsController.offset >=
            _scrollNotificationsController.position.maxScrollExtent &&
        !_scrollNotificationsController.position.outOfRange) {
      notificationBloc.loadMoreNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          elevation: 0,
          brightness: Brightness.light,
          centerTitle: false,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Thông báo",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: EdTechColors.textBlackColor,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: getBody());
  }

  Widget getBody() => StreamBuilder(
      stream: notificationBloc.listNotificationController,
      builder: (context, snapshot) {
        if (snapshot.data == LOADING) {
          return LoadingDataView.showLoadingDataView(context, "Đang tải...");
        }
        if (snapshot.data == EMPTY) {
          return NodataView.showNodataView(context, "Chưa có thông báo nào.");
        }
        if (snapshot.data == DONE) {
          listNotifications = notificationBloc.listNotifications;
          return buildListNotification();
        }
        return LoadingDataView.showLoadingDataView(context, "Đang tải...");
      });

  Widget buildListNotification() {
    return ListView.builder(
        controller: _scrollNotificationsController,
        itemCount: listNotifications.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index != listNotifications.length) {
            return InkWell(
                onTap: () {
                  print('noti clicked');
                  LoadingDialog.showLoadingDialog(context, "Đang tải...");
                  if (!listNotifications[index].has_seen) {
                    notificationBloc.clickSeenNotification(
                        index, listNotifications[index].notification_id);
                  }
                  if (listNotifications[index].noti_type == 'post') {
                    notificationBloc.getPostDetail(
                        listNotifications[index].target_id, (Post thisPost) {
                      LoadingDialog.hideLoadingDialog(context);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PostDetailScreen(post: thisPost);
                      }));
                    }, (message) {
                      LoadingDialog.hideLoadingDialog(context);
                      ToastMessage.showToastMessage(context, message);
                    });
                  } else {
                    print(listNotifications[index].target_id);
                  }
                },
                child: notificationWidget(listNotifications[index]));
          }
          return StreamBuilder(
            stream: notificationBloc.loadMoreNotificationsController,
            builder: (context, snapshot) {
              if (snapshot.data == DONE) {
                listNotifications = notificationBloc.listNotifications;
              } else if (snapshot.data == EMPTY) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text("Bạn đã xem hết tất cả thông báo 🤗",
                        style: TextStyle(
                            fontSize: EdTechFontSizes.small,
                            color: Colors.grey[600],
                            fontWeight: EdTechFontWeight.normal)),
                    SizedBox(height: 10.0),
                  ],
                );
              } else if (snapshot.data == LOADING) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    edTechLoaderWidget(20.0, 20.0),
                    SizedBox(height: 10.0),
                  ],
                );
              }
              return Container();
            },
          );
        });
  }

  Widget notificationWidget(EdTechNotification notification) {
    return Container(
      color:
          notification.has_seen ? Colors.transparent : EdTechColors.notReadBlue,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/img/avatar_default.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          notification.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            color: EdTechColors.textBlackColor,
                            fontWeight: EdTechFontWeight.semibold,
                          ),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          EdTechConvertData.timeAgoSinceDate(
                              notification.created_at),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: EdTechFontSizes.small,
                            color: EdTechColors.textColor,
                            fontWeight: EdTechFontWeight.normal,
                          ),
                        ),
                      ]))),
        ],
      ),
    );
  }
}
