import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'application.dart';
import 'routers.dart';

///
/// fluro 的路由跳转工具类
///

class RouterUtils {
  static push(
    BuildContext context,
    String path, {
    bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.inFromRight, // cupertino: ios 路由跳转效果
  }) {
    FocusScope.of(context).unfocus();
    Application.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition);
  }

  static pushResult(
    BuildContext context,
    String path,
    Function(Object) function, {
    bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.inFromRight,
  }) {
    FocusScope.of(context).unfocus();
    Application.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition).then((result) {
      if (result == null) return; // 页面返回result为null
      function(result);
    }).catchError((error) => print("$error"));
  }

  static pushReplace(
    BuildContext context,
    String path, {
    bool clearStack = false, // 清空所有栈
    TransitionType transition = TransitionType.inFromRight,
    int transitionDuration = 300,
  }) {
    FocusScope.of(context).unfocus();
    Application.router.navigateTo(context, path,
        replace: true, clearStack: true, transition: transition, transitionDuration: Duration(milliseconds: transitionDuration));
  }

  /// 返回
  static void back(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void backWithParams(BuildContext context, result) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }

  /// 跳到WebView页 fluro 不支持传中文, 需转换
  static goWebViewPage(BuildContext context, String title, String url) {
    push(context, '${Routers.webView}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }
}
