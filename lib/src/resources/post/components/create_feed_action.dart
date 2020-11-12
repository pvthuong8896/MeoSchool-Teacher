import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateFeedAction extends StatelessWidget {
  final title;
  final onPress;
  const CreateFeedAction({Key key, @required this.title, @required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        width: double.infinity,
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 0),
                      color: EdTechColors.dividerColor,
                      spreadRadius: 0)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: EdTechIconSizes.big,
                  height: EdTechIconSizes.big,
                  child: ClipOval(
                    child: (DataSingleton.instance.edUser.avatar == null ||
                        DataSingleton.instance.edUser.avatar.isEmpty)
                        ? Image.asset(
                      'assets/img/avatar_default.png',
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      DataSingleton.instance.edUser.avatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: EdTechFontWeight.w600,
                    color: EdTechColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
