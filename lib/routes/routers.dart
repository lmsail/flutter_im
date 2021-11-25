import 'package:fluro/fluro.dart';
import 'package:flutter_im/routes/route_handlers.dart';
import 'package:flutter_im/ui/chat/chat_router.dart';
import 'package:flutter_im/ui/login/login_router.dart';

abstract class IRouterProvider {
  void initRouter(FluroRouter router);
}

class Routers {
  static const String root = '/';
  static const String mainFrame = '/main-frame';
  static const String webView = '/webview';
  static const String notFound = '/notfound';

  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(FluroRouter router) {
    router.define(root, handler: splashHandler);
    router.define(mainFrame, handler: mainFrameHandler);
    router.define(webView, handler: webViewHandler);
    router.define(notFound, handler: notFoundHandler);

    _listRouter.clear();
    _listRouter.add(LoginRouter());
    _listRouter.add(ChatRouter());
    _listRouter.forEach((routerProvider) => routerProvider.initRouter(router)); // 初始化路由
  }
}
