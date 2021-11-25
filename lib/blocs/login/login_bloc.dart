import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_im/http/model/user/user.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginNone());

  /// 这里会收到传来的状态信息，统一处理
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield LoginLoading();

    if (event is DoLoginSendSMS) {
      print('🎈 -- [LoginBloc] 发送验证码事件！参数：mobile:' + event.mobile + ' -- 🎈');
      // yield LoginError('验证码发送失败了！'); // 这里将会触发 login_page 页 (BlocConsumer)listener 包裹的组件监听器
      yield SendSMSSuccess(); // 验证码发送成功
    } else if (event is DoLoginSms) {
      print('🎈 -- [LoginBloc] 发送验证码事件！参数：mobile:' + event.mobile + '; sms_code: ' + event.sms_code + ' -- 🎈');
    } else if (event is DoLoginAccount) {
      print('🎈 -- [LoginBloc] 账号登录！参数：account:' + event.account + '; password: ' + event.password + ' -- 🎈');
    } else {
      print("🎈 -- [LoginBloc] 未知事件 -- 🎈");
    }
  }
}
