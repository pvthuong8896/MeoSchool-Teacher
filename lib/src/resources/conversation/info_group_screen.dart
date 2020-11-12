import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'dart:async';
import 'dart:io';

class InfoGroupScreen extends StatefulWidget {
  InfoGroupScreen({Key key}) : super(key: key);

  @override
  _InfoGroupScreenState createState() => _InfoGroupScreenState();
}

class _InfoGroupScreenState extends State<InfoGroupScreen> {
  TeacherBloc teacherBloc;
  List<Parents> listParents = [];
  ChatBloc chatBloc;
  EdTechFile avatarFile;
  BuildContext _scaffoldContext;
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    for (var parents in DataSingleton.instance.listParents) {
      if (parents.isSelected) {
        listParents.add(parents);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: () => Navigator.of(context).pop()),
          actions: [
            InkWell(
              onTap: () {
                if (_groupNameController.text == "" ) {
                  ToastMessage.showToastMessage(context, "Vui lòng nhập tên nhóm");
                } else if (avatarFile == null || avatarFile.file_url == "") {
                  ToastMessage.showToastMessage(context, "Vui lòng chọn ảnh đại diện");
                } else {
                  List<int> user_ids = [];
                  user_ids.add(DataSingleton.instance.edUser.user_id);
                  for (var parents in listParents) {
                    user_ids.add(parents.user_id);
                  }
                  Map<String, dynamic> custom_data = {
                    "classroom_id": DataSingleton.instance.classSelected.classroom_id,
                    "description": DataSingleton.instance.classSelected.subject.name
                  };
                  chatBloc.createChannel(_groupNameController.text, user_ids, CHAT_GROUP, avatarFile.file_url, custom_data, (_) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, (_) {});
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Tạo",
                    style: TextStyle(
                        fontSize: EdTechFontSizes.normal,
                        fontWeight: EdTechFontWeight.semibold,
                        color: EdTechColors.textBlackColor),
                  )),
            )
          ],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tạo nhóm chat",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return getBody();
        })
    );
  }

  getBody() => Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  _settingModalBottomSheet(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  decoration: BoxDecoration(
                      color: EdTechColors.dividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: avatarFile != null
                        ? Image.file(avatarFile.file, fit: BoxFit.cover,)
                        : Icon(
                      Icons.add_a_photo,
                      size: EdTechIconSizes.normal,
                      color: EdTechColors.mainColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _groupNameController,
                  style: TextStyle(
                      fontSize: EdTechFontSizes.normal,
                      fontWeight: EdTechFontWeight.medium,
                      color: EdTechColors.textBlackColor),
                  onChanged: (text) => {},
                  decoration: InputDecoration(
                    hintText: "Nhập tên nhóm",
                    isDense: true,
                    border: UnderlineInputBorder(
                      borderSide:
                      BorderSide(width: 1, color: EdTechColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(width: 1, color: EdTechColors.mainColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              )
            ],
          ),
          Divider(),
          Expanded(child: _buildListClassoom())
        ],
      );

  Widget _buildListClassoom() => Container(
      color: EdTechColors.backgroundColor,
      child: ListView.builder(
          itemCount: listParents.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildCardCreateGroup();
            } else {
              return _buildCardParent(listParents[index - 1]);
            }
          }));

  Widget _buildCardCreateGroup() => Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          Text("${listParents.length} thành viên",
              style: new TextStyle(
                  fontSize: EdTechFontSizes.normal,
                  fontWeight: EdTechFontWeight.medium,
                  color: EdTechColors.textBlackColor)),
        ],
      ));

  Widget _buildCardParent(Parents parents) => InkWell(
      onTap: () {
        setState(() {
          parents.isSelected = !parents.isSelected;
        });
      },
      child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                child: new CircleAvatar(
                  backgroundColor: EdTechColors.dividerColor,
                  backgroundImage: parents.avatar != null
                      ? NetworkImage(parents.avatar)
                      : AssetImage('assets/img/avatar_default.png'),
                ),
              ),
              SizedBox(width: 13),
              Text(parents.name,
                  style: new TextStyle(
                      fontSize: EdTechFontSizes.normal,
                      fontWeight: EdTechFontWeight.medium,
                      color: EdTechColors.textBlackColor)),
            ],
          )));

  void _settingModalBottomSheet(BuildContext context) {
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
                    onTap: () => getImageFromCamera()),
                new ListTile(
                  leading: new Icon(Icons.photo_library,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text(FROM_LIBRARY),
                  onTap: () => getImageFromLibrary(),
                ),
              ],
            ),
          );
        });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1500, maxWidth: 1500);
    Navigator.pop(context);
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, IMAGE_NULL);
    } else {
      uploadImage(image);
    }
  }

  Future getImageFromLibrary() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
    Navigator.pop(context);
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, IMAGE_NULL);
    } else {
      uploadImage(image);
    }
  }

  Future uploadImage(File image) async {
    try {
      SnackBarDialog.showLoadingView(_scaffoldContext, IMAGE_LOADING);
      var newImage = await chatBloc.uploadImage(image);
      newImage.file = image;
      setState(() {
        avatarFile = newImage;
      });
      SnackBarDialog.showSuccessView(_scaffoldContext, IMAGE_LOAD_SUCCESS);
    } catch(e) {
      SnackBarDialog.showErrorView(_scaffoldContext, IMAGE_LOAD_ERROR);
    }
  }
}
