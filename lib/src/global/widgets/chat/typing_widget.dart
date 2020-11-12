import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_color.dart';
import 'package:flutter/material.dart';
import 'mycircleavatar.dart';
import 'jumping_dots_widget.dart';

class TypingMessageWidget extends StatelessWidget {
  final BlaUser user;
  const TypingMessageWidget(
      {Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          MyCircleAvatar(
            imgUrl: user.avatar,
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: JumpingDotsProgressIndicator(
              color: EdTechColors.dividerColor,
              dotSpacing: 5.0,
              fontSize: 10.0,
            ),
          )
        ],
      ),
    );
  }
}