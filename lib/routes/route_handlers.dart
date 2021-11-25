import 'package:fluro/fluro.dart';
import 'package:flutter_im/routes/notfound.dart';
import 'package:flutter_im/ui/splash/splash.dart';
import 'package:flutter_im/ui/tabbar/navigation.dart';
import 'package:flutter_im/utils/widgets/common/webview.dart';

/// 跳转到 Splash 启动页面
var splashHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) => Splash());

/// 跳转到 home 主页
var mainFrameHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) => Navigation());

/// 跳转到 webview 页面
var webViewHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) => WebViewPage());

/// 跳转到 404 页面
var notFoundHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) => NotFoundPage());
