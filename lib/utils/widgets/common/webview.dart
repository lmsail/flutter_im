import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("百度一下，你就知道"), backgroundColor: Colors.white, elevation: 0.5),
      body: WebView(initialUrl: "https://www.baidu.com/"),
    );

    // return WebviewScaffold(
    //   url: "https://www.baidu.com/",
    //   appBar: AppBar(
    //     title: const Text('百度一下，你就知道'),
    //     backgroundColor: Colors.white,
    //     leading: IconButton(
    //       onPressed: () {
    //         // 解决webview页面重影的问题，但不太友好
    //         flutterWebviewPlugin.close();
    //         Navigator.of(context).pop();
    //       },
    //       icon: Icon(Icons.arrow_back),
    //       splashColor: Colors.transparent,
    //       highlightColor: Colors.transparent,
    //     ),
    //   ),
    //   withZoom: true,
    //   withLocalStorage: true,
    //   hidden: true,
    //   initialChild: Container(
    //     color: Colors.white,
    //     child: Center(
    //       child: buildTextWidget("加载中...", 20.0, Colors.black),
    //     ),
    //   ),
    // );
  }
}
