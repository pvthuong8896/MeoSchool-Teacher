import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

Widget edTechImageLoader(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
  return Center(
      child: edTechLoaderWidget(20.0, 20.0)
  );
}

Widget edTechLoaderWidget(double height, double width) {
  return SizedBox(
    child: CircularProgressIndicator(
      strokeWidth: 1.0,
      valueColor: new AlwaysStoppedAnimation<Color>(EdTechColors.mainColor),
    ),
    height: height,
    width: width,
  );
}