import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/student/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/custom_dialog.dart'
    as customDialog;

class ConnectParentsScreen extends StatefulWidget {
  @override
  _ConnectParentsScreenState createState() => _ConnectParentsScreenState();
}

class _ConnectParentsScreenState extends State<ConnectParentsScreen> {
  TeacherBloc teacherBloc;
  List<Student> listNotConnected = [];
  List<Student> listWaiting = [];
  List<Student> listConnected = [];

  final NOT_CONNECTED = "not_connected";
  final WAITING = "waiting";
  final CONNECTED = "connected";

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    teacherBloc
        .getConnectParents(DataSingleton.instance.classSelected.classroom_id,
            (_listNotConnected, _listWaiting, _listConnected) {
      listNotConnected = _listNotConnected;
      listWaiting = _listWaiting;
      listConnected = _listConnected;
    }, (message) => {ToastMessage.showToastMessage(context, message)});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdTechColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: EdTechColors.backgroundColor,
//        elevation: 0,
        brightness: Brightness.light,
        centerTitle: false,
        title: Text("Kết nối phụ huynh",
            style: TextStyle(
                fontWeight: EdTechFontWeight.semibold,
                color: EdTechColors.textBlackColor,
                fontSize: EdTechFontSizes.medium)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: EdTechColors.textBlackColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return StreamBuilder(
      stream: teacherBloc.listConnectParentsController,
      builder: (context, snapshot) {
        if (snapshot.data == DONE)
          return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  unconnectedParents(),
                  SizedBox(height: 10.0),
                  waitingParents(),
                  SizedBox(height: 10.0),
                  connectedParents(),
                  SizedBox(height: 10.0),
                ],
              ));
        return Center(
          child: edTechLoaderWidget(25.0, 25.0),
        );
      },
    );
  }

  Widget unconnectedParents() {
    return Column(children: <Widget>[
      titleConnectParents("Chưa kết nối", listNotConnected.length),
      listNotConnected.length == 0
          ? Container()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listNotConnected.length,
              itemBuilder: (BuildContext context, int index) {
                return elementConnectParents(
                    NOT_CONNECTED, listNotConnected[index]);
              })
    ]);
  }

  Widget waitingParents() {
    return Column(children: <Widget>[
      titleConnectParents("Đang chờ", listWaiting.length),
      listWaiting.length == 0
          ? Container()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listWaiting.length,
              itemBuilder: (BuildContext context, int index) {
                return elementConnectParents(WAITING, listWaiting[index]);
              })
    ]);
  }

  Widget connectedParents() {
    return Column(children: <Widget>[
      titleConnectParents("Đã kết nối", listConnected.length),
      listConnected.length == 0
          ? Container()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listConnected.length,
              itemBuilder: (BuildContext context, int index) {
                return elementConnectParents(CONNECTED, listConnected[index]);
              })
    ]);
  }

  Widget titleConnectParents(title, numberOfStudents) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: 16.0),
        child: Text(
          numberOfStudents == 0 ? title : title + " ($numberOfStudents)",
          style: TextStyle(
              color: EdTechColors.textBlackColor,
              fontWeight: EdTechFontWeight.semibold,
              fontSize: EdTechFontSizes.medium),
        ));
  }

  Widget elementConnectParents(icon, thisStudent) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: InkWell(
          borderRadius: BorderRadius.circular(99.0),
          onTap: () {
            Widget inviteDialog =
                customDialog.Dialog(child: InviteParent(student: thisStudent));
            showDialog(
                context: context,
                builder: (BuildContext context) => inviteDialog);
          },
          child: Row(children: <Widget>[
            Container(
              height: 32.0,
              width: 32.0,
              alignment: Alignment.center,
              child: icon == NOT_CONNECTED
                  ? Icon(
                      Icons.add,
                      color: EdTechColors.mainColor,
                      size: 16.0,
                    )
                  : Container(
                width: 32.0,
                height: 32.0,
                decoration: new BoxDecoration(
                  color: EdTechColors.textColor,
                  image: new DecorationImage(
                    image: thisStudent.avatar != null
                        ? new NetworkImage(thisStudent.avatar)
                        : AssetImage('assets/img/avatar_default.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                  new BorderRadius.all(new Radius.circular(30.0)),
                  border: new Border.all(
                    color: EdTechColors.textColor,
                    width: 0.1,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: icon == null
                      ? EdTechColors.mainColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.0),
                  border: icon == CONNECTED
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: EdTechColors.mainColor, width: 1.0)),
            ),
            SizedBox(width: 8.0),
            Text(
              "Phụ huynh ${thisStudent.name}",
              style: TextStyle(
                  color: EdTechColors.textBlackColor,
                  fontWeight: EdTechFontWeight.normal,
                  fontSize: EdTechFontSizes.normal),
            ),
          ])),
    );
  }
}
