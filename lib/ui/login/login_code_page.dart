import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_im/ui/login/login_router.dart';
import 'package:flutter_im/ui/login/login_widget.dart';
import 'package:flutter_verification_box/verification_box.dart';

class LoginCodePage extends StatefulWidget {
  @override
  _LoginCodePageState createState() => _LoginCodePageState();
}

class _LoginCodePageState extends State<LoginCodePage> {
  String _prevMobile = "188 9988 6699";
  int _countTime = 60;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    Size winSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildLoginAppBar(() => Navigator.of(context).pop()),
      body: SingleChildScrollView(
        child: Wrap(children: [
          Container(
            width: winSize.width,
            color: Colors.white,
            padding: EdgeInsets.only(left: 35.0, right: 35.0),
            child: _buildAppBody(),
          )
        ]),
      ),
    );
  }

  Widget _buildAppBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30.0),
        Text("请输入验证码", style: TextStyle(fontSize: 25)),
        SizedBox(height: 10.0),
        _buildCodeNoticeWidget(),
        SizedBox(height: 30.0),
        VerificationBox(
          type: VerificationBoxItemType.underline,
          textStyle: TextStyle(fontSize: 25.0),
          focusBorderColor: Colors.black,
          borderWidth: 1.0,
          onSubmitted: (value) {
            EasyLoading.show();
            Timer(Duration(seconds: 3), () {
              EasyLoading.dismiss();
              Navigator.of(context).pushReplacementNamed(LoginRouter.loginResetPassword);
            });
          },
        ),
        SizedBox(height: 20.0),
        _buildCodeDownWidget(),
      ],
    );
  }

  Widget _buildCodeNoticeWidget() {
    return Container(
      child: RichText(
        text: TextSpan(
          text: "验证码已发送至 ",
          style: TextStyle(color: Colors.grey[500], fontSize: 14.0),
          children: [
            TextSpan(text: _prevMobile, style: TextStyle(color: Colors.blue, fontSize: 14.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeDownWidget() {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: RichText(
        text: TextSpan(
          text: "$_countTime",
          style: TextStyle(color: Colors.blue, fontSize: 14.0),
          children: [
            TextSpan(text: " 秒后重新发送验证码", style: TextStyle(color: Colors.grey[500], fontSize: 14.0)),
          ],
        ),
      ),
    );
  }
}
