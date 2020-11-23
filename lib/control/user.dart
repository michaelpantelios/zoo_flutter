import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class User {
  User._privateConstructor();

  UserInfoModel userInfo;

  static final User _instance = User._privateConstructor();

  static User get instance {
    _instance.userInfo  = DataMocker.users.where((user) => user.userId == 0).first;

    return _instance;
  }
}