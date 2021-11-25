import 'package:fluro/fluro.dart';
import 'package:flutter_im/routes/routers.dart';
import 'package:flutter_im/ui/login/login_account_page.dart';
import 'package:flutter_im/ui/login/login_code_page.dart';
import 'package:flutter_im/ui/login/login_page.dart';
import 'package:flutter_im/ui/login/login_reset_password.dart';

class LoginRouter implements IRouterProvider {
  static const String login = '/login'; // 验证码登录
  static const String loginCode = '/login/code'; // 验证码
  static const String loginAccount = '/login/account'; // 账号登录
  static const String loginResetPassword = '/login_reset_password'; // 充值密码

  @override
  void initRouter(FluroRouter router) {
    router.define(login, handler: Handler(handlerFunc: (_, params) => LoginPage()));
    router.define(loginCode, handler: Handler(handlerFunc: (_, params) => LoginCodePage()));
    router.define(loginAccount, handler: Handler(handlerFunc: (_, params) => LoginAccountPage()));
    router.define(loginResetPassword, handler: Handler(handlerFunc: (_, params) => LoginResetPassword()));
    router.define(loginAccount, handler: Handler(handlerFunc: (_, params) => LoginAccountPage()));
  }
}
