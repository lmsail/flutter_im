import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/http/model/message/message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Avatars extends StatelessWidget {
  const Avatars({Key key, this.message}) : super(key: key);

  final Message message; // 列表消息

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final length = message.users.length;
    for (var i = 0; i < length; i++) {
      final user = message.users[i];
      final icon = user.avatar;
      final isNetwork = icon.startsWith(RegExp(r'^http'));
      Widget child;
      double iconWH = 0;
      if (length == 1) {
        iconWH = ScreenUtil().setWidth(48 * 3); // 一张图，占全屏
      } else if (length < 5) {
        iconWH = ScreenUtil().setWidth(63); // 3/4
      } else {
        iconWH = ScreenUtil().setWidth(36); // 5/6/7/8/9
      }

      if (isNetwork) {
        child = CachedNetworkImage(
          imageUrl: icon,
          width: iconWH,
          height: iconWH,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Image.asset(Constant.assetsImagesDefault + 'DefaultHead_48x48.png', width: iconWH, height: iconWH);
          },
          errorWidget: (context, url, error) {
            return Image.asset(Constant.assetsImagesDefault + 'DefaultHead_48x48.png', width: iconWH, height: iconWH);
          },
        );
      } else {
        child = Image.asset(icon, width: iconWH, height: iconWH);
      }
      children.add(child);
    }

    final borderRadius = BorderRadius.circular(ScreenUtil().setWidth(18));

    return Container(
      width: ScreenUtil().setWidth(48 * 3),
      height: ScreenUtil().setWidth(48 * 3),
      decoration: BoxDecoration(color: Color(0xFFDDDEE0), borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Wrap(
          alignment: WrapAlignment.center, // 沿主轴方向居中
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: ScreenUtil().setWidth(6),
          runSpacing: ScreenUtil().setHeight(6),
          children: children,
          verticalDirection: VerticalDirection.up,
        ),
      ),
    );
  }
}
