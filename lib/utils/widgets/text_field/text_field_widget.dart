import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';

/// 输入框回调函数
typedef _InputCallBack = void Function(String value);

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType; // 输入框类型，默认文本
  final String defaultText; // 输入框默认值
  final String hintText; // 输入框提示文字
  final bool isPwd; // 是否是密码，默认不是
  final bool isPhone; // 是否是手机号，默认不是
  final Widget leftWidget; // 左侧widget ，默认隐藏
  final int maxLength; // 最大长度，默认20
  final String labelText; // 底部提示文字
  final _InputCallBack inputCallBack;

  const TextFieldWidget({
    Key key,
    this.controller,
    this.focusNode,
    this.keyboardType: TextInputType.text,
    this.defaultText: '',
    this.hintText,
    this.isPwd = false,
    this.isPhone = false,
    this.leftWidget,
    this.maxLength: 20,
    this.labelText: '',
    this.inputCallBack,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool _pwdShow; // 控制密码 明文切换
  bool _isShowDelete; // 控制清除按钮是否显示
  bool _isShowPhone;

  @override
  void initState() {
    super.initState();

    /// 属性初始化
    _controller = widget.controller != null ? widget.controller : TextEditingController();
    _controller.text = widget.defaultText; // 添加默认值
    _pwdShow = widget.isPwd;
    _isShowPhone = widget.isPhone;
    _focusNode = widget.focusNode != null ? widget.focusNode : FocusNode();

    /// 输入框事件监听
    _controller.addListener(
      () => setState(() {
        _isShowDelete = _controller.text.isNotEmpty && _focusNode.hasFocus;
      }),
    );

    _focusNode.addListener(
      () => setState(() {
        _isShowDelete = _controller.text.isNotEmpty && _focusNode.hasFocus;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[100],
          margin: const EdgeInsets.only(bottom: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              /// 显示86
              _isShowPhone ? Text('+86', style: TextStyle(fontSize: 16)) : Text(''),

              // 增加下拉图标与间距
              _isShowPhone ? Padding(padding: EdgeInsets.only(left: 5.0, right: 10.0), child: Icon(Icons.arrow_drop_down)) : Text(''),

              // 添加分隔符
              _isShowPhone ? buildVerticalLine() : Text(''),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: _pwdShow ? TextInputType.visiblePassword : widget.keyboardType,
                  obscureText: _pwdShow,
                  autofocus: false,
                  // maxLength: widget.maxLength,
                  inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: _isShowDelete != null && _isShowDelete ? _buildClearButton() : null,
                  ),
                  onChanged: (text) {
                    if (widget.inputCallBack != null) {
                      widget.inputCallBack(_controller.text);
                    }
                  },
                ),
              )
            ],
          ),
        ),

        /// 底部说明问题 / 提示文字
        widget.labelText.length > 0 ? buildTextWidget(widget.labelText, 13.0, Colors.grey[400]) : Text(''),
      ],
    );
  }

  // 竖线
  Widget buildVerticalLine() {
    return Container(
      height: 20.0,
      width: 1.0,
      color: Colors.grey.withOpacity(0.5),
      margin: EdgeInsets.only(right: 15.0),
    );
  }

  // 清除按钮
  Widget _buildClearButton() {
    return IconButton(
      onPressed: () {
        _controller.clear();
        if (widget.inputCallBack != null) {
          widget.inputCallBack(_controller.text);
        }
      },
      icon: Icon(Icons.cancel),
      color: Colors.grey[400],
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
