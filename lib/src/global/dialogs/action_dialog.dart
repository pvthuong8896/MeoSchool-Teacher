import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class ActionDialog {
  static void showActionDialog(BuildContext context, String title,
      String message, String ignore, String action, actionFunction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: TextStyle(
              color: EdTechColors.textBlackColor,
              fontWeight: FontWeight.w700,
              fontSize: EdTechFontSizes.medium,
            )),
        content: Text(message,
            style: TextStyle(
              color: EdTechColors.textColor,
              fontWeight: EdTechFontWeight.normal,
              fontSize: EdTechFontSizes.normal,
            )),
        actions: [
          new FlatButton(
              child: Text(ignore,
                  style: TextStyle(
                    color: EdTechColors.textColor,
                    fontWeight: EdTechFontWeight.medium,
                    fontSize: EdTechFontSizes.normal,
                  )),
              onPressed: () => Navigator.of(context).pop(ActionDialog)),
          new FlatButton(
            child: Text(action,
                style: TextStyle(
                  color: EdTechColors.mainColor,
                  fontWeight: EdTechFontWeight.semibold,
                  fontSize: EdTechFontSizes.normal,
                )),
            onPressed: () {
              Navigator.of(context).pop(ActionDialog);
              actionFunction();
            },
          ),
        ],
      ),
    );
  }

  static hideActionDialog(BuildContext context) {
    Navigator.of(context).pop(ActionDialog);
  }
}
