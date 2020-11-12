import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/resources/notification/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationWidget {
  Widget buildNotificationWidget(BuildContext context, Color color) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            'assets/img/icons/notification.svg',
            height: 20,
            width: 20,
            color: color,
          ),
          onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NotificationScreen();
          })),
        ),
        Positioned(
            top: 11.0,
            right: 11.0,
            child: Container(
              height: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              constraints: BoxConstraints(minWidth: 12.0),
              alignment: Alignment.center,
              child: Text(
                DataSingleton.instance.numberOfNoti > 0
                    ? (DataSingleton.instance.numberOfNoti > 99
                    ? "99+"
                    : "${DataSingleton.instance.numberOfNoti}")
                    : "",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              decoration: BoxDecoration(
                  color: DataSingleton.instance.numberOfNoti > 0
                      ? Colors.red[600]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0)),
            ))
      ],
    );
  }
}
