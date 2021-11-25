import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_im/blocs/global/global_bloc.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/constant/style.dart';
import 'package:flutter_im/ui/contacts/contacts_page.dart';
import 'package:flutter_im/ui/session/sesion_page.dart';
import 'package:flutter_im/ui/test/2.dart';
import 'package:flutter_im/ui/test/3.dart';
import 'package:flutter_svg/svg.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with WidgetsBindingObserver {
  List<Widget> _pageList = []; // pages

  int _currentIndex = 0; // 当前索引

  bool navBarStatus = true; // 底部导航显示状态

  final PageController _pageController = PageController();

  List<BottomNavigationBarItem> _tabItems = [
    buildBarItem('微信', 'icons_outlined_chats.svg', 'icons_filled_chats.svg'),
    buildBarItem('通讯录', 'icons_outlined_contacts.svg', 'icons_filled_contacts.svg'),
    buildBarItem('发现', 'icons_outlined_discover.svg', 'icons_filled_discover.svg'),
    buildBarItem('我', 'icons_outlined_me.svg', 'icons_filled_me.svg'),
  ];

  // 构建底部菜单
  static buildBarItem(String title, String image, String selectedImage) {
    return BottomNavigationBarItem(
      label: title,
      icon: SvgPicture.asset(Constant.assetsImagesTabbar + image),
      activeIcon: SvgPicture.asset(Constant.assetsImagesTabbar + selectedImage, color: Style.pTintColor),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageList..add(MainframePage())..add(ContactsPage())..add(SecondPage())..add(ThreePage());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Fixed Bug : bottomNavigationBar 的子页面无法监听到键盘高度变化, so 没办法只能再此监听了
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      // Provider.of<KeyboardProvider>(context, listen: false)
      //     .setKeyboardHeight(keyboardHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalBloc, GlobalState>(listener: (BuildContext context, GlobalState state) {
      setState(() => navBarStatus = state is NavBarShow);
    }, builder: (context, _) {
      return Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          children: _pageList,
          physics: NeverScrollableScrollPhysics(), // 禁止手势滑动切换
          onPageChanged: (int index) => setState(() => _currentIndex = index),
        ),
        bottomNavigationBar: navBarStatus
            ? CupertinoTabBar(
                items: _tabItems,
                onTap: (int index) => _pageController.jumpToPage(index),
                currentIndex: _currentIndex,
                activeColor: Style.pTintColor,
                inactiveColor: Color(0xFF191919),
              )
            : null,
      );
    });
  }
}
