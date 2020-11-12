import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/global/circle_avatar_widget.dart';
import 'package:edtechteachersapp/src/global/widgets/notification/notification_widget.dart';
import 'package:edtechteachersapp/src/global/widgets/post/index.dart';
import 'package:edtechteachersapp/src/resources/checking/checking_for_student.dart';
import 'package:edtechteachersapp/src/resources/post/components/create_feed_action.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:edtechteachersapp/src/resources/report/list_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/custom_dialog.dart'
    as customDialog;
import 'package:edtechteachersapp/src/resources/student/index.dart';
import 'package:edtechteachersapp/src/resources/post/components/list_user_action.dart';

const inputHeight = 36.0;
BuildContext inviteParentDialogContext;
BuildContext updateProfileStudentDialogContext;

class DetailStudent extends StatefulWidget {
  final Student student;
  DetailStudent({Key key, @required this.student}) : super(key: key);

  @override
  _DetailStudentState createState() => _DetailStudentState();
}

class _DetailStudentState extends State<DetailStudent> {
  Student student;
  PostBloc postBloc;
  TeacherBloc teacherBloc;
  NotificationBloc notificationBloc;
  ScrollController _scrollPostsController;
  List<UserAction> actions = [];
  var _loadingData = true;
  var _loadMoreData = false;

  @override
  void initState() {
    super.initState();
    student = widget.student;
    postBloc = BlocProvider.of<PostBloc>(context);
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    getListPostsForStudent(false);
    _scrollPostsController = ScrollController();
    _scrollPostsController.addListener(_scrollPostsListener);
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
                  return CheckingForStudent(student: this.widget.student);
                }))
              }),
      UserAction(
          'assets/img/icons/report.svg',
          "Báo cáo",
          () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ListReportScreen(student: student);
                }))
              }),
      UserAction('assets/img/icons/invite-parents.svg', "Mời phụ huynh",
          () => {inviteParentDialog(context)}),
      UserAction(
          'assets/img/icons/story.svg',
          "Tiểu sử",
          () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StoryStudentScreen(
                    student: student,
                  );
                }))
              }),
      UserAction('assets/img/icons/infomation.svg', "Thông tin",
          () => {updateProfileStudentDialog(context)}),
    ];
  }

  _scrollPostsListener() {
    if (_scrollPostsController.offset >=
            _scrollPostsController.position.maxScrollExtent &&
        !_scrollPostsController.position.outOfRange) {
      getListPostsForStudent(true);
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
              onPressed: () => Navigator.pop(context),
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
                  student.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: EdTechColors.textBlackColor,
                      fontWeight: EdTechFontWeight.semibold),
                ),
              ),
              background: CircleAvatarWidget(size: 85, avatar: student.avatar),
            ),
          ),
          SliverToBoxAdapter(
            child: ListUserAction(actions: actions),
          ),
          SliverToBoxAdapter(
            child: CreateFeedAction(
                title: "Hôm nay ở lớp có gì mới? 🎉🎉",
                onPress: () {
                  createNewPostForStudent();
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
          return _buildListPost(postBloc.listPosts);
        });
  }

  _buildListPost(List<Post> listPosts) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return PostWidget(
            postItem: postBloc.listPosts[index],
            postBloc: postBloc,
            context: context);
      }, childCount: postBloc.listPosts.length),
    );
  }

  void createNewPostForStudent() {
    for (var i = 0; i < DataSingleton.instance.listStudents.length; i++) {
      if (DataSingleton.instance.listStudents[i].student_id ==
          student.student_id) {
        DataSingleton.instance.listStudents[i].isSelected = true;
        break;
      }
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CreatePostScreen(createForAStudent: true);
    }));
  }

  inviteParentDialog(context) {
    inviteParentDialogContext = context;
    globalSize = EdTechAppStyles(context);

    Widget inviteDialog =
        customDialog.Dialog(child: InviteParent(student: student));
    // SHOW DIALOG
    showDialog(
        context: context, builder: (BuildContext context) => inviteDialog);
  }

  updateProfileStudentDialog(context) async {
    updateProfileStudentDialogContext = context;
    globalSize = EdTechAppStyles(context);
    Widget updateProfile =
        customDialog.Dialog(child: UpdateProfileStudent(student: student));
    final newStudentData = await showDialog(
        context: context, builder: (BuildContext context) => updateProfile);
    if (newStudentData != null) {
      setState(() => student = newStudentData);
      teacherBloc.updateProfileSuccessful();
    }
  }

  void getListPostsForStudent(bool loadMore) async {
    try {
      if (loadMore) {
        _loadMoreData = true;
        await postBloc.loadMorePostsForStudent(student.student_id);
        _loadMoreData = false;
      } else {
        _loadingData = true;
        await postBloc.getListPostsForStudent(student.student_id);
        _loadingData = false;
      }
    } catch (e) {
      _loadingData = false;
      _loadMoreData = false;
    }
  }
}
