import 'package:zoo_flutter/models/user/user_info.dart';

class FriendInfo {
  final UserInfo user;
  final String status;
  final dynamic fbUser;
  final dynamic online;

  FriendInfo({this.user, this.status, this.fbUser, this.online = null});

  factory FriendInfo.fromJSON(data) {
    return FriendInfo(
      user: UserInfo.fromJSON(data["user"]),
      status: data["status"],
      fbUser: data["fbUser"],
      online: data["online"],
    );
  }
}
