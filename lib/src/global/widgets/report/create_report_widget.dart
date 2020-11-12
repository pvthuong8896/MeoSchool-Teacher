import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_color.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';

class CreateReportWidget extends StatelessWidget {
  final ReportCategory category;
  final action;
  final TextEditingController editingController;
  final isEditting;
  const CreateReportWidget({Key key, this.category, this.action, this.editingController, this.isEditting}) : super(key: key);

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
            Text(isEditting ? "Sửa nội dung" : "Thêm nội dung",
                style: TextStyle(
                    color: EdTechColors.textBlackColor,
                    fontSize: EdTechFontSizes.medium,
                    fontWeight: EdTechFontWeight.semibold)),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(category.name,
                    style: TextStyle(
                        color: EdTechColors.mainColor,
                        fontSize: EdTechFontSizes.small,
                        fontWeight: EdTechFontWeight.medium)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: EdTechColors.dividerColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: editingController,
                style: TextStyle(
                    fontSize: EdTechFontSizes.normal,
                    color: EdTechColors.textColor,
                    fontWeight: EdTechFontWeight.medium),
                decoration: InputDecoration(
                    hintText: "Nội dung",
                    hintStyle: TextStyle(
                      fontSize: EdTechFontSizes.normal,
                      color: EdTechColors.textColor,
                      fontWeight: EdTechFontWeight.normal,
                    ),
                    border: InputBorder.none),
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
                        "Gửi",
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
}
