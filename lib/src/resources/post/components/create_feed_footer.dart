import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateFeedFooter extends StatelessWidget {
  final bool readyPost;
  final onPressMedia;
  final onPressCreatePost;
  const CreateFeedFooter(
      {Key key,
      @required this.readyPost,
      @required this.onPressMedia,
      @required this.onPressCreatePost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 0.5,
          color: EdTechColors.dividerColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: onPressMedia,
                child: Row(
                  children: [
                    Icon(Icons.add_a_photo,
                        size: EdTechIconSizes.normal,
                        color: EdTechColors.textColor),
                    SizedBox(width: 8),
                    Text(
                      "Ảnh/Video",
                      style: TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          color: EdTechColors.textColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (readyPost) {
                    onPressCreatePost();
                  }
                },
                child: Container(
                    height: 28,
                    width: 105,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: readyPost
                          ? EdTechColors.mainColor
                          : EdTechColors.timeColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Text(
                      "Đăng bài",
                      style: TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          color: EdTechColors.textWhiteColor,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
