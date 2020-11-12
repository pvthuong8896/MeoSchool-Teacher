import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class LoadingDataView {
  static Widget showLoadingDataView(BuildContext context, String message, {Color color}) {
    return Center(
      child: Container(
        color: Colors.transparent,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            edTechLoaderWidget(25.0, 25.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: new Text(
                message,
                style: TextStyle(fontSize: EdTechFontSizes.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
