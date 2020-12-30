import 'package:zoo_flutter/models/user/user_info.dart';

class FriendInfo {
  final UserInfo user;
  final int status;
  final dynamic fbUser;

  FriendInfo({this.user, this.status, this.fbUser});

  factory FriendInfo.fromJSON(data) {
    return FriendInfo(
      user: UserInfo.fromJSON(data["user"]),
      status: data["status"],
      fbUser: data["fbUser"],
    );
  }
}
