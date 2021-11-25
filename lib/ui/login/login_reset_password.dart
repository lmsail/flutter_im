import 'package:flutter/material.dart';
import 'package:flutter_im/ui/login/login_widget.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_im/utils/widgets/text_field/text_field_widget.dart';

class LoginResetPassword extends StatefulWidget {
  @override
  _LoginResetPasswordState createState() => _LoginResetPasswordState();
}

class _LoginResetPasswordState extends State<LoginResetPassword> {
  bool passwordStatus = false;
  bool loginBtnStatus = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    Size winSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildLoginAppBar(() => Navigator.of(context).pop()),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Wrap(children: [
          Container(
            width: winSize.width,
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
        Text("请设置密码", style: TextStyle(fontSize: 25)),
        SizedBox(height: 10.0),
        buildTextWidget("8-20个字符，不可以是纯数字", 14.0, Colors.grey[400]),
        SizedBox(height: 50.0),
        TextFieldWidget(
          hintText: '请输入密码',
          isPwd: true,
          inputCallBack: (value) => setState(() => loginBtnStatus = value.isNotEmpty),
        ),
        _buildBtnByState(),
      ],
    );
  }

  Widget _buildBtnByState() {
    return Container(
      margin: EdgeInsets.only(top: 25.0, bottom: 0),
      height: 45.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: buildTextWidget("完 成", 16, Colors.white),
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
        onPressed: () => print("点击了完成"),
      ),
    );
  }
}
