import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTargetWidget extends StatelessWidget {
  final String title;
  final icon;
  const PostTargetWidget({Key key, @required this.title, @required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(
            icon,
            color: EdTechColors.textBlackColor,
            size: EdTechIconSizes.small,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textBlackColor,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.normal,
        ),
      ],
    );
  }
}