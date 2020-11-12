import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/global/circle_avatar_widget.dart';
import 'package:edtechteachersapp/src/global/widgets/notification/notification_widget.dart';
import 'package:edtechteachersapp/src/global/widgets/post/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/checking/checkin_for_class.dart';
import 'package:edtechteachersapp/src/resources/connect_parents/connect_parents_screen.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:edtechteachersapp/src/resources/report/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/resources/post/components/list_user_action.dart';
import 'components/create_feed_action.dart';

class ListPostScreen extends StatefulWidget {
  ListPostScreen({Key key}) : super(key: key);

  @override
  _ListPostScreenState createState() => _ListPostScreenState();
}

class _ListPostScreenState extends State<ListPostScreen> {
  PostBloc postBloc;
  NotificationBloc notificationBloc;
  ScrollController _scrollPostsController;
  ClassRoom classroom = DataSingleton.instance.classSelected;
  List<UserAction> actions = [];
  var _loadingData = true;
  var _loadMoreData = false;

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<PostBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _scrollPostsController = ScrollController();
    _scrollPostsController.addListener(_scrollPostsListener);
    getListPostsForClass(false);
    initListUserAction();
  }

  initListUserAction() {
    actions = [
      UserAction(
          'assets/img/icons/checking.svg',
          "Điểm danh",
          () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CheckinForClassScreen();
                }))
              }),
      UserAction(
          'assets/img/icons/report.svg',
          "Báo cáo",
          () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ListReportScreen();
                }))
              }),
      UserAction(
          'assets/img/icons/invite-parents.svg',
          "Mời phụ huynh",
          () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ConnectParentsScreen();
                }))
              }),
    ];
  }

  _scrollPostsListener() {
    if (_scrollPostsController.offset >=
            _scrollPostsController.position.maxScrollExtent &&
        !_scrollPostsController.position.outOfRange) {
      getListPostsForClass(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: EdTechColors.backgroundColor,
      child: CustomScrollView(
        controller: _scrollPostsController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: EdTechColors.backgroundColor,
            brightness: Brightness.light,
            elevation: 0,
            expandedHeight: 180,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: onPressBack,
            ),
            actions: [
              StreamBuilder(
                  stream: notificationBloc.numberOfNotificationController,
                  builder: (context, snapshot) {
                    return NotificationWidget().buildNotificationWidget(
                        context, EdTechColors.textBlackColor);
                  })
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                child: Text(
                  classroom.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: EdTechColors.textBlackColor,
                      fontWeight: EdTechFontWeight.semibold),
                ),
              ),
              background: CircleAvatarWidget(size: 85, avatar: classroom.icon),
            ),
          ),
          SliverToBoxAdapter(
            child: ListUserAction(actions: actions),
          ),
          SliverToBoxAdapter(
            child: CreateFeedAction(
                title: "Hôm nay ở lớp có gì mới? 🎉🎉",
                onPress: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CreatePostScreen(
                      createForAStudent: false,
                    );
                  }));
                }),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Bài đăng",
                style: TextStyle(
                  fontSize: EdTechFontSizes.title,
                  fontWeight: EdTechFontWeight.bold,
                  color: EdTechColors.textBlackColor,
                ),
              ),
            ),
          ),
          getBody(),
          SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: postBloc.listPostController,
                  builder: (context, snapshot) {
                    if (_loadingData) {
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: LoadingDataView.showLoadingDataView(
                              context, "Đang tải..."));
                    }
                    if (_loadMoreData) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: edTechLoaderWidget(20.0, 20.0),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                          postBloc.listPosts.length != 0
                              ? "Bạn đã xem hết tất cả bài đăng 👏🏻"
                              : "Chưa có bài đăng nào 😺",
                          style: TextStyle(
                              fontSize: EdTechFontSizes.small,
                              color: Colors.grey[600],
                              fontWeight: EdTechFontWeight.normal)),
                    );
                  }))
        ],
      ),
    ));
  }

  getBody() {
    return StreamBuilder(
        stream: postBloc.listPostController,
        builder: (context, snapshot) {
          return _buildListPost();
        });
  }

  _buildListPost() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return PostWidget(
            postItem: postBloc.listPosts[index],
            postBloc: postBloc,
            context: context);
      }, childCount: postBloc.listPosts.length),
    );
  }

  onPressBack() {
    Navigator.of(context).pop();
  }

  void getListPostsForClass(bool loadMore) async {
    try {
      if (loadMore) {
        _loadMoreData = true;
        await postBloc.loadMorePostsForClass();
        _loadMoreData = false;
      } else {
        _loadingData = true;
        await postBloc.getListPostsForClass();
        _loadingData = false;
      }
    } catch (_) {
      _loadingData = false;
      _loadMoreData = false;
    }
  }
}
