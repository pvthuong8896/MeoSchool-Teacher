import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_color.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:flutter/material.dart';

class CreateStoryWidget extends StatelessWidget {
  final BuildContext context;
  final TeacherBloc teacherBloc;
  final actionFunc;
  final List<String> listAction;
  final TextEditingController editingController;
  final isEditing;
  const CreateStoryWidget(
      {Key key,
      this.context,
      this.teacherBloc,
      this.listAction,
      this.actionFunc,
      this.editingController,
      this.isEditing})
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
            Text("Thêm tiểu sử",
                style: TextStyle(
                    color: EdTechColors.textBlackColor,
                    fontSize: EdTechFontSizes.medium,
                    fontWeight: EdTechFontWeight.semibold)),
            SizedBox(
              height: 20,
            ),
            _fieldDropDown(listAction),
            SizedBox(
              height: 10,
            ),
            TextField(
              minLines: 1,
              maxLines: 5,
              controller: editingController,
              style: TextStyle(
                  fontSize: EdTechFontSizes.normal,
                  color: EdTechColors.textBlackColor,
                  fontWeight: EdTechFontWeight.medium),
              decoration: InputDecoration(
                  labelText: "Nội dung",
                  labelStyle: TextStyle(
                    fontSize: EdTechFontSizes.normal,
                    color: EdTechColors.mainColor,
                    fontWeight: EdTechFontWeight.medium,
                  ),
                  hintStyle: TextStyle(
                    fontSize: EdTechFontSizes.normal,
                    color: EdTechColors.textColor,
                    fontWeight: EdTechFontWeight.normal,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: EdTechColors.mainColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: EdTechColors.mainColor))),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: FlatButton(
                      onPressed: actionFunc,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        isEditing ? "Sửa tiểu sử" : "Thêm tiểu sử",
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

  _fieldDropDown(List<String> theList) {
    return new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Loại tiểu sử",
            labelStyle: TextStyle(
              fontSize: EdTechFontSizes.normal,
              color: EdTechColors.mainColor,
              fontWeight: EdTechFontWeight.medium,
            ),
            contentPadding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
              color: EdTechColors.mainColor,
            )),
          ),
          child: new DropdownButtonHideUnderline(
              child: DropdownButton(
            icon: Icon(
              Icons.arrow_drop_down,
              size: EdTechIconSizes.medium,
              color: EdTechColors.mainColor,
            ),
            value: teacherBloc.storyActionSelected,
            isDense: true,
            disabledHint: Text(
              teacherBloc.storyActionSelected,
              style: TextStyle(
                fontSize: EdTechFontSizes.normal,
                color: EdTechColors.timeColor,
                fontWeight: EdTechFontWeight.medium,
              ),
            ),
            onChanged: isEditing ? null : (String newValue) {
              teacherBloc.setstoryActionSelected(newValue);
              state.didChange(newValue);
              print('The List result = ' + teacherBloc.storyActionSelected);
            },
            items: theList.map((String value) {
              return new DropdownMenuItem(
                value: value,
                child: new Text(
                  value,
                  style: TextStyle(
                    fontSize: EdTechFontSizes.normal,
                    color: EdTechColors.textBlackColor,
                    fontWeight: EdTechFontWeight.medium,
                  ),
                ),
              );
            }).toList(),
          )),
        );
      },
    );
  }
}
