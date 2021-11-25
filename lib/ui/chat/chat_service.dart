import 'package:flutter_im/http/model/chat/chat.dart';
import 'package:flutter_im/http/model/chat/redpacket.dart';
import 'package:flutter_im/http/model/user/user.dart';
import 'package:flutter_im/utils/widgets/message/chat_message.dart';

class ChatService {
  static List<ChatData> fetchChatList(String title) {
    List<ChatData> chatList = [];
    final String selfAvatar = 'https://user-gold-cdn.xitu.io/2019/6/24/16b8943fa0ebcb49?imageView2/1/w/100/h/100/q/85/format/webp/interlace/1';
    final String friendAvatar = 'https://sf3-ttcdn-tos.pstatp.com/img/user-avatar/e909c7f735c08a0904ff98bdffd06903~300x300.image';
    final String img1 =
        'https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/70e4365b58564a4cbbffe49c68b235e4~tplv-k3u1fbpfcp-zoom-mark-crop-v2:460:460:0:0.awebp';
    final User selfUser = User(name: '', avatar: selfAvatar);
    final User friendUser = User(name: title, avatar: friendAvatar);
    List<Map> list = [
      {"id": "100001", "message": "07-12 23:55", "type": MessageType.system},
      {"id": "100002", "message": "我们已经是好友拉，现在可以愉快的交流了", "user": selfUser},
      {"id": "100003", "message": "王者荣耀永恒砖石，请求出战！", "user": selfUser},
      {"id": "100004", "message": "你好呀，一起开黑吗", "user": friendUser, "isSelf": false},
      {"id": "100005", "message": "今晚带飞你！", "user": friendUser, "isSelf": false},
      {"id": "100006", "message": "22:12", "type": MessageType.system},
      {"id": "100007", "message": "好啊，我现在还是黑铁，哈哈哈", "user": selfUser},
      {"id": "100008", "message": img1, "user": friendUser, "isSelf": false, "type": MessageType.image},
      {"id": "100009", "message": "23:22", "type": MessageType.system},
      {"id": "100010", "redInfo": RedPacket(id: '100002'), "user": friendUser, "isSelf": false, "type": MessageType.redpacket},
    ];
    // 这里要倒叙下数据结构
    (list.reversed).forEach((item) {
      ChatData chatdata = ChatData();
      print(item["type"]);
      print("🌹🌹🌹🌹🌹");
      item["type"] = item["type"] ?? MessageType.text;
      switch (item["type"]) {
        case MessageType.system:
          chatdata = ChatData(id: item["id"], type: MessageType.system, message: item["message"]);
          break;
        case MessageType.image:
          chatdata = ChatData(id: item["id"], type: MessageType.image, message: item["message"], user: item["user"], isSelf: item["isSelf"]);
          break;
        case MessageType.redpacket:
          chatdata = ChatData(id: item["id"], type: MessageType.redpacket, redInfo: item["redInfo"], user: item["user"], isSelf: item["isSelf"]);
          break;
        default:
          chatdata = ChatData(id: item["id"], message: item["message"], user: item["user"]);
      }
      chatList.add(chatdata);
    });
    return chatList;
  }
}
