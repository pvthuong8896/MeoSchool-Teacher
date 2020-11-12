import 'dart:io';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/resources/student/index.dart';

class UpdateProfileStudent extends StatefulWidget {
  final student;
  UpdateProfileStudent({Key key, @required this.student}) : super(key: key);

  @override
  _UpdateProfileStudentState createState() => new _UpdateProfileStudentState();
}

class _UpdateProfileStudentState extends State<UpdateProfileStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _dobFocusNode = new FocusNode();
  FocusNode _addressFocusNode = new FocusNode();
  DateTime _selectedDob;
  File _avatar;
  TeacherBloc teacherBloc;

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    _selectedDob = EdTechConvertData.convertDateTime(widget.student.dob);
    _nameController.text = widget.student.name;
    _dobController.text = EdTechConvertData.convertTimeString(widget.student.dob);
    _addressController.text = widget.student.address;

    _nameFocusNode.addListener(focusNameTextField);
    _addressFocusNode.addListener(focusAddressTextField);
  }

  void focusNameTextField() {
    teacherBloc.isValidStudentName(_nameController.text);
  }
  void focusAddressTextField() {
    teacherBloc.isValidStudentAddress(_addressController.text);
  }

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

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _dobFocusNode.dispose();
  }

  Widget build(BuildContext context) {
    globalSize = new EdTechAppStyles(updateProfileStudentDialogContext);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: scaleWidth(30.0)),
        child: Container(
          height: scaleWidth(500.0),
          width: scaleWidth(270.0),
          decoration: BoxDecoration(
            color: EdTechColors.backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () => _settingModalBottomSheet(context),
              child: AbsorbPointer(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      height: scaleWidth(125.0),
                      width: scaleWidth(125.0),
                      child: ClipOval(
                        child:
                        _avatar != null
                        ? Image.file(_avatar, fit: BoxFit.cover)
                        : (widget.student.avatar.isNotEmpty || widget.student.avatar != null)
                          ? Image.network(widget.student.avatar, fit: BoxFit.cover)
                          : Image.asset("assets/img/avatar_default.png", fit: BoxFit.cover)
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(scaleWidth(130.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0, scaleWidth(15.0)),
                            blurRadius: scaleWidth(40.0),
                            color: Colors.grey[200].withOpacity(0.9)
                          )
                        ]
                      ),
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
                                offset: Offset(scaleWidth(8.0), scaleWidth(8.0)),
                                blurRadius: scaleWidth(10.0),
                                color: Colors.grey[200]
                              )
                            ]
                          ),
                          child: Icon(Icons.edit, size: scaleWidth(18.0), color: Colors.white),
                        ))
                  ],
                )
              )
            ),
            SizedBox(height: 5.0),
            updateProfileField("Họ tên", _nameController, teacherBloc.nameStudentStream,
              _nameFocusNode, teacherBloc.isValidStudentName, false),
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
                          EdTechConvertData.convertTimeString(value.toString());
                      _selectedDob = value;
                    });
                  });
                },
                child: AbsorbPointer(
                  child: updateProfileField("Ngày sinh", _dobController, null,
                      _dobFocusNode, null, true),
                )),
            SizedBox(height: 10.0),
            updateProfileField("Địa chỉ", _addressController, teacherBloc.addressStudentStream,
            _addressFocusNode, teacherBloc.isValidStudentAddress, false),
            SizedBox(height: 15.0),
            updateProfileButton(context),
            SizedBox(height: 15.0),
          ],
          ),
      )
    );
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
                child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              style: TextStyle(fontSize: 15, color: EdTechColors.textBlackColor, fontWeight: EdTechFontWeight.medium),
              onChanged: (text) => validator(text),
              decoration: InputDecoration(
                labelText: title,
                labelStyle:
                    (focusNode.hasFocus || textEditingController.text != "")
                        ? TextStyle(
                            fontSize: 17.0,
                            color: EdTechColors.mainColor,
                            fontWeight: FontWeight.w700)
                        : TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w300),
                contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 3.0),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                border: UnderlineInputBorder(),
              ),
            )));
  }

  Widget updateProfileButton(context) {
    return Container(
        child: FlatButton(
          onPressed: _onPressedUpdateProfile,
          child: Text(
            'Thay đổi',
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
    String dob = _selectedDob.toIso8601String();
    String address = _addressController.text;
    File avatar = _avatar;
    int studentId = widget.student.student_id;

    bool isValid = teacherBloc.isValidUpdateStudentProfile(name, dob, address);
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, "Đang cập nhật...");
      teacherBloc.putUpdateStudentProfile(name, dob, address, avatar, widget.student.avatar, studentId, (newStudentData) {
        LoadingDialog.hideLoadingDialog(context);
        ToastMessage.showToastMessage(context, "Cập nhật thành công");
        List students = DataSingleton.instance.listStudents;
        for (int i=0; i<students.length; i++) {
          if (students[i].student_id == studentId) {
            DataSingleton.instance.listStudents[i] = newStudentData;
          }
        }
        Navigator.pop(context, newStudentData);
        setState(() => _avatar = null);
      }, (message) {
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMessageDialog(context, "Thông báo", message, "OK");
      });
    } else {

    }
  }

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
}