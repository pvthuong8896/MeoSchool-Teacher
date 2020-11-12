import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_color.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:flutter/material.dart';

class AddCategoryReportWidget extends StatelessWidget {
  final listIcons;
  final action;
  final TeacherBloc teacherBloc;
  final TextEditingController editingController;
  final isEditting;
  const AddCategoryReportWidget(
      {Key key,
      this.action,
      this.editingController,
      this.listIcons,
      this.teacherBloc,
        this.isEditting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 30.0),
        width: EdTechAppStyles(context).width - 70,
        decoration: BoxDecoration(
          color: EdTechColors.backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            Text(isEditting ? "Sửa đánh giá" : "Thêm đánh giá",
                style: TextStyle(
                    color: EdTechColors.textBlackColor,
                    fontSize: EdTechFontSizes.medium,
                    fontWeight: EdTechFontWeight.semibold)),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                isEditting ? (){} : _settingModalBottomSheet(context);
              },
              child: StreamBuilder(
                stream: teacherBloc.selectedIconReportController,
                builder: (context, snapshot) => Container(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: new BoxDecoration(
                          color: EdTechColors.textColor,
                          image: new DecorationImage(
                            image: listIcons.length > 0
                                ? NetworkImage(teacherBloc.iconReportUrl)
                                : AssetImage("assets/img/avatar_default.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: EdTechColors.textColor,
                            width: 0.1,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Icon(Icons.arrow_drop_down,
                            size: EdTechIconSizes.medium,
                            color: EdTechColors.textColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Tên loại đánh giá",
                    style: TextStyle(
                        color: EdTechColors.mainColor,
                        fontSize: EdTechFontSizes.small,
                        fontWeight: EdTechFontWeight.medium)),
              ],
            ),
            Container(
              child: TextField(
                controller: editingController,
                style: TextStyle(
                    fontSize: EdTechFontSizes.normal,
                    fontWeight: EdTechFontWeight.medium,
                    color: EdTechColors.textBlackColor),
                decoration: InputDecoration(
                  isDense: true,
                  alignLabelWithHint: true,
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: EdTechColors.mainColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: EdTechColors.mainColor)),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                      onPressed: action,
                      child: Text(
                        "Lưu đánh giá",
                        style: TextStyle(
                            color: EdTechColors.textWhiteColor,
                            fontWeight: EdTechFontWeight.medium,
                            fontSize: EdTechFontSizes.normal),
                      ),
                    ),
                    height: (33.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: EdTechColors.mainColor))
              ],
            )
          ],
        ));
  }

  void _settingModalBottomSheet(BuildContext context) {
    final size = (EdTechAppStyles(context).width - 100) / 4;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10),
            color: EdTechColors.backgroundColor,
            child: GridView.builder(
              itemCount: listIcons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                final icon = listIcons[index];
                return InkWell(
                  onTap: () {
                    teacherBloc.setIconReportUrl(icon);
                    teacherBloc.selectedReportIcon();
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.all(10),
                      color: Colors.transparent,
                      child: Image.network(
                        icon,
                        height: size,
                        width: size,
                        fit: BoxFit.contain,
                      )),
                );
              },
            ),
          );
        });
  }
}
