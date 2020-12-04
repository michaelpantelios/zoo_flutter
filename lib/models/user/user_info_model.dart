import 'package:flutter/material.dart';

class UserInfoModel {
  final int userId;
  final String username;
  final int sex;
  final String photoUrl;
  final bool star;
  final int age;
  final String country;
  final String city;
  final int coins;
  final String quote;
  final String zodiac;
  final String signupDate;
  final String lastLogin;
  final String onlineTime;
  final int zooLevel;
  final bool isOnline;

  UserInfoModel({
    @required this.userId,
    @required this.username,
    @required this.sex,
    @required this.star,
    this.photoUrl = "",
    this.age = -1,
    this.country,
    this.city,
    this.coins,
    this.quote,
    this.zodiac,
    this.signupDate,
    this.lastLogin,
    this.onlineTime,
    this.zooLevel,
    this.isOnline
  });
}
