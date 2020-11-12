import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/chat/mycircleavatar.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'dart:async';
import 'dart:io';

class GroupDetailScreen extends StatefulWidget {
  BlaChannel conversation;
  String myId;

  GroupDetailScreen({Key key, this.conversation, this.myId}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  ChatBloc chatBloc;
  List<BlaUser> listUsersOfChannel = [];
  BuildContext _scaffoldContext;
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
    getData();
  }

  void getData() async {
    var result = await BlaChatSdk.instance
        .getUsersInChannel(this.widget.conversation.id);
    this.setState(() {
      listUsersOfChannel = result;
    });
  }

  void removeConversation() async {
    try {
      var result = await BlaChatSdk.instance.deleteChannel(this.widget.conversation);
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    } catch (e) {
      ToastMessage.showToastMessage(context, e.toString());
    }
  }

  void leaveConversation() async {
    try {
      var result = await BlaChatSdk.instance.leaveChannel(this.widget.conversation);
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    } catch(e) {
      ToastMessage.showToastMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return getBody();
        }));
  }

  getBody() {
    var desc = '';
    if (this.widget.conversation.type == BlaChannelType.DIRECT) {
      for (BlaUser user in listUsersOfChannel) {
        if (user.id != this.widget.myId) {
          if (user.online) {
            desc = 'Đang hoạt động';
          } else {
            if (user.lastActiveAt != null) {
              desc =
                  'Đã hoạt động ${EdTechConvertData.messageDate(user.lastActiveAt.millisecondsSinceEpoch.toString(), DateTime.now().millisecondsSinceEpoch.toString())}';
            } else {
              desc = 'Không hoạt động';
            }
          }
        }
      }
    } else {
      var countOnline = 0;
      for (BlaUser user in listUsersOfChannel) {
        if (user.online) {
          countOnline += 1;
        }
      }
      desc =
          '${listUsersOfChannel.length} thành viên, ${countOnline} hoạt động';
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(this.widget.conversation.avatar),
                    backgroundColor: EdTechColors.grey,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text(
                      this.widget.conversation.name,
                      style: TextStyle(
                          fontSize: EdTechFontSizes.simple,
                          fontWeight: EdTechFontWeight.semibold,
                          color: EdTechColors.textBlackColor),
                      overflow: TextOverflow.clip,
                    )),
                    desc != ''
                        ? Text(
                            desc,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: EdTechColors.grey),
                            overflow: TextOverflow.clip,
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 5,
            color: EdTechColors.dividerColor,
          ),
          this.widget.conversation.type == BlaChannelType.GROUP
              ? GestureDetector(
                  onTap: () {
                    ActionDialog.showActionDialog(context, "Rời cuộc trò chuyện",
                        "Bạn có chắc chắn muốn rời cuộc trò chuyện?", "Huỷ", "Rời", () {
                          this.removeConversation();
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          size: 30,
                          color: EdTechColors.mainColor,
                        ),
                        Container(
                          width: 20,
                        ),
                        Text(
                          "Rời khỏi nhóm",
                          style: TextStyle(
                              color: EdTechColors.mainColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                )
              : GestureDetector(
            onTap: () {
              ActionDialog.showActionDialog(context, "Xóa cuộc trò chuyện",
                  "Bạn có chắc chắn muốn xóa cuộc trò chuyện?", "Huỷ", "Xoá", () {
                    this.removeConversation();
                  });
            },
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    size: 30,
                    color: EdTechColors.mainColor,
                  ),
                  Container(
                    width: 20,
                  ),
                  Text(
                    "Xóa cuộc trò chuyện",
                    style: TextStyle(
                        color: EdTechColors.mainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 5,
            color: EdTechColors.dividerColor,
          ),
          Expanded(
            child: _buildListMember(),
          )
        ],
      ),
    );
  }

  Widget _buildListMember() {
    return ListView.builder(
        itemCount: listUsersOfChannel.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildCardCreateGroup();
          } else {
            return _buildCardParent(listUsersOfChannel[index - 1]);
          }
        });
  }

  Widget _buildCardCreateGroup() => Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          Text("Thành viên",
              style: new TextStyle(
                  fontSize: 20,
                  fontWeight: EdTechFontWeight.bold,
                  color: EdTechColors.textBlackColor)),
        ],
      ));

  Widget _buildCardParent(BlaUser user) => InkWell(
      child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                child: new CircleAvatar(
                  backgroundColor: EdTechColors.dividerColor,
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar)
                      : AssetImage('assets/img/avatar_default.png'),
                ),
              ),
              SizedBox(width: 13),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user.name,
                      style: new TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          fontWeight: FontWeight.w600,
                          color: EdTechColors.textBlackColor)),
                  Text(
                    user.online ? "Đang hoạt động" : "Không hoạt động",
                    style: TextStyle(color: EdTechColors.grey, fontSize: 12),
                  )
                ],
              ),
            ],
          )));
}
