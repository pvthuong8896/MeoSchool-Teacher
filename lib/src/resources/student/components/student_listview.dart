import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../detail_student.dart';

class StudentListView extends StatelessWidget {
  final List<Student> listStudents;

  const StudentListView({Key key, @required this.listStudents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
      itemCount: listStudents.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          final selectedClass = DataSingleton.instance.classSelected;
          return GestureDetector(
              onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    // pass the student object to new screen
                    return ListPostScreen();
                  })),
              child: AbsorbPointer(
                  child: Container(
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
                              Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.centerLeft,
                                child: new CircleAvatar(
                                  backgroundColor: Colors.brown,
                                  backgroundImage:
                                      !(selectedClass.icon == null ||
                                              selectedClass.icon.isEmpty)
                                          ? NetworkImage(
                                              selectedClass.icon,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(selectedClass.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: new TextStyle(
                                            fontSize: EdTechFontSizes.normal,
                                            fontWeight:
                                                EdTechFontWeight.semibold,
                                            color:
                                                EdTechColors.textBlackColor)),
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
              )));
        } else {
          return _buildListViewCard(context, listStudents[index - 1]);
        }
      },
    );
  }

  Widget _buildListViewCard(BuildContext context, Student student) {
    return GestureDetector(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              // pass the student object to new screen
              return DetailStudent(student: student);
            })),
        child: AbsorbPointer(
            child: Container(
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
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.centerLeft,
                          child: new CircleAvatar(
                            backgroundColor: Colors.brown,
                            backgroundImage: !(student.avatar == null ||
                                    student.avatar.isEmpty)
                                ? NetworkImage(
                                    student.avatar,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.normal,
                                      fontWeight: EdTechFontWeight.semibold,
                                      color: EdTechColors.textBlackColor)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                  'Ngày sinh: ${EdTechConvertData.convertTimeString(student.dob)}',
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.small,
                                      fontWeight: EdTechFontWeight.normal,
                                      color: EdTechColors.textBlackColor)),
                              SizedBox(
                                height: 2,
                              ),
                              Text('Địa chỉ: ${student.address}',
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: EdTechFontSizes.small,
                                      fontWeight: EdTechFontWeight.normal,
                                      color: EdTechColors.textBlackColor)),
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
        )));
  }
}
