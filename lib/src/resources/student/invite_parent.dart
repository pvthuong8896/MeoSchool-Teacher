import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/resources/student/index.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/foundation.dart';

import '../../global/configs/edtech_fontsize.dart';

class InviteParent extends StatefulWidget {
  final Student student;
  InviteParent({Key key, @required this.student}) : super(key: key);
  @override
  _InviteParentState createState() => _InviteParentState();
}

class _InviteParentState extends State<InviteParent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailParentController = TextEditingController();
  final TextEditingController _phoneNumberParentController =
      TextEditingController();

  TeacherBloc teacherBloc;
  TabController _tabController;
  String sendButtonTitle = "Gửi";

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_changeTab);
    sendButtonTitle = "Gửi";
  }

  void _changeTab() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    return Container(
        height: (360.0),
        width: (330.0),
        decoration: BoxDecoration(
          color: EdTechColors.backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                elevation: 0.5,
                automaticallyImplyLeading: false,
                backgroundColor: EdTechColors.backgroundColor,
                centerTitle: true,
                title: Text("Mời phụ huynh",
                    style: TextStyle(
                        color: EdTechColors.textBlackColor,
                        fontSize: (20.0),
                        fontWeight: EdTechFontWeight.semibold)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5.0),
                  ),
                ),
                // TAB BAR
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight((18.0)),
                    child: Container(
                      height: (26.0),
                      child: TabBar(
                        controller: _tabController,
                        tabs: <Tab>[
                          Tab(child: Text("Gửi thư mời")),
                          Tab(child: Text("Gửi mã học sinh")),
                        ],
                        labelColor: EdTechColors.textColor,
                        labelStyle: TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          color: EdTechColors.textBlackColor,
                          fontWeight: EdTechFontWeight.bold,
                          fontFamily: EdTechFontFamilies.mainFont
                        ),
                        unselectedLabelColor:
                            EdTechColors.dividerColor,
                        indicatorColor: EdTechColors.mainColor,
                        indicatorWeight: 2.5,
                      ),
                    ))),
            // TAB BAR VIEW (2)
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: (30.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: (inputHeight),
                            padding: EdgeInsets.symmetric(
                                horizontal: (7.0)),
                            child: TextField(
                              onChanged: (value) {
                                if(value.trim().length != 0)
                                  setState(() {sendButtonTitle = "Gửi SMS";});
                                else if (_emailParentController.text.trim().length != 0) 
                                  setState(() {sendButtonTitle = "Gửi email";});
                                else 
                                  setState(() {sendButtonTitle = "Gửi";});
                              },
                              controller: _phoneNumberParentController,
                              style: TextStyle(
                                  fontSize: EdTechFontSizes.normal,
                                  color: EdTechColors.textColor,
                                  fontWeight: EdTechFontWeight.medium
                              ),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  hintText: "Nhập số điện thoại",
                                  hintStyle: TextStyle(
                                    fontSize: EdTechFontSizes.normal,
                                    color: EdTechColors.textColor,
                                    fontWeight: EdTechFontWeight.normal,
                                  ),
                                  border: InputBorder.none),
                            ),
                            decoration: BoxDecoration(
                              color: EdTechColors.dividerColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    height: 1.0,
                                    width: (110.0),
                                    color: EdTechColors.textBlackColor),
                                Text(
                                  "Hoặc",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: EdTechColors.textBlackColor,
                                      fontSize: (14.0)),
                                ),
                                Container(
                                    height: 1.0,
                                    width: (110.0),
                                    color: EdTechColors.textBlackColor),
                              ]),
                          // send invitaion via email textfield
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: (inputHeight),
                            padding: EdgeInsets.symmetric(
                                horizontal: (7.0)),
                            child: TextField(
                              onChanged: (value) {
                                if(value.trim().length != 0 && _phoneNumberParentController.text.trim().length == 0)
                                  setState(() {sendButtonTitle = "Gửi email";});
                                else if (_phoneNumberParentController.text.trim().length != 0) 
                                  setState(() {sendButtonTitle = "Gửi SMS";});
                                else 
                                  setState(() {sendButtonTitle = "Gửi";});
                              },
                              controller: _emailParentController,
                              style: TextStyle(
                                  fontSize: EdTechFontSizes.normal,
                                  color: EdTechColors.textColor,
                                  fontWeight: EdTechFontWeight.medium
                              ),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "Nhập email",
                                  hintStyle: TextStyle(
                                    fontSize: EdTechFontSizes.normal,
                                    color: EdTechColors.textColor,
                                    fontWeight: EdTechFontWeight.normal,
                                  ),
                                  border: InputBorder.none),
                            ),
                            decoration: BoxDecoration(
                              color: EdTechColors.dividerColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          // buttons to send
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              cancelButton(context),
                              SizedBox(width: 14.0),
                              sendButton(context)
                            ],
                          )
                        ])),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: (30.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        QrImage(
                          data: widget.student.code,
                          version: QrVersions.auto,
                          size: (120.0),
                        ),
                        StudentCode(codeOfStudent: widget.student.code),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[doneButton(context)],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  // SEND BUTTON
  Widget sendButton(context) {
    return Container(
        child: FlatButton(
          onPressed: _postSendInvitation,
          child: Text(
            sendButtonTitle,
            style: TextStyle( 
                color: Colors.white,
                fontWeight: EdTechFontWeight.semibold,
                fontSize: (13.0)),
          ),
        ),
        // width: (78.0),
        height: (35.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: EdTechColors.mainColor));
  }

  void _postSendInvitation() {
    String emailParent = _emailParentController.text.trim();
    String phoneNumber = _phoneNumberParentController.text.trim();
    String studentCode = widget.student.code;

    if (teacherBloc.isValidPhoneNumber(phoneNumber)) {
      String message =
          "Phụ huynh hãy nhập mã ${widget.student.code} để theo dõi học sinh.";
      List<String> recipents = [phoneNumber];
      _sendSMS(message, recipents);
    } else if (teacherBloc.isValidEmail(emailParent)) {
      LoadingDialog.showLoadingDialog(context, "Đang gửi mã...");
      teacherBloc.postSendInvitaion(emailParent, studentCode, (data) {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pop(inviteParentDialogContext);
        ToastMessage.showToastMessage(context, "Gửi thành công!");
        setState(() {
          _emailParentController.text = "";
          _phoneNumberParentController.text = "";
        });
      }, (message) {
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMessageDialog(context, "Thông báo", message, "OK");
      });
    } else {
      MessageDialog.showMessageDialog(context, "Thông báo",
          "Vui lòng điền ít nhất một trường thông tin hợp lệ", "OK");
    }
  }

  Widget cancelButton(context) {
    return Container(
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          }, // the function right below this Widget
          child: Text(
            'Hủy',
            style: TextStyle(
                color: EdTechColors.mainColor,
                fontWeight: EdTechFontWeight.semibold,
                fontSize: (13.0)),
          ),
        ),
        width: (78.0),
        height: (35.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(color: EdTechColors.mainColor, width: 1.2)));
  }

  Widget doneButton(context) {
    return Container(
        child: FlatButton(
          onPressed: () =>
              Navigator.pop(context), // the function right below this Widget
          child: Text(
            'Xong',
            style: TextStyle(
                color: Colors.white,
                fontWeight: EdTechFontWeight.semibold,
                fontSize: (13.0)),
          ),
        ),
        width: (78.0),
        height: (35.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: EdTechColors.mainColor));
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
