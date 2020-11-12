import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/material.dart';

class NodataView {
  static Widget showNodataView(BuildContext context, String message) {
    return Center(
      child: Container(
        color: Colors.transparent,
        child: new Text(
          message,
          style: TextStyle(
            color: EdTechColors.textBlackColor,
            fontWeight: EdTechFontWeight.normal,
            fontSize: EdTechFontSizes.normal,
          ),
        ),
      ),
    );
  }
}