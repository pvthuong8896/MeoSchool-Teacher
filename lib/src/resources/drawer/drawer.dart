import 'package:edtechteachersapp/src/global/configs/edtech_color.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_fontsize.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/resources/login/index.dart';
import 'package:edtechteachersapp/src/resources/profile/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';

class DrawerView extends StatelessWidget {
  final UserRepository userRepository;
  final LoginBloc loginBloc;

  const DrawerView({
    Key key,
    @required this.userRepository,
    @required this.loginBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        InkWell(
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: EdTechColors.backgroundColor,
            ),
            accountName: Text(
              DataSingleton.instance.edUser.name ?? "",
              style: TextStyle(
                  color: EdTechColors.drawerColor,
                  fontWeight: EdTechFontWeight.semibold),
            ),
            accountEmail: Text(DataSingleton.instance.edUser.email ?? "",
                style: TextStyle(color: EdTechColors.drawerColor)),
            currentAccountPicture:
                // new CircleAvatar(
                //   backgroundColor: Colors.brown,
                //   backgroundImage: ( DataSingleton.instance.edUser.avatar == null || DataSingleton.instance.edUser.avatar.isEmpty)
                //     ? AssetImage("assets/img/avatar_default.png")
                //     : NetworkImage(DataSingleton.instance.edUser.avatar),
                // ),

                ClipOval(
                    child: (DataSingleton.instance.edUser.avatar == null ||
                            DataSingleton.instance.edUser.avatar.isEmpty)
                        ? Image.asset("assets/img/avatar_default.png",
                            fit: BoxFit.cover)
                        : Image.network(
                            DataSingleton.instance.edUser.avatar,
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
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings, color: EdTechColors.drawerIconColor),
          title: Text(
            'Cài đặt tài khoản',
            style: TextStyle(color: EdTechColors.drawerColor),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
            );
          },
        ),
        ListTile(
            leading: Icon(Icons.security, color: EdTechColors.drawerIconColor),
            title: Text(
              'Điều khoản sử dụng',
              style: TextStyle(color: EdTechColors.drawerColor),
            ),
            onTap: _launchInWebViewWithJavaScript),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: EdTechColors.drawerIconColor),
          title: Text(
            'Đăng xuất',
            style: TextStyle(color: EdTechColors.drawerColor),
          ),
          onTap: () {
            userRepository.signOut();
            loginBloc.logout();
            DataSingleton.instance.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
            );
          },
        )
      ],
    );
  }

  Future<void> _launchInWebViewWithJavaScript() async {
    var url = Constants.policy;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
