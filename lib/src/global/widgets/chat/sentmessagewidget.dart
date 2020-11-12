import 'package:bla_chat_sdk/BlaMessage.dart';
import 'package:bla_chat_sdk/BlaMessageType.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:flutter/material.dart';

class SentMessageWidget extends StatelessWidget {
  final BlaMessage message;
  final BlaMessage beforeMessage;
  final BlaMessage afterMessage;

  const SentMessageWidget(
      {Key key, this.message, this.beforeMessage, this.afterMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatting = false;
    if (beforeMessage != null) {
      chatting = beforeMessage.author.id == message.author.id;
    }
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
                ? SizedBox(
              height: 5,
            )
                : Container(),
            date != ''
                ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: EdTechColors.backgroundTime),
              height: 26,
              padding:
              EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Text(
                date,
                style: TextStyle(
                    fontSize: EdTechFontSizes.small,
                    fontWeight: FontWeight.w600,
                    color: EdTechColors.textWhiteColor),
              ),
            )
                : Container(),
            date != ''
                ? SizedBox(
              height: 10,
            )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: message.type == BlaMessageType.IMAGE
                        ? const EdgeInsets.fromLTRB(10, 12, 0, 5)
                        : const EdgeInsets.fromLTRB(10, 12, 10, 5),
                    decoration: BoxDecoration(
                      color: message.type == BlaMessageType.IMAGE
                          ? Colors.transparent
                          : EdTechColors.mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(messageBorder),
                        topRight: Radius.circular(messageBorder),
                        bottomLeft: Radius.circular(messageBorder),
                        bottomRight:
                        Radius.circular(chatting ? messageBorder : 0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        getContentOfMessage(),
                        SizedBox(
                          height: 5,
                        ),
                        message.type == BlaMessageType.IMAGE
                            ? Container()
                            : Container(
                            constraints: BoxConstraints(
                                maxWidth: 50 + EdTechIconSizes.small),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                getStatusMessage(),
                                SizedBox(width: 5),
                                Text(
                                    EdTechConvertData.messageTime(
                                        message.createdAt.toString()),
                                    style: TextStyle(
                                        fontSize:
                                        EdTechFontSizes.small * 0.85,
                                        color: EdTechColors.textWhiteColor))
                              ],
                            ))
                      ],
                    )),
              ],
            ),
          ],
        ));
  }

  Widget getContentOfMessage() {
    if (message.type == BlaMessageType.TEXT) {
      return Text(
        message.content.trim(),
        style: TextStyle(
            fontSize: EdTechFontSizes.simple,
            color: EdTechColors.textWhiteColor),
      );
    } else if (message.type == BlaMessageType.IMAGE) {
      return Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: !(message.content == null || message.content.isEmpty)
                ? Image.network(message.content,
                fit: BoxFit.cover, loadingBuilder: edTechImageLoader)
                : Image.asset(
              'assets/img/avatar_default.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              left: 5,
              bottom: 5,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black54),
                height: 20,
                child: Center(
                    child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getStatusMessage(),
//                            SizedBox(width: 5),
                            Text(
                                EdTechConvertData.messageTime(message.createdAt.toString()),
                                style: TextStyle(
                                    fontSize: 10,
                                    color: EdTechColors.textWhiteColor))
                          ],
                        ))),
              ))
        ],
      );
    } else {
      return Text(
        message.content,
        style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textWhiteColor),
      );
    }
  }

  Widget getStatusMessage() {
    if (message.seenBy.length > 0) {
      return Icon(
        Icons.remove_red_eye,
        size: EdTechIconSizes.small,
        color: EdTechColors.textWhiteColor,
      );
    } else if (message.receivedBy.length > 0) {
      return Icon(
        Icons.done_all,
        size: EdTechIconSizes.small,
        color: EdTechColors.textWhiteColor,
      );
    } else {
      return Container();
    }
  }
}
