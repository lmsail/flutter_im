part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// 发送验证码
class DoLoginSendSMS extends LoginEvent {
  final String mobile;
  DoLoginSendSMS({this.mobile});
}

// 验证码登录
class DoLoginSms extends LoginEvent {
  final String mobile;
  final String sms_code;
  DoLoginSms({this.mobile, this.sms_code});
}

// 账号密码登录
class DoLoginAccount extends LoginEvent {
  final String account;
  final String password;
  DoLoginAccount({this.account, this.password});
}
