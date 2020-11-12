import 'package:bla_chat_sdk/BlaChannelType.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/conversation/create_group_conversation.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';

class CreateConversationScreen extends StatefulWidget {
  CreateConversationScreen({Key key}) : super(key: key);

  @override
  _CreateConversationScreenState createState() =>
      _CreateConversationScreenState();
}

class _CreateConversationScreenState extends State<CreateConversationScreen> {
  TeacherBloc teacherBloc;
  List<Parents> listParents = [];
  ChatBloc chatBloc;

  @override
  void initState() {
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    teacherBloc
        .getListParents(DataSingleton.instance.classSelected.classroom_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tin nhắn mới",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        body: getBody());
  }

  getBody() => StreamBuilder(
      stream: teacherBloc.listParentsController,
      builder: (context, snapshot) {
        if (snapshot.data == LOADING) {
          return LoadingDataView.showLoadingDataView(context, "Đang tải...");
        }
        if (snapshot.data == EMPTY) {
          return NodataView.showNodataView(
              context, "Chưa có phụ huynh trong lớp.");
        }
        if (snapshot.data == DONE) {
          listParents = teacherBloc.listParents;
          DataSingleton.instance.listParents = listParents;
          return listParents.isEmpty
              ? NodataView.showNodataView(
                  context, "Chưa có phụ huynh trong lớp.")
              : _buildListClassoom();
        }
        return LoadingDataView.showLoadingDataView(context, "Đang tải...");
      });

  Widget _buildListClassoom() => Container(
    color: EdTechColors.backgroundColor,
    child: ListView.builder(
        itemCount: listParents.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateGroupConversationScreen()),
                );
              },
              child: _buildCardCreateGroup(),
            );
          }
          return new GestureDetector(
              onTap: () {
                List<int> user_ids = [];
                user_ids.add(DataSingleton.instance.edUser.user_id);
                user_ids.add(listParents[index - 1].user_id);
                Map<String, dynamic> custom_data = {
                  "classroom_id": DataSingleton.instance.classSelected.classroom_id,
                  "description": DataSingleton.instance.classSelected.subject.name
                };
                chatBloc.createChannel("", user_ids, CHAT_DIRECT, "", custom_data, (_) {
                  Navigator.of(context).pop();
                }, (_) {});
              },
              child: _buildCardParent(listParents[index - 1]));
        })
  );

  Widget _buildCardCreateGroup() => Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: EdTechColors.dividerColor,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: Icon(Icons.group, size: EdTechIconSizes.normal, color: EdTechColors.textColor,)
          ),
          SizedBox(width: 13),
          Text("Tạo nhóm chat",
              style: new TextStyle(
                  fontSize: EdTechFontSizes.normal,
                  fontWeight: EdTechFontWeight.medium,
                  color: EdTechColors.textBlackColor)),
        ],
      ));

  Widget _buildCardParent(Parents parents) => Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            child: new CircleAvatar(
              backgroundColor: EdTechColors.dividerColor,
              backgroundImage: parents.avatar != null
                  ? NetworkImage(parents.avatar)
                  : AssetImage('assets/img/avatar_default.png'),
            ),
          ),
          SizedBox(width: 13),
          Text(parents.name,
              style: new TextStyle(
                  fontSize: EdTechFontSizes.normal,
                  fontWeight: EdTechFontWeight.medium,
                  color: EdTechColors.textBlackColor)),
        ],
      ));
}
