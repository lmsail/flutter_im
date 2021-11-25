import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_im/blocs/login/login_bloc.dart';
import 'package:flutter_im/routes/router_util.dart';
import 'package:flutter_im/routes/routers.dart';
import 'package:flutter_im/ui/login/login_router.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_im/utils/widgets/common/feedback_widget.dart';
import 'package:flutter_im/utils/widgets/text_field/text_field_widget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size winSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Wrap(children: [
          Container(
            color: Colors.white,
            width: winSize.width,
            height: winSize.height,
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: LoginFrom(),
          )
        ]),
      ),
    );
  }
}

class LoginFrom extends StatefulWidget {
  @override
  _LoginFromState createState() => _LoginFromState();
}

class _LoginFromState extends State<LoginFrom> {
  final _usernameController = TextEditingController();
  bool _btnStatus = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0),
              Text("你好，", style: TextStyle(fontSize: 25)),
              SizedBox(height: 15.0),
              Text("欢迎使用微信！", style: TextStyle(fontSize: 25)),
              SizedBox(height: 50.0),
              TextFieldWidget(
                controller: _usernameController,
                hintText: '请输入手机号',
                isPhone: true,
                labelText: '未注册的手机号验证后自动创建账户',
                keyboardType: TextInputType.phone,
                inputCallBack: (value) => setState(() => _btnStatus = value.isNotEmpty),
              ),
              BlocConsumer<LoginBloc, LoginState>(listener: _listenLoginState, builder: _buildBtnByState),
              SizedBox(height: 20.0),
              FeedbackWidget(
                onEnd: () => RouterUtils.push(context, LoginRouter.loginAccount),
                child: buildTextWidget("密码登录", 14.0, Colors.blue),
              ),
              Spacer(),
            ],
          ),
          _buildAgreementText()
        ],
      ),
    );
  }

  // 获取验证码按钮
  Widget _buildBtnByState(BuildContext context, LoginState state) {
    if (state is LoginLoading) {
      print(state);
      print("登录状态改变咯！！");
    }

    return Container(
      margin: EdgeInsets.only(top: 35.0, bottom: 0),
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: _doLoginSendSMS,
        child: buildTextWidget("获取短信验证码", 16, Colors.white),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(
            _btnStatus ? Colors.blue : Colors.grey[350],
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    );
  }

  // 底部用户协议
  Widget _buildAgreementText() {
    return Positioned(
      bottom: 62.0,
      child: RichText(
        text: TextSpan(
          text: "登录即表明同意",
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: "《微信用户协议》",
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  RouterUtils.push(context, Routers.webView, transition: TransitionType.inFromBottom);
                },
            ),
            TextSpan(text: "和", style: TextStyle(color: Colors.grey[600])),
            TextSpan(text: "《隐私政策》", style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  // 登录
  void _doLoginSendSMS() {
    print('🎈 -- 用户名:${_usernameController.text} -- 🎈');
    String mobile = _usernameController.text;
    if (mobile.isEmpty) return;
    BlocProvider.of<LoginBloc>(context).add(DoLoginSendSMS(mobile: mobile));
  }

  // 监听登录状态
  void _listenLoginState(BuildContext context, LoginState state) {
    print(state);
    print('🎈 -- [_listenLoginState] 监听到登录返回值! -- 🎈');
    if (state is SendSMSSuccess) {
      Navigator.of(context).pushNamed(LoginRouter.loginCode);
    }
  }
}
