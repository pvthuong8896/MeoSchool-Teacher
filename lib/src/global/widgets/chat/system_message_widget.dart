import 'package:bla_chat_sdk/BlaMessage.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:flutter/material.dart';

class SystemMessageWidget extends StatelessWidget {
  final BlaMessage message;
  final BlaMessage beforeMessage;
  final BlaMessage afterMessage;
  const SystemMessageWidget(
      {Key key, this.message, this.beforeMessage, this.afterMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = '';
    if (afterMessage == null) {
      date = EdTechConvertData.firstMessageDate(message.createdAt.toString());
    } else {
      date = EdTechConvertData.messageDate(
          message.createdAt.toString(), afterMessage.createdAt.toString());
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            date != ''
                ? Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: Text(
                      date,
                      style: TextStyle(
                          fontSize: EdTechFontSizes.small,
                          color: EdTechColors.timeColor),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .75),
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(messageBorder)
                      ),
                    ),
                    child: Text(
                      message.content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          color: EdTechColors.timeColor),
                    ),),
              ],
            ),
          ],
        ));
  }
}
