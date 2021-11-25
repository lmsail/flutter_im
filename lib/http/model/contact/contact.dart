import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

class CityModel extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  CityModel({this.name, this.tagIndex, this.namePinyin});

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => json.encode(this);
}

class ContactInfo extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  Color bgColor;
  IconData iconData;

  String avatar;
  String id;
  String firstletter;

  ContactInfo({
    this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.avatar,
    this.id,
    this.firstletter,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatar = json['avatar'],
        id = json['id'].toString(),
        firstletter = json['firstletter'];

  Map<String, dynamic> toJson() => {'name': name, 'avatar': avatar};

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => json.encode(this);
}
