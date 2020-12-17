import 'package:zoo_flutter/models/user/user_main_photo.dart';

class ForumUserModel {
  final dynamic sex;
  final dynamic userId;
  final dynamic mainPhoto;
  final dynamic star;
  final dynamic username;

  ForumUserModel({this.sex, this.userId, this.mainPhoto, this.star, this.username});

  factory ForumUserModel.fromJSON(data) {
    return ForumUserModel(
        username: data["username"],
        sex: data["sex"],
        userId: data["userId"],
        mainPhoto: data["mainPhoto"],
        star: data["star"],
    );
  }
}