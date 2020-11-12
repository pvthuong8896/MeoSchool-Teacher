import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginFormInput extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final bool isObSecureText;
  final Stream stream;
  final FocusNode focusNode;
  final validator;

  const LoginFormInput(
      {Key key,
      @required this.title,
      @required this.textEditingController,
      @required this.isObSecureText,
      @required this.stream,
      @required this.focusNode,
      @required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) => Container(
              width: double.infinity,
              height: 68,
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                style: TextStyle(
                    fontSize: EdTechFontSizes.medium,
                    fontWeight: EdTechFontWeight.medium,
                    color: EdTechColors.textBlackColor),
                obscureText: isObSecureText,
                onChanged: (text) => validator(text),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: title,
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  labelStyle:
                      (focusNode.hasFocus || textEditingController.text != "")
                          ? TextStyle(
                              fontSize: EdTechFontSizes.medium,
                              color: EdTechColors.mainColor,
                              fontWeight: FontWeight.w700)
                          : TextStyle(
                              fontSize: EdTechFontSizes.normal,
                              color: EdTechColors.textColor.withOpacity(0.7),
                              fontWeight: FontWeight.w300),
                  suffix:
                      (textEditingController.text != "" && !snapshot.hasError)
                          ? Icon(Icons.check_circle,
                              color: EdTechColors.mainColor,
                              size: EdTechIconSizes.normal)
                          : SizedBox(height: EdTechIconSizes.normal),
                  contentPadding:
                      (focusNode.hasFocus || textEditingController.text != "")
                          ? EdgeInsets.fromLTRB(0, 8.0, 0, 9.0)
                          : EdgeInsets.fromLTRB(0, 8.0, 0, 12.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.7, color: EdTechColors.mainColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: textEditingController.text != ""
                          ? BorderSide(
                              width: 0.7, color: EdTechColors.mainColor)
                          : BorderSide(
                              width: 0.7,
                              color: EdTechColors.textColor.withOpacity(0.7))),
                ),
              ),
            ));
  }
}
