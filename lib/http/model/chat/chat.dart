import 'package:flutter_im/http/model/chat/redpacket.dart';
import 'package:flutter_im/http/model/user/user.dart';
import 'package:flutter_im/utils/widgets/message/chat_message.dart';

/// 聊天列表

class ChatData {
  final String id; // 消息编号
  final bool isSelf; // 是否是自己的消息
  final String message; // 消息内容 文字 ｜ 图片地址
  final MessageType type; // 消息类型
  final User user; // 发送消息的用户信息
  final RedPacket redInfo; // 红包信息

  ChatData({
    this.id,
    this.message,
    this.user,
    this.redInfo,
    this.isSelf: true,
    this.type: MessageType.text,
  });
}
