import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';
import 'package:bla_chat_sdk/BlaMessage.dart';
import 'package:bla_chat_sdk/BlaMessageType.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/material.dart';
import 'mycircleavatar.dart';

class ReceivedMessagesWidget extends StatelessWidget {
  final BlaMessage beforeMessage;
  final BlaMessage afterMessage;
  final BlaMessage message;
  final BlaChannel channel;

  const ReceivedMessagesWidget(
      {Key key,
      @required this.message,
      this.beforeMessage,
      this.afterMessage,
      this.channel})
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
    if (message.type == BlaMessageType.IMAGE) {
      return buildImageMessage(context, chatting, date);
    } else {
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
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  chatting
                      ? Container(width: 40)
                      : MyCircleAvatar(
                          imgUrl: message.author.avatar,
                        ),
                  SizedBox(width: 3.0),
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: message.type == BlaMessageType.IMAGE
                          ? const EdgeInsets.fromLTRB(0, 5, 7, 5)
                          : const EdgeInsets.fromLTRB(10, 5, 7, 5),
                      decoration: BoxDecoration(
                        color: message.type == BlaMessageType.IMAGE
                            ? Colors.transparent
                            : EdTechColors.textWhiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(messageBorder),
                          bottomLeft:
                              Radius.circular(chatting ? messageBorder : 0),
                          bottomRight: Radius.circular(messageBorder),
                          topLeft: Radius.circular(messageBorder),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              channel.type == BlaChannelType.GROUP
                                  ? Text(
                                      "${message.author.name}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: EdTechFontSizes.small,
                                          fontWeight: EdTechFontWeight.semibold,
                                          color: EdTechColors.mainColor),
                                    )
                                  : Container(width: 40),
                              SizedBox(
                                height: channel.type == BlaChannelType.GROUP
                                    ? 3
                                    : 5,
                              ),
                              getContentOfMessage()
                            ],
                          ),
                          Text(
                            EdTechConvertData.messageTime(
                                message.createdAt.toString()),
                            style: TextStyle(
                                fontSize: EdTechFontSizes.small * 0.85,
                                color: EdTechColors.timeColor),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ));
    }
  }

  Widget getContentOfMessage() {
    if (message.type == BlaMessageType.TEXT) {
      return Text(
        message.content.trim(),
        style: TextStyle(
            fontSize: EdTechFontSizes.simple,
            color: EdTechColors.textBlackColor),
      );
    } else if (message.type == BlaMessageType.IMAGE) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: !(message.content == null || message.content.isEmpty)
            ? Image.network(message.content,
                fit: BoxFit.cover, loadingBuilder: edTechImageLoader)
            : Image.asset(
                'assets/img/avatar_default.png',
                fit: BoxFit.cover,
              ),
      );
    } else {
      return Text(
        message.content,
        style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textBlackColor),
      );
    }
  }

  Widget buildImageMessage(BuildContext context, bool chatting, String date) {
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
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                MyCircleAvatar(
                  imgUrl: message.author.avatar,
                ),
                SizedBox(width: 3.0),
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: message.type == BlaMessageType.IMAGE
                        ? const EdgeInsets.fromLTRB(0, 5, 7, 5)
                        : const EdgeInsets.fromLTRB(10, 5, 7, 5),
                    decoration: BoxDecoration(
                      color: message.type == BlaMessageType.IMAGE
                          ? Colors.transparent
                          : EdTechColors.textWhiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(messageBorder),
                        bottomLeft:
                            Radius.circular(chatting ? messageBorder : 0),
                        bottomRight: Radius.circular(messageBorder),
                        topLeft: Radius.circular(messageBorder),
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: !(message.content == null ||
                                  message.content.isEmpty)
                              ? Image.network(message.content,
                                  fit: BoxFit.cover,
                                  loadingBuilder: edTechImageLoader)
                              : Image.asset(
                                  'assets/img/avatar_default.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                            right: 5,
                            bottom: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black54),
                              height: 20,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Center(
                                child: Text(
                                  EdTechConvertData.messageTime(
                                      message.createdAt.toString()),
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: EdTechColors.textWhiteColor),
                                ),
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          ],
        ));
  }
}
