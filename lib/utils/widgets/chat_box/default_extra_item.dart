import 'package:flutter/material.dart';
import 'package:flutter_im/utils/widgets/common/common.dart';

import 'extra_item_container.dart';

class DefaultExtraWidget extends StatefulWidget {
  final int index;

  const DefaultExtraWidget({Key key, this.index}) : super(key: key);

  @override
  _DefaultExtraWidgetState createState() => _DefaultExtraWidgetState();
}

class _DefaultExtraWidgetState extends State<DefaultExtraWidget> {
  List data = [
    {"name": "相册", "icon": "assets/images/chat/ic_details_photo.webp"},
    {"name": "拍摄", "icon": "assets/images/chat/ic_details_camera.webp"},
    {"name": "视频通话", "icon": "assets/images/chat/ic_details_media.webp"},
    {"name": "位置", "icon": "assets/images/chat/ic_details_localtion.webp"},
    {"name": "红包", "icon": "assets/images/chat/ic_details_red.webp"},
    {"name": "转账", "icon": "assets/images/chat/ic_details_transfer.webp"},
    {"name": "语音输入", "icon": "assets/images/chat/ic_chat_voice.webp"},
    {"name": "我的收藏", "icon": "assets/images/chat/ic_details_favorite.webp"},
  ];

  List dataS = [
    {"name": "名片", "icon": "assets/images/chat/ic_details_card.webp"},
    {"name": "文件", "icon": "assets/images/chat/ic_details_file.webp"},
  ];

  Widget itemBuild(data) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(bottom: 20.0),
      child: new Wrap(
        runSpacing: 10.0,
        spacing: 10,
        children: List.generate(data.length, (index) {
          String name = data[index]['name'];
          String icon = data[index]['icon'];
          return Container(
            width: (MediaQuery.of(context).size.width - 70) / 4,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Image.asset(icon, fit: BoxFit.cover),
                ),
                buildTextWidget(name, 12, Colors.black38)
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      return itemBuild(data);
    } else {
      return itemBuild(dataS);
    }
  }

  ExtraItem createitem() => DefaultExtraItem(
        icon: Icon(Icons.add),
        text: "添加",
        onPressed: () {
          print("添加");
        },
      );
}
