import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void showToastMessage(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: EdTechColors.textColor,
        textColor: EdTechColors.textWhiteColor,
        fontSize: EdTechFontSizes.normal);
  }
}
