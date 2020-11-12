import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/class_room.dart';
import 'package:edtechteachersapp/src/resources/tabbar/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListClassRoom extends StatelessWidget {
  final List<ClassRoom> listClassRoom;

  const ListClassRoom(
      {Key key, @required this.listClassRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listClassRoom.length,
        itemBuilder: (BuildContext context, int i) {
          var item = listClassRoom[i];
          return new GestureDetector(
              onTap: (){
                DataSingleton.instance.classSelected = item;
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return TabbarScreen();
                }));
              }, child: _buildCardClass(item));
        });
  }

  Widget _buildCardClass(ClassRoom classroom) => Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      margin: EdgeInsets.fromLTRB(0, 15, 8, 15),
                      child: new CircleAvatar(
                        backgroundColor: Colors.brown,
                        backgroundImage: classroom.icon != null
                            ? NetworkImage(classroom.icon)
                            : AssetImage('assets/img/avatar_default.png'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(classroom.name,
                            style: new TextStyle(
                                fontSize: EdTechFontSizes.simple,
                                fontWeight: EdTechFontWeight.semibold,
                                color: EdTechColors.textBlackColor)),
                        SizedBox(height: 2),
                        Text(
                            "${classroom.total_students} học sinh, ${classroom.total_parents} phụ huynh",
                            style: new TextStyle(
                                fontSize: EdTechFontSizes.normal,
                                fontWeight: EdTechFontWeight.normal,
                                color: EdTechColors.textBlackColor))
                      ],
                    ),
                  ],
                ),
                Container(
                  child: Icon(Icons.arrow_forward_ios,
                      size: EdTechIconSizes.small,
                      color: EdTechColors.textBlackColor),
                )
              ]),
          Container(height: 1, color: EdTechColors.dividerColor),
          SizedBox(height: 5)
        ],
      ));
}
