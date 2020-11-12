import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/notification/notification_widget.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/checking/checking_for_student.dart';
import 'package:edtechteachersapp/src/resources/notification/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckinForClassScreen extends StatefulWidget {
  CheckinForClassScreen({Key key}) : super(key: key);

  @override
  _CheckinForClassScreenState createState() => _CheckinForClassScreenState();
}

class _CheckinForClassScreenState extends State<CheckinForClassScreen> {
  TeacherBloc teacherBloc;
  NotificationBloc notificationBloc;
  List<Student> listStudents = [];

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    listStudents = DataSingleton.instance.listStudents;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: EdTechColors.textBlackColor,
                size: EdTechIconSizes.medium),
            onPressed: backToHome,
          ),
          actions: [
            StreamBuilder(
                stream: notificationBloc.numberOfNotificationController,
                builder: (context, snapshot) {
                  return NotificationWidget().buildNotificationWidget(context, EdTechColors.textBlackColor);
                })
          ],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              DataSingleton.instance.classSelected.name,
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        body: getBody());
  }

  Widget getBody() {
    return Container(
      color: EdTechColors.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: _buildListStudent(),
    );
  }

  Widget _buildListStudent() {
    return StreamBuilder(
      stream: teacherBloc.createCheckingController,
      builder: (context, snapshot) => ListView.builder(
        itemCount: listStudents.length,
        itemBuilder: (BuildContext context, int index) {
          return _checkinWidget(listStudents[index]);
        }),
    );
  }

  Widget _checkinWidget(Student student) {
    var size = 69.0;
    return GestureDetector(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return CheckingForStudent(student: student);
            })),
        child: Container(
          color: EdTechColors.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(size),
                          child: !(student.avatar == null ||
                                  student.avatar.isEmpty)
                              ? Image.network(
                                  student.avatar,
                                  height: size,
                                  width: size,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/img/avatar_default.png',
                                  height: size,
                                  width: size,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: EdTechAppStyles(context).width - 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.simple,
                                      fontWeight: EdTechFontWeight.semibold,
                                      color: EdTechColors.textBlackColor)),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        (EdTechAppStyles(context).width - 150) /
                                            2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if(!(student.checking.checkin != null && student.checking.checkin)) {
                                              checkingForStudent(
                                                  student.student_id,
                                                  "",
                                                  DataSingleton.instance.classSelected.classroom_id,
                                                  CHECKIN);
                                            }
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("đến",
                                                  style: new TextStyle(
                                                      fontSize: EdTechFontSizes
                                                          .normal,
                                                      fontWeight:
                                                          EdTechFontWeight
                                                              .semibold,
                                                      color: EdTechColors
                                                          .greenColor)),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 17,
                                                      height: 17,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: EdTechColors
                                                                .textColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                      ),
                                                    ),
                                                    student.checking.checkin !=
                                                                null &&
                                                            student.checking
                                                                .checkin
                                                        ? Positioned(
                                                            left: 3,
                                                            bottom: 3,
                                                            child: Icon(
                                                                Icons.check,
                                                                color: EdTechColors
                                                                    .textColor))
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                            student.checking.checkin != null &&
                                                    student.checking.checkin
                                                ? EdTechConvertData.convertTime(
                                                    student
                                                        .checking.checkin_time)
                                                : "_ _ _ _ _",
                                            style: new TextStyle(
                                                fontSize: EdTechFontSizes.small,
                                                fontWeight:
                                                    EdTechFontWeight.normal,
                                                color: EdTechColors.textColor)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if(!(student.checking.checkout != null && student.checking.checkout)) {
                                              checkingForStudent(
                                                  student.student_id,
                                                  "",
                                                  DataSingleton.instance.classSelected.classroom_id,
                                                  CHECKOUT);
                                            }
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("về",
                                                  style: new TextStyle(
                                                      fontSize: EdTechFontSizes
                                                          .normal,
                                                      fontWeight:
                                                          EdTechFontWeight
                                                              .semibold,
                                                      color: EdTechColors
                                                          .redColor)),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 17,
                                                      height: 17,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: EdTechColors
                                                                .textColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                      ),
                                                    ),
                                                    student.checking.checkout !=
                                                                null &&
                                                            student.checking
                                                                .checkout
                                                        ? Positioned(
                                                            left: 3,
                                                            bottom: 3,
                                                            child: Icon(
                                                                Icons.check,
                                                                color: EdTechColors
                                                                    .textColor))
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                            student.checking.checkout != null &&
                                                    student.checking.checkout
                                                ? EdTechConvertData.convertTime(
                                                    student
                                                        .checking.checkout_time)
                                                : "_ _ _ _ _",
                                            style: new TextStyle(
                                                fontSize: EdTechFontSizes.small,
                                                fontWeight:
                                                    EdTechFontWeight.normal,
                                                color: EdTechColors.textColor)),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: EdTechIconSizes.small,
                        color: EdTechColors.textBlackColor,
                      ),
                    )
                  ]),
              SizedBox(
                height: 8,
              ),
              Container(height: 1, color: EdTechColors.dividerColor),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ));
  }

  void checkingForStudent(int studentId, String image, int classroom_id, String status) {
    teacherBloc.checkingForStudent(studentId, image, classroom_id, status, (result) {
      for(var i = 0; i < listStudents.length; i++) {
        if(listStudents[i].student_id == studentId) {
          listStudents[i].checking = result;
          break;
        }
      }
      teacherBloc.createCheckingForStudent();
    }, (_) {});
  }

  void backToHome() {
    Navigator.of(context).pop();
  }
}
