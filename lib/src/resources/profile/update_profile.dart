import 'dart:async';
import 'dart:io';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/repository/user_repository.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreen createState() => _UpdateProfileScreen();
}

class _UpdateProfileScreen extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  DateTime _selectedDob;

  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _dobFocusNode = new FocusNode();
  FocusNode _phoneNumberFocusNode = new FocusNode();

  TeacherBloc teacherBloc;
  final UserRepository userRepository = UserRepository();
  File _avatar;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _avatar = image;
    });
    Navigator.pop(context);
  }

  Future getImageFromLibrary() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _avatar = image;
    });
    Navigator.pop(context);
  }

  bool _checkEditing() {
    var _editing = true;
    var notChangeName =
        _nameController.text == DataSingleton.instance.edUser.name;
    var notChangeEmail =
        _emailController.text == DataSingleton.instance.edUser.email;
    var notChangeDob = _dobController.text ==
        EdTechConvertData.convertTimeString(DataSingleton.instance.edUser.dob);
    var notChangePhone = _phoneNumberController.text ==
        DataSingleton.instance.edUser.phone_number;
    var notChangeAvatar = _avatar == null;
    if (notChangeName &&
        notChangeEmail &&
        notChangeDob &&
        notChangePhone &&
        notChangeAvatar) {
      _editing = false;
    }
    return _editing;
  }

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    _nameController.text = DataSingleton.instance.edUser.name;
    _emailController.text = DataSingleton.instance.edUser.email;
    _selectedDob =
        EdTechConvertData.convertDateTime(DataSingleton.instance.edUser.dob);
    _dobController.text =
        EdTechConvertData.convertTimeString(DataSingleton.instance.edUser.dob);
    _phoneNumberController.text = DataSingleton.instance.edUser.phone_number;
    _avatar = null;

    _nameFocusNode.addListener(focusnameTextField);
    _emailFocusNode.addListener(focusEmailTextField);
    _phoneNumberFocusNode.addListener(focusPhoneNumberTextField);
  }

  void focusnameTextField() {
    teacherBloc.isValidName(_nameController.text);
  }

  void focusEmailTextField() {
    teacherBloc.isValidEmail(_emailController.text);
  }

  void focusPhoneNumberTextField() {
    teacherBloc.isValidPhoneNumber(_phoneNumberController.text);
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _dobFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    globalSize = new EdTechAppStyles(context);
    return WillPopScope(
        onWillPop: () async {
          if (!_checkEditing()) {
            return true;
          } else {
            ActionDialog.showActionDialog(
                context,
                "Bạn muốn rời đi?",
                "Thông tin cá nhân đang được cập nhật, nếu rời đi bạn sẽ mất các thông tin vừa sửa.",
                "Tiếp tục sửa",
                "Rời đi", () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
            return false;
          }
        },
        child: Scaffold(
          backgroundColor: EdTechColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: EdTechColors.textColor),
              onPressed: () {
                if (!_checkEditing()) {
                  Navigator.of(context).pop();
                } else {
                  ActionDialog.showActionDialog(
                      context,
                      "Bạn muốn rời đi?",
                      "Thông tin cá nhân đang được cập nhật, nếu rời đi bạn sẽ mất các thông tin vừa sửa.",
                      "Tiếp tục sửa",
                      "Rời đi", () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
            centerTitle: true,
            title: Text(
              "Chỉnh sửa hồ sơ",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: () => _settingModalBottomSheet(context),
                      child: AbsorbPointer(
                          child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                            height: scaleWidth(114.0),
                            width: scaleWidth(114.0),
                            child: ClipOval(
                                child: _avatar != null
                                    ? Image(
                                        image: FileImage(_avatar),
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      )
                                    : (DataSingleton.instance.edUser.avatar ==
                                                null ||
                                            DataSingleton
                                                .instance.edUser.avatar.isEmpty)
                                        ? Image.asset(
                                            "assets/img/avatar_default.png",
                                            fit: BoxFit.cover)
                                        : Image.network(
                                            DataSingleton
                                                .instance.edUser.avatar,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                  child: SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1.0,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          EdTechColors
                                                              .mainColor),
                                                ),
                                                height: 20.0,
                                                width: 20.0,
                                              ));
                                            },
                                          )),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(scaleWidth(130.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      offset: Offset(0, scaleWidth(15.0)),
                                      blurRadius: scaleWidth(40.0),
                                      color: Colors.grey[200].withOpacity(0.8))
                                ]),
                          ),
                          Positioned(
                              right: 10.0,
                              child: Container(
                                padding: EdgeInsets.all(scaleWidth(6.0)),
                                decoration: BoxDecoration(
                                    color: EdTechColors.mainColor,
                                    borderRadius: BorderRadius.circular(99.0),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          offset: Offset(
                                              scaleWidth(8.0), scaleWidth(8.0)),
                                          blurRadius: scaleWidth(10.0),
                                          color: Colors.grey[200])
                                    ]),
                                child: Icon(Icons.edit,
                                    size: scaleWidth(18.0),
                                    color: Colors.white),
                              ))
                        ],
                      ))),
                  updateProfileField(
                      "Họ tên",
                      _nameController,
                      teacherBloc.nameStream,
                      _nameFocusNode,
                      teacherBloc.isValidName,
                      false),
                  SizedBox(height: 10.0),
                  updateProfileField(
                      "Email",
                      _emailController,
                      teacherBloc.emailStream,
                      _emailFocusNode,
                      teacherBloc.isValidEmail,
                      false),
                  SizedBox(height: 10.0),
                  GestureDetector(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: _selectedDob,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2050))
                            .then((value) {
                          setState(() {
                            _dobController.text =
                                EdTechConvertData.convertTimeString(
                                    value.toString());
                            _selectedDob = value;
                          });
                        });
                      },
                      child: AbsorbPointer(
                        child: updateProfileField("Ngày sinh", _dobController,
                            null, _dobFocusNode, null, true),
                      )),
                  SizedBox(height: 10.0),
                  updateProfileField(
                      "Số điện thoại",
                      _phoneNumberController,
                      teacherBloc.phoneNumberStream,
                      _phoneNumberFocusNode,
                      teacherBloc.isValidPhoneNumber,
                      false),
                  SizedBox(height: 25.0),
                  updateProfileButton(context),
                  SizedBox(height: 25.0),
                ],
              )),
        ));
  }

  Widget updateProfileField(
      String title,
      TextEditingController textEditingController,
      Stream stream,
      FocusNode focusNode,
      validator,
      showsKeyboard) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) => Container(
            width: double.infinity,
            height: 68,
            child: TextField(
              showCursor: !showsKeyboard,
              readOnly: showsKeyboard,
              controller: textEditingController,
              focusNode: focusNode,
              style: TextStyle(
                  fontSize: EdTechFontSizes.simple,
                  fontWeight: EdTechFontWeight.medium,
                  color: EdTechColors.textBlackColor),
              onChanged: (text) => validator(text),
              decoration: InputDecoration(
                isDense: true,
                labelText: title,
                alignLabelWithHint: true,
                errorText: snapshot.hasError ? snapshot.error : null,
                labelStyle:
                    (focusNode.hasFocus || textEditingController.text != "")
                        ? TextStyle(
                            fontSize: EdTechFontSizes.medium,
                            color: EdTechColors.mainColor,
                            fontWeight: EdTechFontWeight.normal)
                        : TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            color: EdTechColors.textColor,
                            fontWeight: EdTechFontWeight.normal),
                contentPadding:
                    (focusNode.hasFocus || textEditingController.text != "")
                        ? EdgeInsets.fromLTRB(0, 8.0, 0, 9.0)
                        : EdgeInsets.fromLTRB(0, 8.0, 0, 12.0),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 0.75, color: EdTechColors.dividerColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.75, color: EdTechColors.mainColor)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 0.75, color: EdTechColors.dividerColor)),
              ),
            )));
  }

  Widget updateProfileButton(context) {
    return Container(
        child: FlatButton(
          onPressed: _onPressedUpdateProfile,
          child: Text(
            'Lưu',
            style: TextStyle(
                color: Colors.white,
                fontWeight: EdTechFontWeight.semibold,
                fontSize: 15),
          ),
        ),
        width: 140,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: EdTechColors.mainColor));
  }

  _onPressedUpdateProfile() {
    String name = _nameController.text;
    String email = _emailController.text;
    String dob = _selectedDob.toIso8601String();
    String phoneNumber = _phoneNumberController.text;
    File avatar = _avatar;
    bool isValid =
        teacherBloc.isValidUpdateProfile(name, email, dob, phoneNumber);
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, "Đang cập nhật");
      teacherBloc.putUpdateProfile(name, email, dob, phoneNumber, avatar,
          (user) {
        LoadingDialog.hideLoadingDialog(context);
        ToastMessage.showToastMessage(context, "Cập nhật thông tin thành công");
        userRepository.saveDataUser(user);
        DataSingleton.instance.edUser = user;
        teacherBloc.updateProfileTeacherSuccessful();
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
      }, (message) {
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMessageDialog(context, "Thông báo", message, "OK");
      });
    } else {
      ActionDialog.showActionDialog(
          context,
          "Thông tin chưa hợp lệ",
          "Tự động sửa các trường thông tin chưa hợp lệ theo thông tin cũ?",
          "Không",
          "Đồng ý",
          autoFillData);
    }
  }

  autoFillData() {
    ActionDialog.hideActionDialog(context);
    _fillInfoWhenBlank(_nameController, DataSingleton.instance.edUser.name);
    _fillInfoWhenBlank(_emailController, DataSingleton.instance.edUser.email);
    _fillInfoWhenBlank(
        _phoneNumberController, DataSingleton.instance.edUser.phone_number);
    ToastMessage.showToastMessage(
        context, "Tự động điền các thông tin còn trống với dữ liệu cũ");
  }

  _fillInfoWhenBlank(TextEditingController dataController, String oldData) {
    if (dataController.text.isEmpty) {
      setState(() {
        dataController.text = oldData;
      });
    }
  }

  // update avatar
  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera,
                        color: EdTechColors.textBlackColor,
                        size: EdTechIconSizes.normal),
                    title: new Text('Máy ảnh'),
                    onTap: () => getImageFromCamera()),
                new ListTile(
                  leading: new Icon(Icons.photo_library,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text('Thư viện ảnh'),
                  onTap: () => getImageFromLibrary(),
                ),
              ],
            ),
          );
        });
  }
}
