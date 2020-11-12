import 'package:edtechteachersapp/src/global/app_builder.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/resources/main_screen.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';

class EdTech extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        bloc: LoginBloc(),
        child: BlocProvider<TeacherBloc>(
            bloc: TeacherBloc(),
            child: BlocProvider<PostBloc>(
                bloc: PostBloc(),
                child: BlocProvider<NotificationBloc>(
                  bloc: NotificationBloc(),
                  child: BlocProvider<ChatBloc>(
                    bloc: ChatBloc(),
                    child: AppBuilder(builder: (BuildContext context) {
                      return MaterialApp(
                        builder: (context, child) {
                          return ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: child,
                          );
                        },
                        debugShowCheckedModeBanner: false,
                        title: 'EdTech',
                        theme: ThemeData(
                          fontFamily: EdTechFontFamilies.mainFont,
                        ),
                        home: MainScreen(),
                      );
                    }),
                  ),
                ))));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
