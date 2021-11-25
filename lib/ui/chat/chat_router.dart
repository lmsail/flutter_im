import 'package:fluro/fluro.dart';
import 'package:flutter_im/routes/routers.dart';
import 'package:flutter_im/ui/chat/chat_page.dart';

class ChatRouter implements IRouterProvider {
  static const String chat = '/chat'; // 验证码登录

  @override
  void initRouter(FluroRouter router) {
    router.define(
      chat,
      handler: Handler(handlerFunc: (_, params) {
        return ChatPage(id: params['id'].first, title: params['title'].first);
      }),
    );
  }
}
