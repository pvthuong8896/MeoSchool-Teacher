import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/teacher/detail_teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherGridView extends StatelessWidget {
  final List<Teacher> listTeachers;

  const TeacherGridView(
      {Key key, @required this.listTeachers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = EdTechAppStyles(context).width;
    int numberItem = 3;
    double width =
        (screenWidth - 16 * 2 - 10 * (numberItem - 1)) / numberItem;
    double height = width * 1.5;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
      itemCount: listTeachers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: width / height,
        crossAxisCount: numberItem,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildGridViewCard(context, width, height, listTeachers[index]);
      },
    );
  }

  Widget _buildGridViewCard(BuildContext context, width, height, Teacher teacher) {
    return GestureDetector(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              // pass the student object to new screen
              return DetailTeacher(teacher: teacher);
            })),
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: (teacher.avatar == null || teacher.avatar.isEmpty)
                    ? Image.asset(
                  'assets/img/avatar_default.png',
                  height: width,
                  width: width,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  teacher.avatar,
                  height: width,
                  width: width,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(teacher.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: EdTechColors.textBlackColor,
                                fontWeight: EdTechFontWeight.bold,
                                fontSize: 13)),
                      ]))
            ],
          ),
        ));
  }
}
