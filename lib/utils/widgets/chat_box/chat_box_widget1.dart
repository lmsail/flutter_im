import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_im/constant/constant.dart';

import 'package:flutter_im/utils/widgets/chat_box/image_button.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef void OnSend(String text);

ChatType _initType = ChatType.text;

double _softKeyHeight = 200;

class ChatBoxWidget extends StatefulWidget {
  final TextEditingController controller;
  final Widget extraWidget;
  final Widget emojiWidget;
  final Widget voiceWidget;
  final OnSend onSend;

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
  bool isKeyboardActived = false; // 当前键盘激活状态

  ChatType currentType = _initType;

  FocusNode focusNode = FocusNode();

  StreamController<String> inputContentStreamController = StreamController.broadcast();

  Stream<String> get inputContentStream => inputContentStreamController.stream;

  AnimationController _bottomHeightController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(onFocus);
    widget.controller.addListener(_onInputChange);
    _bottomHeightController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
  }

  bool checkShowSendButton(String text) {
    if (currentType == ChatType.voice) {
      return false;
    }
    return text.trim().isNotEmpty;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final mediaQueryData = MediaQueryData.fromWindow(ui.window);
    final keyHeight = mediaQueryData?.viewInsets?.bottom;
    if (keyHeight != 0) {
      _softKeyHeight = keyHeight;
      print("current type = $currentType");
      updateState(ChatType.text);
    } else {
      setState(() {});
    }
  }

  void onFocus() {
    if (focusNode.hasFocus) updateState(ChatType.text);
  }

  void _onInputChange() {
    print("这里是输入框相关事件");
    inputContentStreamController.add(widget.controller.text);
  }

  @override
  void dispose() {
    _bottomHeightController.dispose();
    inputContentStreamController.close();
    widget.controller.removeListener(_onInputChange);
    focusNode.removeListener(onFocus);
    focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
              buildLeftButton(),
              Expanded(child: buildInputButton()),
              buildEmojiButton(),
              buildRightButton(),
            ],
          ),
          _buildBottomContainer(child: _buildBottomItems()),
        ],
      ),
    );
  }

  Widget buildLeftButton() {
    return ImageButton(
      onPressed: () {
        if (currentType == ChatType.voice) {
          updateState(ChatType.text);
        } else {
          updateState(ChatType.voice);
        }
      },
      image: AssetImage(
        currentType != ChatType.voice ? Constant.ASSET_VOICE_PNG : Constant.ASSET_KEYBOARD_PNG,
      ),
    );
  }

  Widget buildRightButton() {
    return StreamBuilder<String>(
      stream: this.inputContentStream,
      builder: (context, snapshot) {
        final sendButton = buildSend();
        final extraButton = ImageButton(
          image: AssetImage(Constant.ASSET_ADD_PNG),
          onPressed: () => updateState(ChatType.extra),
        );

        CrossFadeState crossFadeState = checkShowSendButton(widget.controller.text) ? CrossFadeState.showFirst : CrossFadeState.showSecond;

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: crossFadeState,
          firstChild: sendButton,
          secondChild: extraButton,
        );
      },
    );
  }

  Widget buildSend() {
    return Container(
      height: ScreenUtil().setHeight(120),
      child: ElevatedButton(
        child: buildTextWidget("发送", 14, Colors.white),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        onPressed: () => widget.onSend?.call(widget.controller.text.trim()),
      ),
    );
  }

  Widget buildExtra() {
    return ImageButton(
      image: AssetImage(Constant.ASSET_ADD_PNG),
      onPressed: () => updateState(ChatType.extra),
    );
  }

  Widget buildEmojiButton() {
    return ImageButton(
      image: AssetImage(currentType != ChatType.emoji ? Constant.ASSET_EMOJI_PNG : Constant.ASSET_KEYBOARD_PNG),
      onPressed: () {
        if (currentType != ChatType.emoji) {
          updateState(ChatType.emoji);
        } else {
          updateState(ChatType.text);
        }
      },
    );
  }

  Widget buildInputButton() {
    final voiceButton = widget.voiceWidget ?? buildVoiceButton(context);
    final inputButton = Container(
      // height: ScreenUtil().setHeight(120),
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
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
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

  void changeBottomHeight(final double height) {
    if (height > 0) {
      _bottomHeightController.animateTo(1);
    } else {
      _bottomHeightController.animateBack(0);
    }
  }

  Future<void> updateState(ChatType type) async {
    if (type == ChatType.text || type == ChatType.voice) {
      _initType = type;
    }
    if (type == currentType) {
      return;
    }
    this.currentType = type;
    ChangeChatTypeNotification(type).dispatch(context);

    if (type != ChatType.text) {
      hideSoftKey();
    } else {
      showSoftKey();
    }

    if (type == ChatType.emoji || type == ChatType.extra) {
      // _currentOtherHeight = _softKeyHeight;
      changeBottomHeight(1);
    } else {
      changeBottomHeight(0);
      // _currentOtherHeight = 0;
    }

    setState(() {});
  }

  void showSoftKey() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void hideSoftKey() {
    focusNode.unfocus();
  }

  Widget _buildBottomContainer({Widget child}) {
    return SizeTransition(
      sizeFactor: _bottomHeightController,
      child: Container(
        child: child,
        height: 220,
      ),
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
  final ChatType type;

  ChangeChatTypeNotification(this.type);
}
