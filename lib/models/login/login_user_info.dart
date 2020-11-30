import 'package:flutter/foundation.dart';

class LoginUserInfo {
  final String username; //The username of the user, or undefined for automatic login
  final String password; //User's password, or undefined for automatic login
  final String activationCode; //User's activation code, received by email
  final String machineCode; //User's machineCode
  final int keepLogged; //If 1 then the user's session will expire after 1 week and a permanent cookie will be set for the same period
  final int facebook; //1- login using fb connect

  LoginUserInfo({
    @required this.username,
    @required this.password,
    @required this.activationCode,
    @required this.machineCode,
    @required this.keepLogged,
    this.facebook = 0,
  });

  Map<String, dynamic> toJson() => {
        'username': this.username,
        'password': this.password,
        'activationCode': this.activationCode,
        'machineCode': this.machineCode,
        'keepLogged': this.keepLogged,
        'facebook': this.facebook,
      };
}