import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/resources/home/index.dart';
import 'package:edtechteachersapp/src/resources/login/index.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    await loginBloc.checkLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: loginBloc.checkLoggedInStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data) {
            case DONE:
              return HomeScreen();
            case EMPTY:
              return LoginScreen();
            default:
              return Scaffold(
                body: Center(
                    child: Image(
                  image: AssetImage('assets/img/logoblameo.png'),
                  height: MediaQuery.of(context).size.width * 0.4,
                )),
              );
          }
        }
        return Scaffold(
          body: Center(
              child: Image(
            image: AssetImage('assets/img/logoblameo.png'),
            height: MediaQuery.of(context).size.width * 0.4,
          )),
        );
      },
    );
  }
}
