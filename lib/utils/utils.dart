import 'package:flutter/material.dart';

/// 存放公共全局方法

class Utils {
  /// 提示信息
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// 生成带参数的路由
  static String createRoutePath(String router, Map<String, String> params) {
    String routeParam = '';
    if (params.isNotEmpty) {
      params.forEach((field, value) => routeParam += field + '=' + Uri.encodeComponent(value) + '&');
      routeParam = '?' + routeParam.substring(0, routeParam.length - 1);
    }
    return router + routeParam;
  }
}
