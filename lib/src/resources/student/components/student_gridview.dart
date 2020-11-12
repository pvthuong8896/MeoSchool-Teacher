import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../detail_student.dart';

class StudentGridView extends StatelessWidget {
  final List<Student> listStudents;

  const StudentGridView(
      {Key key, @required this.listStudents})
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
      itemCount: listStudents.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: width / height,
        crossAxisCount: numberItem,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          final selectedClass = DataSingleton.instance.classSelected;
          return GestureDetector(
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ListPostScreen();
                })),
            child: _buildGridViewCard(width, height, selectedClass.icon, selectedClass.name, ""),
          );
        } else {
          final student = listStudents[index - 1];
          return GestureDetector(
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return DetailStudent(student: student);
                })),
            child: _buildGridViewCard(width, height, student.avatar, student.name, student.dob),
          );
        }
      },
    );
  }

  Widget _buildGridViewCard(width, height, avatar, name, dob) {
    return Container(
      width: width,
      height: height,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: !(avatar == null || avatar.isEmpty)
                ? Image.network(
              avatar,
              height: width,
              width: width,
              fit: BoxFit.cover,
            )
                : Image.asset(
              'assets/img/avatar_default.png',
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
                Text(name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: EdTechColors.textBlackColor,
                        fontWeight: EdTechFontWeight.bold,
                        fontSize: 13)),
                SizedBox(height: 1)
              ],
            ),
          )
        ],
      ),
    );
  }
}
