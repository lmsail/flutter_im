import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/blocs/bloc_wrapper.dart';
import 'package:flutter_im/constant/constant.dart';
import 'package:flutter_im/constant/style.dart';
import 'package:flutter_im/routes/application.dart';
import 'package:flutter_im/routes/routers.dart';
import 'package:flutter_im/ui/splash/splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true; // 滚动性能优化 1.22.0
  runApp(BlocWrapper(child: FlutterIM()));
  configLoading();

  /// 自定义报错页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    debugPrint(flutterErrorDetails.toString());
    print('发生错误了哦！' + flutterErrorDetails.toString());
    return Center(child: Text(flutterErrorDetails.toString(), style: TextStyle(color: Colors.red)));
  };
}

// 配置 Loading
void configLoading() {
  EasyLoading.instance
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class FlutterIM extends StatelessWidget {
  /// 引入 fluro 路由框架，初始化路由
  FlutterIM() {
    final router = FluroRouter();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false, // 性能浮窗
      title: Constant.appName,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      theme: ThemeData(
        primarySwatch: Style.primarySwatch,
        primaryColor: Style.primaryColor,
        fontFamily: Style.fontFamily,
        appBarTheme: AppBarTheme(elevation: 1),
        scaffoldBackgroundColor: Style.pBackgroundColor,
      ),
      home: Splash(),
      builder: EasyLoading.init(),
    );
  }
}
