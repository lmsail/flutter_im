import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/constant/style.dart';
import 'package:flutter_im/http/model/message/message.dart';
import 'package:flutter_im/ui/session/search_content.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_im/utils/widgets/message/avatars.dart';
import 'package:flutter_im/utils/widgets/message/mh_list_tile.dart';
import 'package:flutter_im/utils/widgets/search_bar/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SessionWidget {
  /// 构建头部 AppBar
  static Widget buildAppbar(Function onPressed) {
    return AppBar(
      title: Text('微信', style: TextStyle(color: Colors.black)),
      automaticallyImplyLeading: false,
      elevation: 0.5,
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            Constant.assetsImagesMainframe + 'icons_outlined_add2.svg',
            color: Color(0xFF181818),
          ),
          onPressed: onPressed,
        )
      ],
    );
  }

  /// 搜索内容页面
  static Widget buildSearchContent(bool showSearch, {int duration = 300}) {
    return Offstage(
      offstage: !showSearch,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: duration),
        child: SearchContent(),
        curve: Curves.easeInOut,
        opacity: showSearch ? 1.0 : .0,
      ),
    );
  }

  /// 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
  /// 构建列表相关的组件 START

  static Widget buildSessionListWidget(
    ScrollController controller,
    SlidableController slidableController,
    List<Message> dataSource, {
    bool slideIsOpen,
    Function onEdit,
    Function onCancel,
    Function onTapValue,
    Function onSlidableTap,
  }) {
    return Container(
      padding: EdgeInsets.only(top: kToolbarHeight + ScreenUtil.statusBarHeight),
      child: Scrollbar(
        child: CustomScrollView(
          controller: controller,
          // physics: BouncingScrollPhysics(), // 页面弹动
          slivers: <Widget>[
            SliverToBoxAdapter(child: SearchBar(onEdit: onEdit, onCancel: onCancel)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (content, index) => buildListItemWidget(content, dataSource[index], slidableController, slideIsOpen, onTapValue, onSlidableTap),
                childCount: dataSource.length,
              ),
            ),
          ],
        ),
      ),
      height: ScreenUtil.screenHeightDp - 50,
    );
  }

  /// 构建 listview item
  static Widget buildListItemWidget(
    BuildContext cxt,
    Message model,
    SlidableController slidableController,
    bool slideIsOpen,
    Function onTapValue,
    Function onSlidableTap,
  ) {
    // 头像 + 未读消息红点
    final Widget badgeWidget =
        model.badge?.type == 'dot' || model.badge == null ? null : Text(model.badge?.text, style: TextStyle(color: Colors.white));
    final Widget leading = Padding(
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(36.0)),
      child: model.badge != null ? Badge(badgeContent: badgeWidget, child: Avatars(message: model)) : Avatars(message: model),
    );

    /// 文字组件
    Widget expandedText(String text, double size, Color color) {
      return Expanded(
        child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: ScreenUtil().setSp(size))),
      );
    }

    /// 好友昵称，最新消息与消息时间部分
    final Widget middle = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            expandedText(model.screenName, 51.0, Style.pTextColor),
            buildTextWidget('2019/12/01', ScreenUtil().setSp(36.0), Color(0xFFB2B2B2)),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(20.0)),
        Row(
          children: <Widget>[
            expandedText(model.text, 45.0, Color(0xFF9B9B9B)),
            Offstage(
              offstage: !model.messageFree,
              child: Image.asset(
                Constant.assetsImagesMainframe + 'AlbumMessageDisableNotifyIcon_15x15.png',
                width: ScreenUtil().setWidth(45.0),
                height: ScreenUtil().setHeight(45.0),
              ),
            )
          ],
        ),
      ],
    );

    /// 生成联系人区域组件
    final Widget listTile = MHListTile(
      leading: leading,
      middle: middle,
      allowTap: !slideIsOpen,
      contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(48.0), vertical: ScreenUtil().setHeight(36.0)),
      dividerColor: Color(0xFFD8D8D8),
      dividerIndent: ScreenUtil().setWidth(228.0),
      onTapValue: (cxt) => onTapValue(cxt, model),
    );

    // 侧滑按钮
    Widget sliderButton(String text, {Color color, Function onTap}) {
      return GestureDetector(
        child: Container(
          color: color != null ? color : Color(0xFFC7C7CB),
          child: buildTextWidget(text, ScreenUtil().setSp(51.0), Colors.white),
          alignment: Alignment.center,
        ),
        onTap: onTap,
      );
    }

    return Slidable(
      key: Key(model.idstr),
      controller: slidableController,
      dismissal: SlidableDismissal(
        closeOnCanceled: false,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          return false;
        },
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: listTile,
      secondaryActions: [
        sliderButton('设为未读'),
        sliderButton('删除', color: Colors.red, onTap: () => onSlidableTap),
      ],
    );
  }

  /// 构建列表相关的组件 END
  /// 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
}
