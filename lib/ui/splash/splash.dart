import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/routes/router_util.dart';
import 'package:flutter_im/routes/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as FlutterScreenUtil;

/// 闪屏界面主要用来中转（新特性界面、登陆界面、主页面）
class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  TimerUtil _timerUtil; // 定时器相关
  String skipPath; // 跳转路径
  int _count = 3; // 倒计时

  @override
  void dispose() {
    super.dispose();
    if (_timerUtil != null) _timerUtil.cancel(); // 记得中dispose里面把timer cancel。
  }

  @override
  void initState() {
    super.initState();
    WidgetUtil widgetUtil = WidgetUtil();
    widgetUtil.asyncPrepares(true, (_) async {
      await SpUtil.getInstance();
      _configureCountDown();
    });
  }

  /// 这里读取缓存或请求接口检测用户登录状态
  void _switchRootView() {
    final String currentUser = null; // 取出用户
    print("currentUser有没有值啊");
    print(currentUser != null);
    if (currentUser != null) {
      print("有登陆账号 + 有用户数据 跳转到 主页");
    } else {
      print("没有登陆账号 + 没有用户数据 跳转到登陆");
      // skipPath = LoginRouter.login;
      skipPath = Routers.mainFrame;
    }
    RouterUtils.pushReplace(context, skipPath, transition: TransitionType.fadeIn, transitionDuration: 500); // 跳转对应的主页
  }

  /// 配置倒计时
  void _configureCountDown() {
    _timerUtil = TimerUtil(mTotalTime: _count * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() => _count = _tick.toInt());
      if (_tick == 0) {
        _switchRootView();
      }
    });
    _timerUtil.startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    // 引入自适应布局
    FlutterScreenUtil.ScreenUtil.init(context, width: 1242.0, height: 2208.0, allowFontScaling: false);

    MediaQuery.of(context);
    return Material(child: _buildDefaultLaunchImage(_count));
  }

  Widget _buildDefaultLaunchImage(int _count) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          Positioned(top: 50.0, right: 20.0, child: _buildPassButton(_count)),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(image: AssetImage('assets/images/LaunchImage.png'), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  // 跳过按钮
  Widget _buildPassButton(int _count) {
    return TextButton(
      child: Text("跳过($_count)"),
      onPressed: () => _switchRootView(),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
        backgroundColor: MaterialStateProperty.resolveWith((states) => Color.fromRGBO(0, 0, 0, 0.1)),
        shape: MaterialStateProperty.all(StadiumBorder()),
      ),
    );
  }
}
