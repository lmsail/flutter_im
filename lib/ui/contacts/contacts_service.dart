import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im/http/model/contact/contact.dart';
import 'package:lpinyin/lpinyin.dart';

class ContactsService {
  /// 获取图片地址
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/contact1/$name.$format';
  }

  /// 底部弹窗显示
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 2)),
    );
  }

  /// 获取联系人列表
  static Future<List<ContactInfo>> loadContactList() async {
    List<ContactInfo> contactList = []; // 联系人列表
    final jsonString = await rootBundle.loadString('mock/contacts.json');
    final List contactsJson = json.decode(jsonString);
    contactsJson.forEach((v) => contactList.add(ContactInfo.fromJson(v)));
    if (contactList.isNotEmpty) {
      for (int i = 0, length = contactList.length; i < length; i++) {
        String pinyin = PinyinHelper.getPinyinE(contactList[i].name);
        String tag = pinyin.substring(0, 1).toUpperCase();
        contactList[i].namePinyin = pinyin;
        contactList[i].tagIndex = RegExp("[A-Z]").hasMatch(tag) ? tag : "#";
      }
      SuspensionUtil.sortListBySuspensionTag(contactList); // A-Z sort.
      SuspensionUtil.setShowSuspensionStatus(contactList); // show sus tag. 关键点
      contactList.insert(0, ContactInfo(name: 'header', tagIndex: "🔍")); // index bar support local images. add header.
    }
    return contactList;
  }
}
