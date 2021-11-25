import 'package:azlistview/azlistview.dart';
import 'package:flutter_im/http/model/picture/picture.dart';

class User extends ISuspensionBean {
  String name;
  String id;
  String avatar;
  String avatarLarge;
  String coverImageUrl;
  String coverImage;
  String wechatId;
  String featureSign;
  int gender;
  String qq;
  String email;
  String phone;
  String channel;

  /// 地区编码
  String zoneCode;

  /// 地区
  String region;
  List phones;
  List<Picture> pictures;
  String remarks;

  /// 用于通讯录排序
  String tagIndex;
  String namePinyin;
  @override
  String getSuspensionTag() => tagIndex;

  /// 构造函数
  User({
    this.name,
    this.id,
    this.avatar,
    this.avatarLarge,
    this.coverImageUrl,
    this.coverImage,
    this.wechatId,
    this.featureSign,
    this.gender,
    this.qq,
    this.email,
    this.phone,
    this.channel,
    this.zoneCode,
    this.region,
    this.phones,
    this.pictures,
    this.remarks,
    this.namePinyin,
    this.tagIndex,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    avatar = json['avatar'];
    avatarLarge = json['avatar_large'];
    coverImageUrl = json['coverImageUrl'];
    coverImage = json['coverImage'];
    wechatId = json['wechatId'];
    featureSign = json['featureSign'];
    gender = json['gender'];
    qq = json['qq'];
    email = json['email'];
    phone = json['phone'];
    channel = json['channel'];
    zoneCode = json['zoneCode'];
    region = json['region'];
    phones = json['phones'];
    if (json['pictures'] != null) {
      pictures = <Picture>[];
      json['pictures'].forEach((v) {
        pictures.add(new Picture.fromJson(v));
      });
    }
    remarks = json['remarks'];
    namePinyin = json['namePinyin'];
    tagIndex = json['tagIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['avatar_large'] = this.avatarLarge;
    data['coverImageUrl'] = this.coverImageUrl;
    data['coverImage'] = this.coverImage;
    data['wechatId'] = this.wechatId;
    data['featureSign'] = this.featureSign;
    data['gender'] = this.gender;
    data['qq'] = this.qq;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['channel'] = this.channel;
    data['zoneCode'] = this.zoneCode;
    data['region'] = this.region;
    data['phones'] = this.phones;
    if (this.pictures != null) {
      data['pictures'] = this.pictures.map((v) => v.toJson()).toList();
    }
    data['remarks'] = this.remarks;
    data['namePinyin'] = this.namePinyin;
    data['tagIndex'] = this.tagIndex;
    return data;
  }
}
