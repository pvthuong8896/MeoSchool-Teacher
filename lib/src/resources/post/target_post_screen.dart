import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class AlphabetCategory {
  String header;
  List<Student> listStudent = [];

  AlphabetCategory({this.header, this.listStudent});

  void setHeader(String header) {
    this.header = header;
  }

  void setNewStudent(student) {
    this.listStudent.add(student);
  }
}

class TargetPostScreen extends StatefulWidget {
  TargetPostScreen({Key key}) : super(key: key);

  @override
  _TargetPostScreenState createState() => _TargetPostScreenState();
}

class _TargetPostScreenState extends State<TargetPostScreen> {
  final focusNode = FocusNode();
  final TextEditingController _contentController = TextEditingController();
  final listStudent = DataSingleton.instance.listStudents;
  final List<AlphabetCategory> listKey = [];
  var postTargetForStudent = false;
  PostBloc postBloc;

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    getHeaderForListStudent();
    checkPostTargetForStudent();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 0,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Đăng bài viết cho",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: EdTechColors.textBlackColor,
                size: EdTechIconSizes.medium),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            InkWell(
              onTap: (){
                postBloc.handleTargetStudent();
                Navigator.of(context).pop();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Chọn",
                    style: TextStyle(
                        fontSize: EdTechFontSizes.normal,
                        fontWeight: EdTechFontWeight.semibold,
                        color: EdTechColors.textBlackColor),
                  )),
            )
          ],
        ),
        body: getBody());
  }

  getBody() {
    return new GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: EdTechColors.backgroundColor,
            child: Column(
              children: [
                _buildTargetClass(),
                Text("Hồ sơ học sinh",
                    style: TextStyle(
                        fontSize: EdTechFontSizes.simple,
                        fontWeight: EdTechFontWeight.medium,
                        color: EdTechColors.textBlackColor)),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _contentController,
                  focusNode: focusNode,
                  style: TextStyle(
                      fontSize: EdTechFontSizes.normal,
                      fontWeight: EdTechFontWeight.normal,
                      color: EdTechColors.textBlackColor),
                  onChanged: (text) => {},
                  decoration: InputDecoration(
                    icon: Icon(Icons.search,
                        size: EdTechIconSizes.normal,
                        color: _contentController.text != ""
                            ? EdTechColors.mainColor
                            : EdTechColors.textColor),
                    hintText: "Tìm kiếm",
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: _getListStudent(),
                )
              ],
            )));
  }

  void checkPostTargetForStudent() {
    for (var i = 0; i < listStudent.length; i++) {
      if (listStudent[i].isSelected) {
        postTargetForStudent = true;
        return;
      }
    }
    postTargetForStudent = false;
  }

  void getHeaderForListStudent() {
    String lastHeader = "";
    listKey.clear();
    for (var i = 0; i < listStudent.length; i++) {
      var item = listStudent[i];
      String header = item.name[0].toUpperCase();
      if (lastHeader == header) {
        if (listKey.isEmpty) {
          listKey
              .add(new AlphabetCategory(header: header, listStudent: [item]));
        } else {
          listKey.last.setNewStudent(item);
        }
      } else {
        lastHeader = header;
        listKey.add(new AlphabetCategory(header: header, listStudent: [item]));
      }
    }
  }

  Widget _getListStudent() {
    return ListView.builder(
        itemCount: listKey.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(listKey[index].header,
                        style: TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            fontWeight: EdTechFontWeight.medium,
                            color: EdTechColors.textBlackColor)),
                  ),
                  SizedBox(width: 10),
//                  Expanded(
//                      child: Container(
//                    height: 0.5,
//                    color: EdTechColors.dividerColor,
//                  ))
                ],
              ),
              Container(
                height: 50.0 * listKey[index].listStudent.length,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listKey[index].listStudent.length,
                    itemBuilder: (BuildContext context, int p) {
                      return _buildPostCard(listKey[index].listStudent[p]);
                    }),
              )
            ],
          );
        });
  }

  Widget _buildTargetClass() {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                new Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: EdTechColors.textColor,
                    image: new DecorationImage(
                      image: DataSingleton.instance.edUser.avatar != null
                          ? new NetworkImage(
                              DataSingleton.instance.edUser.avatar)
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
                SizedBox(
                  width: 11,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DataSingleton.instance.classSelected.name,
                      style: TextStyle(
                          color: EdTechColors.textBlackColor,
                          fontSize: EdTechFontSizes.normal,
                          fontWeight: EdTechFontWeight.medium),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      "${DataSingleton.instance.classSelected.total_parents} phụ huynh",
                      style: TextStyle(
                          fontSize: EdTechFontSizes.small,
                          color: EdTechColors.textColor,
                          fontWeight: EdTechFontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              child: !postTargetForStudent
                  ? Icon(Icons.check_circle,
                      size: EdTechIconSizes.normal,
                      color: EdTechColors.mainColor)
                  : Icon(Icons.check_circle,
                      size: EdTechIconSizes.normal,
                      color: EdTechColors.dividerColor),
            )
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPostCard(Student student) {
    return InkWell(
      child: Column(
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: <Widget>[
                  new Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: EdTechColors.textColor,
                      image: new DecorationImage(
                        image: student.avatar != null
                            ? new NetworkImage(student.avatar)
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
                  SizedBox(
                    width: 11,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        student.name,
                        style: TextStyle(
                            color: EdTechColors.textBlackColor,
                            fontSize: EdTechFontSizes.normal,
                            fontWeight: EdTechFontWeight.medium),
                      ),
//                    SizedBox(
//                      height: 1,
//                    ),
//                    Text(
//                      "Mẹ của B",
//                      style: TextStyle(
//                          fontSize: EdTechFontSizes.small,
//                          color: EdTechColors.textColor,
//                          fontWeight: EdTechFontWeight.normal),
//                    ),
                    ],
                  ),
                ],
              ),
              Container(
                child: student.isSelected
                    ? Icon(Icons.check_circle,
                        size: EdTechIconSizes.normal,
                        color: EdTechColors.mainColor)
                    : Icon(Icons.radio_button_unchecked,
                        size: EdTechIconSizes.normal,
                        color: EdTechColors.dividerColor),
              )
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
      onTap: () {
        setState(() {
          checkPostTargetForStudent();
          student.isSelected = !student.isSelected;
        });
      },
    );
  }
}