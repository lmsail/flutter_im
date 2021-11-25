import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/http/model/chat/chat.dart';
import 'package:flutter_im/ui/chat/chat_service.dart';
import 'package:flutter_im/utils/widgets/chat_box/default_extra_item.dart';
import 'package:flutter_im/utils/widgets/chat_box/chat_box_widget.dart';
import 'package:flutter_im/utils/widgets/message/chat_message.dart';

class ChatPage extends StatefulWidget {
  final String title; // 标题
  final String id; // 用户id
  final String type; // user： 好友  group：群
  ChatPage({Key key, this.id, this.title, this.type}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  TextEditingController ctl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatData> chatList = [];

  @override
  void initState() {
    _fetchChatList();
    super.initState();
  }

  /// 加载联系人列表
  void _fetchChatList() {
    List<ChatData> list = ChatService.fetchChatList(widget.title);
    setState(() => chatList = list);
  }

  bool _onChange(ChangeChatTypeNotification notification) {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildContent() {
    return Flexible(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
            reverse: true,
            shrinkWrap: false,
            itemCount: chatList.length,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (context, index) {
              ChatData item = chatList[index];
              if (item.type == MessageType.system) {
                return ChatMessage(message: item.message, type: MessageType.system);
              } else if (item.type == MessageType.image) {
                return ChatMessage(message: item.message, user: item.user, type: MessageType.image, isSelf: item.isSelf);
              } else if (item.type == MessageType.redpacket) {
                return ChatMessage(type: MessageType.redpacket, redInfo: item.redInfo, user: item.user, isSelf: item.isSelf);
              } else {
                return ChatMessage(message: item.message, user: item.user, isSelf: item.isSelf);
              }
            },
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          // 这里维护两个状态参数，控制聊天输入框表情/扩展隐藏
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.title), elevation: 0.5),
      body: NotificationListener<ChangeChatTypeNotification>(
        onNotification: _onChange,
        child: Column(
          children: <Widget>[
            buildContent(),
            Divider(height: 0.5, color: Colors.grey[300]),
            ChatBoxWidget(controller: ctl, extraWidget: DefaultExtraWidget(), onSend: (value) => print("send text $value")),
          ],
        ),
      ),
    );
  }
}

/// 事件传递
class CustomNotification extends Notification {
  CustomNotification();
}
