import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/http/model/chat/redpacket.dart';
import 'package:flutter_im/http/model/user/user.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final double avatarSize = ScreenUtil().setWidth(110);

final Color selfBgColor = Color(0xffa5ed7e); // Color(0xffa5ed7e) : Colors.grey[200]
final Color friendBgColor = Colors.grey[200];
final Color redBgColor = Color.fromRGBO(251, 156, 62, 1);

class ChatMessage extends StatelessWidget {
  final String message; // 消息内容
  final MessageType type; // 消息类型
  final User user; // 用户信息 昵称，头像，id
  final RedPacket redInfo; // 红包信息
  final bool isSelf; // 是否是自己发的消息
  final bool showName; // 是否显示好友昵称, 默认不显示

  const ChatMessage({
    Key key,
    this.type: MessageType.text,
    this.message,
    this.user,
    this.redInfo,
    this.isSelf: false,
    this.showName: true,
  }) : super(key: key);

  /// 构建头像组件
  Widget _buildUserAvatar(EdgeInsetsGeometry margin) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
        child: CachedNetworkImage(
          imageUrl: user.avatar,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Image.asset(Constant.assetsImagesDefault + 'DefaultHead_48x48.png', width: avatarSize, height: avatarSize);
          },
          errorWidget: (context, url, error) {
            return Image.asset(Constant.assetsImagesDefault + 'DefaultHead_48x48.png', width: avatarSize, height: avatarSize);
          },
        ),
      ),
    );
  }

  /// 构建系统消息 / 时间组件
  Widget _buildSystemMessage() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 15.0, top: 10.0),
      child: buildTextWidget(message, 14.0, Colors.grey[500]),
    );
  }

  /// 构建文字消息组件
  Widget _buildTextMessage() {
    Alignment alignPosition = isSelf ? Alignment.topRight : Alignment.topLeft;
    final Color bgColor = isSelf ? selfBgColor : friendBgColor; // 聊天文字背景色 区分自己和好友
    return Align(
      alignment: alignPosition,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        margin: EdgeInsets.only(bottom: 15.0),
        width: message.length >= 15 ? 260 : null,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.all(Radius.circular(3.0))),
        child: Text(message, style: TextStyle(fontSize: ScreenUtil().setSp(51))),
      ),
    );
  }

  /// 构建图片消息
  Widget _buildImageMessage() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
        child: CachedNetworkImage(
          imageUrl: message,
          fit: BoxFit.cover,
          height: ScreenUtil().setWidth(500),
          placeholder: (context, url) {
            return Image.asset(Constant.assetsImagesDefault + 'DefaultImage_200x200.png', width: avatarSize, height: avatarSize);
          },
          errorWidget: (context, url, error) {
            return Image.asset(Constant.assetsImagesDefault + 'DefaultImage_200x200.png', width: avatarSize, height: avatarSize);
          },
        ),
      ),
    );
  }

  /// 构建红包消息
  Widget _buildRedPacketMessage() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: ScreenUtil().setWidth(660),
            height: ScreenUtil().setHeight(190),
            decoration: BoxDecoration(
              color: redBgColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(3.0), topRight: Radius.circular(3.0)),
            ),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Image.asset(Constant.assetsImagesArrow + 'red-packet-icon.png', width: ScreenUtil().setWidth(100)),
                Container(
                  margin: EdgeInsets.only(top: 8, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextWidget(redInfo.wishing, ScreenUtil().setSp(51), Colors.white),
                      buildTextWidget('领取红包', ScreenUtil().setSp(30), Colors.white70)
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(660),
            height: ScreenUtil().setHeight(60),
            padding: EdgeInsets.only(left: 10.0, top: 1.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3.0), bottomRight: Radius.circular(3.0)),
            ),
            child: buildTextWidget('微信红包', ScreenUtil().setSp(30), Colors.black45),
          )
        ],
      ),
    );
  }

  /// 构建聊天气泡箭头
  Widget _buildBubbleArrow() {
    double left, right;
    isSelf ? right = -10.0 + 2 : left = 0.0 + 2;
    return type == MessageType.image
        ? Container()
        : Positioned(
            right: right,
            left: left,
            top: 10,
            child: Container(
              transform: Matrix4.identity()..rotateZ(pi / 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5),
                color: type == MessageType.redpacket ? redBgColor : (isSelf ? selfBgColor : friendBgColor),
              ),
            ),
          );
  }

  /// 构建自己的消息组件
  /// messageWidget 消息组件
  Widget _buildSelfMessage(Widget messageWidget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(clipBehavior: Clip.none, children: <Widget>[_buildBubbleArrow(), messageWidget]),
            ],
          ),
        ),
        _buildUserAvatar(EdgeInsets.only(left: 10)),
      ],
    );
  }

  /// 构建朋友的消息组件
  /// messageWidget 消息组件
  Widget _buildFriendMessage(Widget messageWidget) {
    List<Widget> children = <Widget>[];
    messageWidget = Stack(clipBehavior: Clip.none, children: <Widget>[_buildBubbleArrow(), messageWidget]);
    if (showName) {
      children.addAll([buildTextWidget(user.name, 13.0, Colors.black54), SizedBox(height: 3), messageWidget]);
    } else {
      children.add(messageWidget);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserAvatar(EdgeInsets.only(right: 10.0, top: showName ? 5.0 : 0.0)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget messageWidget;
    if (type == MessageType.text) {
      messageWidget = _buildTextMessage();
    } else if (type == MessageType.image) {
      messageWidget = _buildImageMessage();
    } else if (type == MessageType.redpacket) {
      messageWidget = _buildRedPacketMessage();
    }
    return type == MessageType.system ? _buildSystemMessage() : (isSelf ? _buildSelfMessage(messageWidget) : _buildFriendMessage(messageWidget));
  }
}

enum MessageType {
  system, // 系统消息
  text, // 文字消息
  voice, // 语音消息
  image, // 图片消息
  redpacket, // 红包消息
}
