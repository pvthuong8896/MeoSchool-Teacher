import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/material.dart';

class ReportActionWidget extends StatelessWidget {
  final double size;
  final String iconLink;
  final Icon icon;
  final String name;

  const ReportActionWidget(
      {Key key, this.size, this.iconLink, this.icon, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon != null
                ? icon
                : Image.network(
                    iconLink,
                    height: 45.0,
                    width: 45.0,
                    fit: BoxFit.contain,
                  ),
            SizedBox(height: 10),
            Text(
              name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: EdTechFontSizes.small,
                fontWeight: EdTechFontWeight.semibold,
                color: EdTechColors.textBlackColor,
              ),
            ),
          ],
        ));
  }
}
