import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';

class DetailTeacher extends StatelessWidget {
  final Teacher teacher;
  
  DetailTeacher({Key key, @required this.teacher}) : super(key: key);

  Widget build(BuildContext context) {
    globalSize = new EdTechAppStyles(context);
    return Scaffold(
      backgroundColor: EdTechColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: EdTechColors.textColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Thông tin giáo viên",
          style: TextStyle(
              fontWeight: EdTechFontWeight.semibold,
              color: EdTechColors.textBlackColor,
              fontSize: 18.0),
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                height: scaleWidth(114.0),
                width: scaleWidth(114.0),
                child: ClipOval(
                    child: (teacher.avatar == null || teacher.avatar.isEmpty)
                        ? Image.asset("assets/img/avatar_default.png",
                            fit: BoxFit.cover)
                        : Image.network(
                            teacher.avatar,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child: SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      EdTechColors.mainColor),
                                ),
                                height: 20.0,
                                width: 20.0,
                              ));
                            },
                          )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(scaleWidth(130.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          offset: Offset(0, scaleWidth(15.0)),
                          blurRadius: scaleWidth(40.0),
                          color: Colors.grey[200].withOpacity(0.8))
                    ]),
              ),
              SizedBox(height: 20.0),
              updateProfileField("Họ tên", teacher.name),
              SizedBox(height: 20.0),
              updateProfileField("Ngày sinh", EdTechConvertData.convertTimeString(teacher.dob)),
              SizedBox(height: 20.0),
              updateProfileField("Số điện thoại", teacher.phone_number),
              SizedBox(height: 20.0),
              updateProfileField("Email", teacher.email),


            ],
          )),
    );
  }

    Widget updateProfileField(String title, content) {
    return Container(
      width: double.infinity,
      height: 50.0,

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: EdTechColors.dividerColor, width: 0.6)
        )
      ),

      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: EdTechColors.mainColor,
              fontSize: EdTechFontSizes.small,
              fontWeight: EdTechFontWeight.semibold
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: EdTechColors.textBlackColor,
              fontSize: EdTechFontSizes.normal,
              fontWeight: EdTechFontWeight.medium
            ),
          ),
        ],
      )
    );
  }
}
