import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/ui/login/login_widget.dart';
import 'package:flutter_im/routes/router_util.dart';
import 'package:flutter_im/routes/routers.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_im/utils/widgets/common/feedback_widget.dart';
import 'package:flutter_im/utils/widgets/text_field/text_field_widget.dart';

class LoginAccountPage extends StatefulWidget {
  @override
  _LoginAccountPageState createState() => _LoginAccountPageState();
}

class _LoginAccountPageState extends State<LoginAccountPage> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool mobileStatus = false;
  bool passwordStatus = false;
  bool loginBtnStatus = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    Size winSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildLoginAppBar(() => Navigator.of(context).pop()),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: winSize.width,
          height: winSize.height - statusBarHeight - Constant.appBarHeight,
          color: Colors.white,
          padding: EdgeInsets.only(left: 35.0, right: 35.0),
          child: _buildAppBody(),
        ),
      ),
    );
  }

  Widget _buildAppBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30.0),
        Text("账号密码登录", style: TextStyle(fontSize: 25)),
        SizedBox(height: 50.0),
        _buildInputWidget(_mobileController, "请输入手机号码", "mobile"),
        _buildInputWidget(_passwordController, "请输入密码", "password"),
        _buildBtnByState(),
        SizedBox(height: 15.0),
        _buildOtherLoginWay()
      ],
    );
  }

  Widget _buildInputWidget(TextEditingController _controller, String hintText, String type) {
    return TextFieldWidget(
      controller: _controller,
      hintText: hintText,
      isPwd: type == 'password',
      keyboardType: TextInputType.phone,
      inputCallBack: (text) => setState(
        () {
          if (type == "mobile") {
            setState(() => mobileStatus = text.isNotEmpty);
          } else {
            setState(() => passwordStatus = text.isNotEmpty);
          }
          setState(() => loginBtnStatus = mobileStatus && passwordStatus);
        },
      ),
    );
  }

  Widget _buildBtnByState() {
    return Container(
      margin: EdgeInsets.only(top: 25.0, bottom: 0),
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: buildTextWidget("登 录", 16, Colors.white),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(
            loginBtnStatus ? Colors.blue : Colors.grey[350],
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        onPressed: () {
          EasyLoading.show();
          Timer(Duration(seconds: 1), () {
            EasyLoading.dismiss();
            RouterUtils.pushReplace(context, Routers.mainFrame, transition: TransitionType.material);
          });
        },
      ),
    );
  }

  Widget _buildOtherLoginWay() {
    return Row(
      children: <Widget>[
        FeedbackWidget(child: buildTextWidget("验证码登录", 14, Colors.blue), onEnd: () => RouterUtils.back(context)),
        Spacer(),
        FeedbackWidget(child: buildTextWidget("忘记密码？", 14, Colors.grey), onEnd: () => print("点击了忘记密码==")),
      ],
    );
  }
}
