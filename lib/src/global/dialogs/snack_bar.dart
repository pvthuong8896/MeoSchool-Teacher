import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class SnackBarDialog {
  static final height = 35.0;
  static void showLoadingView(BuildContext context, String title) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
            content: Container(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: EdTechColors.textWhiteColor,
                        fontWeight: EdTechFontWeight.medium,
                        fontSize: EdTechFontSizes.normal,
                      )),
                  SizedBox(
                    child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(EdTechColors.textWhiteColor),
                    ),
                    height: 20.0,
                    width: 20.0,
                  )
                ],
              ),
            )
        ),
      );
  }

  static void showSuccessView(BuildContext context, String title) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
            content: Container(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: EdTechColors.textWhiteColor,
                        fontWeight: EdTechFontWeight.medium,
                        fontSize: EdTechFontSizes.normal,
                      )),
                ],
              ),
            )
        ),
      );
  }

  static void showErrorView(BuildContext context, String title) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Container(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                      color: EdTechColors.textWhiteColor,
                      fontWeight: EdTechFontWeight.medium,
                      fontSize: EdTechFontSizes.normal,
                    )),
                Icon(Icons.error, size: EdTechFontSizes.medium, color: EdTechColors.textWhiteColor)],
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
  }

  static void showNoImageView(BuildContext context, String title) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
            content: Container(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: EdTechColors.textWhiteColor,
                        fontWeight: EdTechFontWeight.medium,
                        fontSize: EdTechFontSizes.normal,
                      )),
                ],
              ),
            )
        ),
      );
  }
}
