import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_im/blocs/global/global_bloc.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/constant/style.dart';
import 'package:flutter_im/ui/chat/chat_router.dart';
import 'package:flutter_im/ui/login/login_router.dart';
import 'package:flutter_im/ui/session/session_widget.dart';
import 'package:flutter_im/routes/router_util.dart';
import 'package:flutter_im/http/model/message/message.dart';
import 'package:flutter_im/utils/utils.dart';
import 'package:flutter_im/utils/widgets/message/menus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double _kTabBarHeight = 50.0; // Standard iOS 10 tab bar height.

const String imgPath = Constant.assetsImagesMainframe;

class MainframePage extends StatefulWidget {
  MainframePage({Key key}) : super(key: key);

  @override
  _MainframePageState createState() => _MainframePageState();
}

class _MainframePageState extends State<MainframePage> with AutomaticKeepAliveClientMixin {
  List<Message> _dataSource = []; // 数据源
  SlidableController _slidableController; // 侧滑controller
  ScrollController _controller = ScrollController(); // 滚动
  bool _slideIsOpen = false; // 是否展开
  bool _isRefreshing = false; // 是否是 刷新状态
  bool _showMenu = false; // 显示菜单
  bool _showSearch = false; // 是否展示搜索页
  double _offset = 0.0; // 偏移量（导航栏）
  int _duration = 300; // 动画时间 0 无动画

  /// ✨✨✨✨✨✨✨ Override ✨✨✨✨✨✨✨
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchRemoteData(); // 获取数据

    /// 侧滑按钮事件监听
    _slidableController = SlidableController(
      onSlideAnimationChanged: (Animation<double> slideAnimation) {},
      onSlideIsOpenChanged: (bool isOpen) => setState(() => _slideIsOpen = isOpen),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 为了避免内存泄露，需要调用_controller.dispose
    super.dispose();
  }

  /// 数据请求 - 加载消息列表
  void _fetchRemoteData() async {
    rootBundle.loadString('mock/mainframe.json').then((jsonStr) {
      final List mainframeJson = json.decode(jsonStr);
      mainframeJson.forEach((json) => _dataSource.add(Message.fromJson(json)));
      setState(() {});
    });
  }

  /// 关闭slidable
  void _closeSlidable() {
    if (!_slideIsOpen) return; // 容错处理
    _slidableController.activeState?.close();
  }

  // 构建头部
  Widget _buildHeaderWidget() {
    return SessionWidget.buildAppbar(() {
      _closeSlidable(); // 关闭上一个侧滑
      _showMenu = !_showMenu;
      setState(() {});
    });
  }

  /// 构建➕号菜单
  Widget _buildIconMenuWidget() {
    return Menus(
      show: _showMenu,
      onCallback: (index) {
        _showMenu = false;
        if (index == 4) {
          RouterUtils.pushReplace(context, LoginRouter.login, transition: TransitionType.inFromBottom);
        }
        setState(() {});
      },
    );
  }

  void setSearchAndNavBarStatus(bool searchStatus) {
    setState(() => _showSearch = searchStatus);
    BlocProvider.of<GlobalBloc>(context).add(NavBarStatusChangeEvent(status: !searchStatus));
  }

  /// 构建内容部件
  Widget _buildContentWidget(BuildContext context, GlobalState state) {
    return SessionWidget.buildSessionListWidget(
      _controller,
      _slidableController,
      _dataSource,
      slideIsOpen: _slideIsOpen,
      onEdit: () => setSearchAndNavBarStatus(true),
      onCancel: () => setSearchAndNavBarStatus(false),
      onTapValue: (BuildContext cxt, Message model) {
        print("🔥");
        print(model.idstr);
        print("🔥");
        if (!_slideIsOpen) {
          RouterUtils.push(context, Utils.createRoutePath(ChatRouter.chat, {'id': model.idstr, 'title': model.screenName}));
          return;
        }
        if (Slidable.of(cxt)?.renderingMode == SlidableRenderingMode.none) {
          _closeSlidable(); // 关闭上一个侧滑
        } else {
          Slidable.of(cxt)?.close();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double menuHeight = ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - kToolbarHeight - _kTabBarHeight;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Style.pBackgroundColor,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            // 导航栏
            AnimatedPositioned(
              key: Key('bar'),
              top: _showSearch ? (-kToolbarHeight - ScreenUtil.statusBarHeight) : _offset,
              left: 0,
              right: 0,
              child: _buildHeaderWidget(),
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: _duration),
            ),

            // 最近联系人列表，配合搜索框完成动画
            AnimatedPositioned(
              key: Key('list'),
              top: _isRefreshing ? _offset : (_showSearch ? -kToolbarHeight : 0),
              left: 0,
              right: 0,
              child: BlocConsumer<GlobalBloc, GlobalState>(builder: _buildContentWidget, listener: (BuildContext context, GlobalState state) {}),
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: _duration),
            ),

            // +号点开后的菜单
            Positioned(
              left: 0,
              right: 0,
              height: menuHeight,
              top: ScreenUtil.statusBarHeight + kToolbarHeight,
              child: _buildIconMenuWidget(),
            ),

            // 搜索内容页
            Positioned(
              top: ScreenUtil.statusBarHeight + 56,
              left: 0,
              right: 0,
              height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - 56,
              child: SessionWidget.buildSearchContent(_showSearch),
            ),
          ],
        ),
      ),
    );
  }
}
