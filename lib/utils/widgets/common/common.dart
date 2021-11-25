import 'package:flutter/material.dart';

// Text 组件
Widget buildTextWidget(String text, double size, Color color, {FontWeight weight = FontWeight.normal}) {
  return Text(
    text,
    style: TextStyle(fontSize: size, color: color, fontWeight: weight),
  );
}
