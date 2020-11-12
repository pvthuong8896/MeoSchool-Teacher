import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/teacher/detail_teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherListView extends StatelessWidget {
  final List<Teacher> listTeachers;

  const TeacherListView({Key key, @required this.listTeachers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
      itemCount: listTeachers.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListViewCard(context, listTeachers[index]);
      },
    );
  }

  Widget _buildListViewCard(BuildContext context, Teacher teacher) {
    return GestureDetector(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              // pass the student object to new screen
              return DetailTeacher(teacher: teacher);
            })),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.centerLeft,
                          child: new CircleAvatar(
                            backgroundColor: Colors.brown,
                            backgroundImage:
                            !(teacher.avatar == null || teacher.avatar.isEmpty)
                                ? NetworkImage(
                              teacher.avatar,
                            )
                                : AssetImage(
                              'assets/img/avatar_default.png',
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: EdTechAppStyles(context).width - 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(teacher.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.normal,
                                      fontWeight: EdTechFontWeight.semibold,
                                      color: EdTechColors.textBlackColor)),
                              SizedBox(height: 2),
                              Text('Ngày sinh: ${EdTechConvertData.convertTimeString(teacher.dob)}',
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.small,
                                      fontWeight: EdTechFontWeight.normal,
                                      color: EdTechColors.textBlackColor)),
                              SizedBox(height: 2),
                              Text('Email: ${teacher.email}',
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.small,
                                      fontWeight: EdTechFontWeight.normal,
                                      color: EdTechColors.textBlackColor)),
                            ],
                          ),
                        )
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
}
