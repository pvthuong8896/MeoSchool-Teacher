import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class CheckingForStudent extends StatefulWidget {
  final Student student;
  CheckingForStudent({Key key, this.student}) : super(key: key);
  @override
  _CheckingForStudentStatus createState() => _CheckingForStudentStatus();
}

class _CheckingForStudentStatus extends State<CheckingForStudent> {
  TeacherBloc teacherBloc;
  BuildContext _scaffoldContext;
  var loadingData = true;
  var loadMoreData = false;
  ScrollController _scrollCheckingController;

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    getCheckingListHistory(false);
    _scrollCheckingController = ScrollController();
    _scrollCheckingController.addListener(_scrollPostsListener);
  }

  _scrollPostsListener() {
    if (_scrollCheckingController.offset >=
        _scrollCheckingController.position.maxScrollExtent &&
        !_scrollCheckingController.position.outOfRange) {
      getCheckingListHistory(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    return Scaffold(
        backgroundColor: EdTechColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: EdTechColors.textColor, size: EdTechIconSizes.medium),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              this.widget.student.name,
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return body();
        }));
  }

  Widget body() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder(
            stream: teacherBloc.listCheckingController,
            builder: (context, snapshot) {
              if (loadingData) {
                return LoadingDataView.showLoadingDataView(context, "Đang tải...");
              } else {
                return _buildListChecking(teacherBloc.listCheckings);
              }
            }));
  }

  Widget _buildListChecking(List<Checking> listChecking) {
    return ListView.builder(
      controller: _scrollCheckingController,
      itemCount: listChecking.length + (listChecking.length == 0 ? 1 : 2),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return dailyLogRow(
              context, DateTime.now().toString(), this.widget.student.checking, false);
        } else if (index == 1) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Lịch sử đến lớp",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: EdTechColors.mainColor,
                fontWeight: EdTechFontWeight.semibold,
                fontSize: EdTechFontSizes.medium,
              ),
            ),
          );
        } else {
          final checkingHistory = listChecking[index - 2];
          if (EdTechConvertData.compareDate(checkingHistory.date)) {
            if (listChecking.length > 1) {
              return Container();
            } else {
              return NodataView.showNodataView(
                  context, "Chưa có lịch sử đến lớp.");
            }
          } else {
            return dailyLogRow(context, checkingHistory.date, checkingHistory, true);
          }
        }
      },
    );
  }

  Widget dailyLogRow(context, String date, Checking checking, bool isHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text(
          EdTechConvertData.convertDate(date),
          style: TextStyle(
              fontSize: EdTechFontSizes.normal,
              fontWeight: EdTechFontWeight.semibold,
              color: EdTechColors.textColor),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            dailyLogBlock(context, "Đến", checking, CHECKIN, isHistory),
            dailyLogBlock(context, "Về", checking, CHECKOUT, isHistory)
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget dailyLogBlock(
      context, String title, Checking checking, String status, bool isHistory) {
    var sizeImage = (EdTechAppStyles(context).width - 40) / 2;
    String image, time;
    if (status == CHECKIN) {
      image = checking.checkin_image;
      time = checking.checkin_time;
    } else if (status == CHECKOUT) {
      image = checking.checkout_image;
      time = checking.checkout_time;
    } else {
      image = ''; time='';
    }
    return InkWell(
        onTap: () {
          if (!isHistory) {
            _settingModalBottomSheet(context, status);
          }
        },
        child: Column(
          children: <Widget>[
            Container(
              width: sizeImage,
              height: sizeImage,
              decoration: BoxDecoration(
                  color: EdTechColors.dividerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  )),
              child: image != null
                  ? Image.network(
                      image,
                      height: sizeImage,
                      width: sizeImage,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.camera_alt,
                      color: isHistory ? EdTechColors.timeColor : EdTechColors.textColor, size: EdTechIconSizes.big),
            ),
            Container(
                width: sizeImage,
                height: 50,
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: EdTechColors.mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title +
                          ": " +
                          (time != null
                              ? EdTechConvertData.convertTime(time)
                              : "---"),
                      style: TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          color: EdTechColors.textWhiteColor,
                          fontWeight: EdTechFontWeight.semibold),
                    ),
                    InkWell(
                        onTap: () {
                          if (time == null && !isHistory)
                            _checkingForStudent("", status);
                          
                        },
                        child: Container(
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
                                      color: EdTechColors.textWhiteColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              time != null
                                  ? Positioned(
                                      left: 3,
                                      bottom: 3,
                                      child: Icon(Icons.check,
                                          color: EdTechColors.textWhiteColor))
                                  : Container(),
                            ],
                          ),
                        ))
                  ],
                )),
          ],
        ));
  }

  void _settingModalBottomSheet(BuildContext context, status) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera,
                        color: EdTechColors.textBlackColor,
                        size: EdTechIconSizes.normal),
                    title: new Text(FROM_CAMERA),
                    onTap: () => getImageFromCamera(status)),
                new ListTile(
                  leading: new Icon(Icons.photo_library,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text(FROM_LIBRARY),
                  onTap: () => getImageFromLibrary(status),
                ),
              ],
            ),
          );
        });
  }

  Future getImageFromCamera(status) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1500, maxWidth: 1500);
    Navigator.pop(context);
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, IMAGE_NULL);
    } else {
      uploadImage(image, status);
    }
  }

  Future getImageFromLibrary(status) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
    Navigator.pop(context);
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, IMAGE_NULL);
    } else {
      uploadImage(image, status);
    }
  }

  Future uploadImage(File image, status) async {
    SnackBarDialog.showLoadingView(_scaffoldContext, IMAGE_LOADING);
    var newImage = await teacherBloc.uploadImage(image);
    newImage.file = image;
    _checkingForStudent(newImage.file_url, status);
  }

  void _checkingForStudent(String imageUrl, status) async {
    teacherBloc.checkingForStudent(this.widget.student.student_id, imageUrl,
        DataSingleton.instance.classSelected.classroom_id, status, (result) {
      this.widget.student.checking = result;
      SnackBarDialog.showSuccessView(_scaffoldContext, CHECKING_SUCCESS);
      teacherBloc.createCheckingForStudent();
    }, (_) {
      SnackBarDialog.showSuccessView(_scaffoldContext, CHECKING_ERROR);
    });
  }

  void getCheckingListHistory(bool loadMore) async {
    try {
      if (loadMore) {
        loadMoreData = true;
        await teacherBloc.loadMoreCheckingListHistory(this.widget.student.student_id, DataSingleton.instance.classSelected.classroom_id);
        loadMoreData = false;
      } else {
        loadingData = true;
        await teacherBloc.getCheckingListHistory(this.widget.student.student_id, DataSingleton.instance.classSelected.classroom_id);
        loadingData = false;
      }
    } catch (_) {
      loadingData = false;
      loadMoreData = false;
    }
  }
}
