import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/notification/notification_widget.dart';
import 'package:edtechteachersapp/src/resources/home/list_teachers_screen.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/resources/home/index.dart';
import '../../global/configs/index.dart';

class DetailClassRoomScreen extends StatefulWidget {
  DetailClassRoomScreen({Key key}) : super(key: key);

  @override
  _DetailClassRoomScreenState createState() => _DetailClassRoomScreenState();
}

class _DetailClassRoomScreenState extends State<DetailClassRoomScreen> {
  bool _isGrid = true;
  NotificationBloc notificationBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: backToHome),
          actions: [
            StreamBuilder(
                stream: notificationBloc.numberOfNotificationController,
                builder: (context, snapshot) {
                  return NotificationWidget().buildNotificationWidget(
                      context, EdTechColors.textBlackColor);
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
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 30, height: 30, color: Colors.transparent),
                      Container(
                        height: 30,
                        width: EdTechAppStyles(context).width - 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0, color: EdTechColors.dividerColor),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) //         <--- border radius here
                              ),
                        ),
                        child: TabBar(
                            labelColor: EdTechColors.textWhiteColor,
                            labelStyle: TextStyle(
                                fontSize: EdTechFontSizes.small,
                                fontWeight: EdTechFontWeight.normal,
                                fontFamily: EdTechFontFamilies.mainFont),
                            unselectedLabelColor: EdTechColors.textBlackColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: EdTechColors.mainColor,
                                      style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                gradient: LinearGradient(colors: [
                                  EdTechColors.mainColor,
                                  EdTechColors.mainColor
                                ])),
                            tabs: <Widget>[
                              Tab(
                                  child: Center(
                                child: Text(
                                  "Học sinh",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              Tab(
                                  child: Center(
                                child: Text(
                                  "Giáo viên",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                            ]),
                      ),
                      new GestureDetector(
                          onTap: () {
                            setState(() {
                              _isGrid = !_isGrid;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: EdTechColors.dividerColor),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) //         <--- border radius here
                                  ),
                            ),
                            width: 30,
                            height: 30,
                            child: Icon(_isGrid ? Icons.apps : Icons.list,
                                size: EdTechIconSizes.normal),
                          ))
                    ],
                  ))),
        ),
        body: TabBarView(
          children: <Widget>[
            ListStudentScreen(
                classId: DataSingleton.instance.classSelected.classroom_id,
                isGrid: _isGrid),
            ListTeacherScreen(
                classId: DataSingleton.instance.classSelected.classroom_id,
                isGrid: _isGrid),
          ],
        ),
      ),
    );
  }

  void backToHome() {
    DataSingleton.instance.backToHome();
    Navigator.of(context).pop();
  }
}
