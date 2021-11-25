import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_im/constant/constant.dart';

import 'package:flutter_im/utils/widgets/chat_box/image_button.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';

/// 通用的聊天输入框组件 - 仿微信
/// 关键点：聊天输入框高度变化时，输入框获得/失去焦点时，发送事件

typedef void OnSend(String text);

const ChatType _initType = ChatType.text;

class ChatBoxWidget extends StatefulWidget {
  final TextEditingController controller;
  final Widget extraWidget; // 自定义扩展菜单
  final Widget emojiWidget; // 自定义表情
  final Widget voiceWidget; // 自定义语音
  final OnSend onSend; // 发送按钮事件

  const ChatBoxWidget({
    Key key,
    @required this.controller,
    this.extraWidget,
    this.emojiWidget,
    this.voiceWidget,
    this.onSend,
  }) : super(key: key);

  @override
  ChatBoxWidgetState createState() => ChatBoxWidgetState();
}

class ChatBoxWidgetState extends State<ChatBoxWidget> with WidgetsBindingObserver, TickerProviderStateMixin {
  ChatType currentType = _initType;

  FocusNode focusNode = FocusNode(); // 输入框对象节点

  KeyboardUtils _keyboardUtils = KeyboardUtils();
  int _subscribingId;

  AnimationController _bottomHeightController;

  StreamController<String> inputContentStreamController = StreamController.broadcast();

  Stream<String> get inputContentStream => inputContentStreamController.stream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(onFocus);
    widget.controller.addListener(_onInputChange);
    _bottomHeightController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _subscribingId = _keyboardUtils.add(
      listener: KeyboardListener(willShowKeyboard: (height) {
        print(height);
        ChangeChatTypeNotification(height, true).dispatch(context);
      }, willHideKeyboard: () {
        // ChangeChatTypeNotification(0.0, false).dispatch(context);
      }),
    );
  }

  bool checkShowSendButton(String text) {
    if (currentType == ChatType.voice) {
      return false;
    }
    return text.trim().isNotEmpty;
  }

  void _onInputChange() {
    print("这里是输入框相关事件:" + widget.controller.text);
    inputContentStreamController.add(widget.controller.text);
  }

  /// 输入框获得/失去焦点时触发
  void onFocus() {
    print("🌹");
    if (focusNode.hasFocus) {
      setState(() => currentType = ChatType.text);
      _bottomHeightController.animateTo(0);
    }
    // ChangeChatTypeNotification().dispatch(context);
  }

  @override
  void dispose() {
    _bottomHeightController.dispose();
    widget.controller.removeListener(_onInputChange);
    // focusNode.removeListener(onFocus);
    focusNode.dispose();
    inputContentStreamController.close();
    WidgetsBinding.instance.removeObserver(this);
    _keyboardUtils.unsubscribeListener(subscribingId: _subscribingId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              buildLeftButton(), // 左侧语音按钮
              Expanded(child: buildInputButton()), // 中间输入框 / 语音按钮
              buildEmojiButton(), // 右侧 emoji 表情按钮
              buildRightButton(), // 右侧 扩展按钮 / 发送按钮
            ],
          ),
          _buildBottomContainer(child: _buildBottomItems()),
        ],
      ),
    );
  }

  /// 构建语音按钮
  Widget buildLeftButton() {
    return ImageButton(
      image: AssetImage(currentType != ChatType.voice ? Constant.ASSET_VOICE_PNG : Constant.ASSET_KEYBOARD_PNG),
      onPressed: () {},
    );
  }

  /// 构建右侧按钮
  Widget buildRightButton() {
    return StreamBuilder<String>(
      stream: this.inputContentStream,
      builder: (context, snapshot) {
        CrossFadeState crossFadeState = checkShowSendButton(widget.controller.text) ? CrossFadeState.showFirst : CrossFadeState.showSecond;
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: crossFadeState,
          firstChild: buildSendButton(),
          secondChild: buildExtraButton(),
        );
      },
    );
  }

  /// 构建发送按钮
  Widget buildSendButton() {
    return Container(
      height: ScreenUtil().setHeight(100),
      child: ElevatedButton(
        child: buildTextWidget("发送", 14, Colors.white),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          ),
        ),
        onPressed: () => widget.onSend?.call(widget.controller.text.trim()),
      ),
    );
  }

  void changeBottomHeight(final double height) {
    if (height > 0) {
      _bottomHeightController.animateTo(1);
    } else {
      _bottomHeightController.animateBack(0);
    }
  }

  /// 构建扩展菜单按钮
  Widget buildExtraButton() {
    return ImageButton(
      image: AssetImage(Constant.ASSET_ADD_PNG),
      onPressed: () => updateState(ChatType.extra),
    );
  }

  /// 构建表情按钮
  Widget buildEmojiButton() {
    return ImageButton(
      image: AssetImage(currentType != ChatType.emoji ? Constant.ASSET_EMOJI_PNG : Constant.ASSET_KEYBOARD_PNG),
      onPressed: () => updateState(currentType != ChatType.emoji ? ChatType.emoji : ChatType.text),
    );
  }

  Future<void> updateState(ChatType type) async {
    this.currentType = type;
    if (type == ChatType.emoji || type == ChatType.extra) {
      _bottomHeightController.animateTo(1);
      focusNode.unfocus();
    } else {
      _bottomHeightController.animateTo(0);
      FocusScope.of(context).requestFocus(focusNode);
    }
    ChangeChatTypeNotification(0, true).dispatch(context);
    setState(() {});
  }

  /// 构建文字输入框
  Widget buildInputButton() {
    final InputBorder underBorder = UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]));
    final voiceButton = widget.voiceWidget ?? buildVoiceButton(context);
    final inputButton = Container(
      child: TextField(
        focusNode: focusNode,
        controller: widget.controller,
        minLines: 1,
        maxLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
          isCollapsed: true, // 取消奇怪的高度
          contentPadding: const EdgeInsets.all(8),
          border: UnderlineInputBorder(),
          enabledBorder: underBorder,
          focusedBorder: underBorder,
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        Offstage(child: voiceButton, offstage: currentType != ChatType.voice),
        Offstage(child: inputButton, offstage: currentType == ChatType.voice),
      ],
    );
  }

  /// 构建 emjoy 与 扩展菜单 内容区域
  Widget _buildBottomContainer({Widget child}) {
    return SizeTransition(
      sizeFactor: _bottomHeightController,
      child: Container(child: child, height: currentType == ChatType.emoji ? 300 : 240),
    );
  }

  Widget _buildBottomItems() {
    if (this.currentType == ChatType.extra) {
      return widget.extraWidget ?? Center(child: Text("其他item"));
    } else if (this.currentType == ChatType.emoji) {
      return widget.emojiWidget ?? Center(child: Text("表情item"));
    } else {
      return Container();
    }
  }
}

Widget buildVoiceButton(BuildContext context) {
  return Container(
    width: double.infinity,
    height: ScreenUtil().setHeight(120),
    child: ElevatedButton(
      onPressed: () {
        print("连接");
      },
      child: Text("按住发声"),
    ),
  );
}

enum ChatType {
  text,
  voice,
  emoji,
  extra,
}

class ChangeChatTypeNotification extends Notification {
  final double height; // 键盘高度
  final bool keyboard; // 键盘显示状态
  ChangeChatTypeNotification(this.height, this.keyboard);
}
