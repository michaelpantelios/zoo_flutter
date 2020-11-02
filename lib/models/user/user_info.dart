import 'package:flutter/material.dart';

class UserInfo {
  final int userId;
  final String username;
  final int sex;
  final String photoUrl;
  final bool star;

  UserInfo({
      @required this.userId,
      @required this.username,
      @required this.sex,
      @required this.star,
      this.photoUrl
      });
}
