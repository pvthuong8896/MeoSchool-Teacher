import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 120,
          decoration: new BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: new BorderRadius.all(
                Radius.circular(10.0)
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              edTechLoaderWidget(25.0, 25.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: new Text(
                  message,
                  style: TextStyle(fontSize: EdTechFontSizes.normal, color: EdTechColors.textBlackColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}