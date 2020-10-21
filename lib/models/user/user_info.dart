import 'package:flutter/material.dart';

enum UserSex {Boy, Girl}

class UserInfo {
  final int userId;
  final String username;
  final UserSex sex;
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
