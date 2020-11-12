import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserAction {
  String icon;
  String name;
  Function onPress;

  UserAction(icon, name, onPress) {
    this.icon = icon;
    this.name = name;
    this.onPress = onPress;
  }
}

class ListUserAction extends StatelessWidget {
  final List<UserAction> actions;
  const ListUserAction({Key key, @required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ((EdTechAppStyles(context).width-20)/3) * ((actions.length-1)~/3+1),
        child: GridView.builder(
          itemCount: actions.length,
          padding: EdgeInsets.only(left: 10, right: 10),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final action = actions[index];
            return InkWell(
              onTap: action.onPress,
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(action.icon, height: 40.0, width: 40.0),
                      SizedBox(height: 10),
                      Text(
                        action.name,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: EdTechFontSizes.normal,
                          fontWeight: EdTechFontWeight.semibold,
                          color: EdTechColors.textBlackColor,
                        ),
                      ),
                    ],
                  )),
            );
          },
        ));
  }
}
