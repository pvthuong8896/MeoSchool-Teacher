import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/global/circle_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../index.dart';

class CreateFeedHeader extends StatelessWidget {
  final bool createForAStudent;
  final Widget targetPost;
  const CreateFeedHeader({Key key, @required this.createForAStudent, @required this.targetPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatarWidget(size: 44, avatar: DataSingleton.instance.edUser.avatar),
        SizedBox(
          width: 11,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DataSingleton.instance.edUser.name,
              style: TextStyle(
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.normal,
                  fontWeight: EdTechFontWeight.semibold),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                if (!createForAStudent) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return TargetPostScreen();
                  }));
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                  border: new Border.all(
                    color: EdTechColors.timeColor,
                    width: 0.5,
                  ),
                ),
                child: targetPost,
              ),
            )
          ],
        ),
      ],
    );
  }
}