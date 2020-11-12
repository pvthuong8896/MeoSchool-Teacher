import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/conversation/info_group_screen.dart';
import 'package:flutter/material.dart';

class CreateGroupConversationScreen extends StatefulWidget {
  CreateGroupConversationScreen({Key key}) : super(key: key);

  @override
  _CreateGroupConversationScreenState createState() =>
      _CreateGroupConversationScreenState();
}

class _CreateGroupConversationScreenState
    extends State<CreateGroupConversationScreen> {
  List<Parents> listParents = [];
  bool startCreateGroup = false;

  @override
  void initState() {
    listParents = DataSingleton.instance.listParents;
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
          actions: [
            InkWell(
              onTap: () {
                if(startCreateGroup) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoGroupScreen()),
                  );
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Tiếp tục",
                    style: TextStyle(
                        fontSize: EdTechFontSizes.normal,
                        fontWeight: EdTechFontWeight.semibold,
                        color: startCreateGroup ? EdTechColors.textBlackColor : EdTechColors.timeColor),
                  )),
            )
          ],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tạo nhóm chat",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        body: getBody());
  }

  getBody() => _buildListClassoom();

  Widget _buildListClassoom() => Container(
      color: EdTechColors.backgroundColor,
      child: ListView.builder(
          itemCount: listParents.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildCardCreateGroup();
            } else {
              return _buildCardParent(listParents[index - 1]);
            }
          }));

  Widget _buildCardCreateGroup() => Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          Text("Thành viên: ",
              style: new TextStyle(
                  fontSize: EdTechFontSizes.normal,
                  fontWeight: EdTechFontWeight.medium,
                  color: EdTechColors.textBlackColor)),
        ],
      ));

  Widget _buildCardParent(Parents parents) => InkWell(
      onTap: () {
        parents.isSelected = !parents.isSelected;
        for (var parents in listParents) {
          if (parents.isSelected) {
            startCreateGroup = true;
            break;
          }
          startCreateGroup = false;
        }
        setState(() {
        });
      },
      child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
              ),
              Container(
                child: parents.isSelected
                    ? Icon(Icons.check_circle,
                        size: EdTechIconSizes.normal,
                        color: EdTechColors.mainColor)
                    : Icon(Icons.radio_button_unchecked,
                        size: EdTechIconSizes.normal,
                        color: EdTechColors.dividerColor),
              )
            ],
          )));
}
