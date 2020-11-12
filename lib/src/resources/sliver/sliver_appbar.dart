import 'package:flutter/material.dart';

class Sliver {
  Widget buildSliverAppBar(String title, Color color, TextStyle style) {
    return Container(
      padding: EdgeInsets.only(left: 40, right: 20),
      alignment: Alignment.topLeft,
      height: 50,
      width: double.infinity,
      color: color,
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
