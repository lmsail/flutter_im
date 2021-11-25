part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

// 登录前 Loading 状态
class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

// 登录失败，返回错误信息
class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LoginError{message: $message}';
}

// 登录验证码发送成功
class SendSMSSuccess extends LoginState {
  const SendSMSSuccess();

  @override
  List<Object> get props => [];
}

// 登录成功
class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// 登录状态结束
class LoginNone extends LoginState {
  const LoginNone();

  @override
  List<Object> get props => [];
}
