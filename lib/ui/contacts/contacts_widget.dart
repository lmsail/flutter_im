import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/constant/style.dart';
import 'package:flutter_im/http/model/contact/contact.dart';
import 'package:flutter_im/ui/contacts/contacts_service.dart';
import 'package:flutter_im/ui/session/search_content.dart';
import 'package:flutter_im/utils/widgets/app_bar/mh_app_bar.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';
import 'package:flutter_im/utils/widgets/message/mh_list_tile.dart';
import 'package:flutter_im/utils/widgets/search_bar/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
/// 存放一些本某块抽离的组件
/// 一般放的都是无状态的组件
///
class ContactsWidget {
  /// 构建动画定位组件
  static Widget buildAnimatedPositioned({
    String key,
    Widget child,
    double top = 0.0,
    double left = 0.0,
    double right = 0.0,
    int duration = 300,
    bool hasBox = false,
  }) {
    return AnimatedPositioned(
      key: Key(key),
      top: top,
      left: left,
      right: right,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: duration),
      child: hasBox
          ? Container(
              padding: EdgeInsets.only(top: kToolbarHeight + ScreenUtil.statusBarHeight),
              child: child,
              height: ScreenUtil.screenHeightDp - Constant.appBarHeight,
            )
          : child,
    );
  }

  /// 构建搜索内容页面
  static Widget buildSearchContent(bool showSearch) {
    return Positioned(
      top: ScreenUtil.statusBarHeight + 56,
      left: 0,
      right: 0,
      height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - 56,
      child: Offstage(
        offstage: !showSearch,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          child: SearchContent(),
          curve: Curves.easeInOut,
          opacity: showSearch ? 1.0 : .0,
        ),
      ),
    );
  }
}

///
/// 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 ///
///

/// 索引列表相关的无状态UI组件
class IndexBarWidget {
  /// 构建导航懒
  static Widget buildAppBarWidget(bool showSearch) {
    final String icon = Constant.assetsImagesContacts + 'icons_outlined_add-friends.svg';
    return ContactsWidget.buildAnimatedPositioned(
      key: 'bar',
      top: showSearch ? (-kToolbarHeight - ScreenUtil.statusBarHeight) : 0,
      child: MHAppBar(
        title: Text('通讯录'),
        actions: <Widget>[IconButton(icon: SvgPicture.asset(icon, color: Color(0xFF181818)), onPressed: () {})],
      ),
    );
  }

  /// 构建带下划线的列表
  static Widget buildListTitle(BuildContext context, ContactInfo model, Color defHeaderBgColor, {Function onTapValue, bool slideIsOpen = true}) {
    DecorationImage image;

    return MHListTile(
      tapedColor: Colors.transparent,
      leading: Container(
        width: ScreenUtil().setSp(120),
        height: ScreenUtil().setSp(120),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4.0),
          color: model.bgColor ?? defHeaderBgColor,
          image: image,
        ),
        child: handleAvatar(model),
      ),
      middle: Padding(
        padding: EdgeInsets.only(left: 20),
        child: buildTextWidget(model.name, ScreenUtil().setSp(51), Style.pTextColor),
      ),
      allowTap: !slideIsOpen,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(48.0),
        vertical: ScreenUtil().setHeight(36.0),
      ),
      dividerColor: Color(0xFFD8D8D8),
      dividerIndent: ScreenUtil().setWidth(228.0),
      onTapValue: (cxt) => onTapValue(cxt),
    );
  }

  /// 处理好友头像
  static Widget handleAvatar(ContactInfo model) {
    double iconWH = ScreenUtil().setWidth(48 * 3);
    final String avatar = model.avatar;
    return avatar == null
        ? Icon(model.iconData, color: Colors.white, size: 20)
        : ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(18)),
            child: CachedNetworkImage(
              imageUrl: model.avatar,
              width: iconWH,
              height: iconWH,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Image.asset(Constant.assetsImagesDefault + 'DefaultHead_48x48.png', width: iconWH, height: iconWH);
              },
              errorWidget: (context, url, error) {
                return Image.asset(Constant.assetsImagesDefault + 'DefaultHead_48x48.png', width: iconWH, height: iconWH);
              },
            ),
          );
  }

  // 索引列表配置信息
  static IndexBarOptions indexBarOptions() {
    return IndexBarOptions(
      needRebuild: true,
      ignoreDragCancel: true,
      downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
      downItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      indexHintWidth: 120 / 2,
      indexHintHeight: 100 / 2,
      indexHintDecoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(ContactsService.getImgPath('ic_index_bar_bubble_gray')), fit: BoxFit.contain),
      ),
      indexHintAlignment: Alignment.centerRight,
      indexHintChildAlignment: Alignment(-0.25, 0.0),
      indexHintOffset: Offset(-20, 0),
    );
  }

  /// 构建 AzListView 中 顶部 搜索 + 新的朋友固定按钮部分内容
  static Widget buildListViewHeader(context, defHeaderBgColor, {Function onEdit, Function onCancel}) {
    List<ContactInfo> topList = [
      ContactInfo(name: '新的朋友', tagIndex: '🔍', bgColor: Colors.orange, iconData: Icons.person_add),
      ContactInfo(name: '群聊', tagIndex: '🔍', bgColor: Colors.green, iconData: Icons.people),
      ContactInfo(name: '标签', tagIndex: '🔍', bgColor: Colors.blue, iconData: Icons.local_offer),
      ContactInfo(name: '公众号', tagIndex: '🔍', bgColor: Colors.blueAccent, iconData: Icons.person),
    ];
    return Column(children: <Widget>[
      SearchBar(onEdit: onEdit, onCancel: onCancel),
      Container(
        color: Colors.white,
        child: Column(children: topList.map((item) => buildListTitle(context, item, defHeaderBgColor)).toList()),
      )
    ]);
  }

  /// 构建 AzListView 中吸顶的索引标签
  static Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    if (tag == '★') tag = '★ 热门城市';
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(tag, softWrap: false, style: TextStyle(fontSize: 14.0, color: Color(0xFF666666))),
    );
  }

  /// 构建用户列表 Item
  static Widget buildUserListItem(
    BuildContext context,
    ContactInfo model,
    bool slideIsOpen, // 侧滑按钮是否开启
    SlidableController slidableController, {
    Color defHeaderBgColor,
    Function onTapValue, // 好友栏目点击事件
    Function slidableTap, // 侧滑按钮点击事件
  }) {
    return Slidable(
      key: Key(model.name),
      child: buildListTitle(context, model, defHeaderBgColor, slideIsOpen: slideIsOpen, onTapValue: onTapValue),
      controller: slidableController, // 这一步重要
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      dismissal: SlidableDismissal(
        closeOnCanceled: false,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          return false;
        },
      ),
      secondaryActions: <Widget>[
        GestureDetector(
          child: Container(
            color: Color(0xFFC7C7CB),
            alignment: Alignment.center,
            child: buildTextWidget('备注', ScreenUtil().setSp(51.0), Colors.white),
          ),
          onTap: slidableTap,
        )
      ],
    );
  }
}
