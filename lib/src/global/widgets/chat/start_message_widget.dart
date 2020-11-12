import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:flutter/material.dart';

class StartMessageWidget extends StatelessWidget {
  const StartMessageWidget(
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .75),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: EdTechColors.backgroundTime),
              height: 26,
              padding:
              EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Text(
                "Hãy bắt đầu cuộc trò chuyện nào 👏",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: EdTechColors.textWhiteColor),
              ),),
          ],
        ),
        );
  }
}
