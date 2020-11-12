import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
// show student code and user can copy it on tap

class StudentCode extends StatefulWidget {
  final codeOfStudent;
  StudentCode({Key key, @required this.codeOfStudent}) : super(key: key);

  @override
  _StudentCodeState createState() => new _StudentCodeState();
}

class _StudentCodeState extends State<StudentCode> {
  bool _codeCopied;
  @override
  void initState() {
    super.initState();
    _codeCopied = false;
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _codeCopied = true;
          });
          Clipboard.setData(new ClipboardData(text: widget.codeOfStudent));
        },
        child: Container(
          height: 36.0,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              Center(
                  child: SelectableText(
                widget.codeOfStudent,
                style: TextStyle(
                    fontSize: EdTechFontSizes.simple, color: EdTechColors.textBlackColor, fontWeight: EdTechFontWeight.medium),
              )),
              _codeCopied
                  ? Icon(Icons.done, color: EdTechColors.greenColor, size: EdTechIconSizes.normal)
                  : Icon(Icons.content_copy,
                      color: EdTechColors.textBlackColor, size: EdTechIconSizes.normal),
            ],
          ),
          decoration: BoxDecoration(
            color: EdTechColors.dividerColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ));
  }
}
