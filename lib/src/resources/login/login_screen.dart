import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/repository/user_repository.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/resources/home/index.dart';
import 'components/login_form_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _schoolCodeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode _schoolCodeFocusNode = new FocusNode();
  FocusNode _usernameFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();

  LoginBloc loginBloc;
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    _schoolCodeFocusNode.addListener(focusSchoolCodeTextField);
    _usernameFocusNode.addListener(focusUsernameTextField);
    _passwordFocusNode.addListener(focusPasswordTextField);
  }

  void focusSchoolCodeTextField() {
    loginBloc.isValidSchoolCode(_schoolCodeController.text);
  }

  void focusUsernameTextField() {
    loginBloc.isValidUsername(_usernameController.text);
  }

  void focusPasswordTextField() {
    loginBloc.isValidPassword(_passwordController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _schoolCodeFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 0,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: EdTechColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Image(
                    image: AssetImage('assets/img/logoblameo.png'),
                    height: EdTechAppStyles(context).width * 0.4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("MeoSchool",
                      style: TextStyle(
                          color: EdTechColors.mainColor,
                          fontWeight: EdTechFontWeight.semibold,
                          fontSize: EdTechFontSizes.big))
                ],
              ),
              SizedBox(height: 20),
              LoginFormInput(
                  title: "Mã trường",
                  textEditingController: _schoolCodeController,
                  isObSecureText: false,
                  stream: loginBloc.schoolCodeStream,
                  focusNode: _schoolCodeFocusNode,
                  validator: loginBloc.isValidSchoolCode),
              SizedBox(height: 5),
              LoginFormInput(
                  title: "Tên người dùng",
                  textEditingController: _usernameController,
                  isObSecureText: false,
                  stream: loginBloc.usernameStream,
                  focusNode: _usernameFocusNode,
                  validator: loginBloc.isValidUsername),
              SizedBox(height: 5),
              LoginFormInput(
                  title: "Mật khẩu",
                  textEditingController: _passwordController,
                  isObSecureText: true,
                  stream: loginBloc.passwordStream,
                  focusNode: _passwordFocusNode,
                  validator: loginBloc.isValidPassword),
              SizedBox(height: 28),
              buttonSubmit(),
            ],
          ),
        ),
      ),
    );
  } // State<LoginScreen> End BuildContext

  Widget buttonSubmit() {
    return SizedBox(
        width: double.infinity,
        height: 44,
        child: RaisedButton(
          onPressed: _onLoginClick,
          child: Text(
            'Đăng nhập',
            style: TextStyle(
                color: Colors.white,
                fontWeight: EdTechFontWeight.bold,
                fontSize: EdTechFontSizes.simple),
          ),
          color: EdTechColors.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ));
  }

  void _onLoginClick() async {
    String schoolCode = _schoolCodeController.text.trim().toUpperCase();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    var isValid = loginBloc.isValidInfo(schoolCode, username, password);
    if (isValid) {
      try {
        LoadingDialog.showLoadingDialog(context, "Đăng nhập...");
        final user = await loginBloc.login(schoolCode, username, password);
        userRepository.saveDataUser(user);
        DataSingleton.instance.edUser = user;
        loginBloc.getChatToken((chat_token, chat_id) {
          DataSingleton.instance.edUser.chatToken = chat_token;
          DataSingleton.instance.edUser.chatId = chat_id;
          userRepository.saveChatDataUser(chat_token, chat_id);
          loginChat(chat_id, chat_token);
        }, (message) {
          LoadingDialog.hideLoadingDialog(context);
          ToastMessage.showToastMessage(context, message);
        });
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false,
        );
      } catch (error) {
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMessageDialog(context, "Thông báo", error.toString(), "OK");
      }
    }
  }

  void loginChat(String userId, String token) async {
    print("chat id $userId - $token");
    await BlaChatSdk.instance.initBlaChatSDK(userId, token);
  }
}

