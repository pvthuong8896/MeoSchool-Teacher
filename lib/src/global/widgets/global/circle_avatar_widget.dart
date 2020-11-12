import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final double size;
  final String avatar;

  const CircleAvatarWidget({Key key, @required this.size, @required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: (avatar == null || avatar.isEmpty)
            ? Image.asset('assets/img/avatar_default.png',
            height: size, width: size, fit: BoxFit.cover)
            : Image.network(avatar,
            height: size,
            width: size,
            fit: BoxFit.cover,
            loadingBuilder: edTechImageLoader),
      )
    );
  }
}
