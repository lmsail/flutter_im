// 登陆AppBar 公共组件
import 'package:flutter/material.dart';

Widget buildLoginAppBar(Function callback) {
  return AppBar(
    leading: IconButton(
      onPressed: () => callback(),
      icon: Icon(Icons.arrow_back),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
