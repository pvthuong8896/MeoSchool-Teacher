import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_color.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:edtechteachersapp/src/resources/conversation/index.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/resources/home/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabbarScreen extends StatefulWidget {
  TabbarScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabbarState();
  }
}

class _TabbarState extends State<TabbarScreen> {
  TeacherBloc teacherBloc;
  int _currentIndex = 0;
  List<Widget> _children = [];

  final List unfocusedIconPath = [
    'assets/img/icons/home-outline.svg',
    '',
    'assets/img/icons/chat-outline.svg',
  ];
  final List focusedIconPath = [
    'assets/img/icons/home.svg',
    '',
    'assets/img/icons/chat.svg',
  ];
  final List<String> listTitle = [
    "Trang chủ",
    '',
    "Tin nhắn",
  ];
  List<bool> isFocus = [true, false, false];

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    _children = [
      DetailClassRoomScreen(),
      CreatePostScreen(createForAStudent: false,),
      ListConversation()
    ];
    isFocus = [true, false, false];
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        // pass the student object to new screen
        return CreatePostScreen(createForAStudent: false,);
      }));
    } else {
      if (index != _currentIndex) {
        setState(() {
          isFocus[_currentIndex] = false;
          isFocus[index] = true;
          _currentIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Offstage(
        offstage: _currentIndex == 3,
        child: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex,
          selectedItemColor: EdTechColors.mainColor,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: EdTechFontSizes.small * 1.1,
          selectedFontSize: EdTechFontSizes.small * 1.1,
          items: [
            new BottomNavigationBarItem(
              icon: isFocus[0]
                  ? SvgPicture.asset(
                focusedIconPath[0],
                height: 20.0,
                width: 20.0,
                color: EdTechColors.mainColor,
              )
                  : SvgPicture.asset(unfocusedIconPath[0],
                  height: 20.0,
                  width: 20.0,
                  color: EdTechColors.textColor.withOpacity(0.7)),
              title: Text(listTitle[0],
                  style: TextStyle(fontWeight: EdTechFontWeight.normal)),
            ),
            new BottomNavigationBarItem(
                icon: Container(
                  child: isFocus[1]
                      ? Icon(
                    Icons.radio_button_unchecked,
                    size: 39,
                    color: EdTechColors.mainColor,
                  )
                      : Icon(
                    Icons.radio_button_unchecked,
                    size: 39,
                    color: EdTechColors.textColor.withOpacity(0.7),
                  ),
                ),
                title: Container()),
            new BottomNavigationBarItem(
              icon: isFocus[2]
                  ? SvgPicture.asset(
                focusedIconPath[2],
                height: 20.0,
                width: 20.0,
                color: EdTechColors.mainColor,
              )
                  : SvgPicture.asset(unfocusedIconPath[2],
                  height: 20.0,
                  width: 20.0,
                  color: EdTechColors.textColor.withOpacity(0.7)),
              title: Text(listTitle[2],
                  style: TextStyle(fontWeight: EdTechFontWeight.normal)),
            ),
          ],
        ),
      ),
    );
  }
}
