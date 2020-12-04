import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_flutter/net/rpc.dart';

class LoginData {
  final String username; //The username of the user
  final int userId; //User's id
  final dynamic birthday; //User's birthday
  final int country; //User's country
  final String zip; //User's postal code (only for greek users)
  final String city; //User's city (only for foreign users)
  final int star; //1- user is star member 0- otherwise
  final int sex; //1-man, 2-woman, 4-couple
  final int logins; //The number of times this user has logged in
  final dynamic lastLogin; //The exact date and time of his last login (obviously it will be the current datetime)
  final int userCode; //User's numeric code
  final int coins; //The number of user's coins
  final dynamic mainPhoto; //An object with info about his main photo
  final int fbUser; //0- zoo only account, 1- facebook-only account, without password, 2- linked zoo and facebook accounts
  final int unreadMail; //number of unread mail messages
  final int unreadAlerts; //number of unread alerts
  final int points; //user's weekly points
  final int level; //user's level
  final int levelPoints; //user's points for the next level
  final String levelTotal; //total number of points to reach the next level
  final Map<String, dynamic> settings; //an object with the following fields: favourites:  user-defined setting, background:  user-defined setting
  LoginData({
    this.username,
    this.userId,
    this.birthday,
    this.country,
    this.zip,
    this.city,
    this.star,
    this.sex,
    this.logins,
    this.lastLogin,
    this.userCode,
    this.coins,
    this.mainPhoto,
    this.fbUser,
    this.unreadMail,
    this.unreadAlerts,
    this.points,
    this.level,
    this.levelPoints,
    this.levelTotal,
    this.settings,
  });

  factory LoginData.fromJSON(data) {
    return LoginData(
      username: data["username"],
      userId: data["userId"],
      birthday: data["birthday"],
      country: data["country"],
      zip: data["zip"],
      city: data["city"],
      star: data["star"],
      sex: data["sex"],
      logins: data["logins"],
      lastLogin: data["lastLogin"],
      userCode: data["userCode"],
      coins: data["coins"],
      mainPhoto: data["mainPhoto"],
      fbUser: data["fbUser"],
      unreadMail: data["unreadMail"],
      unreadAlerts: data["unreadAlerts"],
      points: data["points"],
      level: data["level"],
      levelPoints: data["levelPoints"],
      levelTotal: data["levelTotal"],
      settings: data["settings"],
    );
  }
}

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _sessionKey = "";
  bool _logged = false;
  LoginData _loginData;

  RPC _rpc;
  SharedPreferences _localPrefs;
  static UserProvider instance;

  UserProvider() {
    print("user provider!");
    instance = this;
    _init();
  }

  _init() async {
    _localPrefs = await SharedPreferences.getInstance();
    _rpc = RPC();
    final uri = Uri.parse(window.location.toString());
    var params = uri.queryParameters;
    print("params: $params");
    if (params['sessionKey'] == null) {
      var s = await _rpc.callMethod('Zoo.Auth.simulateIndexPage');
      if (s["status"] == "ok") {
        _sessionKey = s["data"]["sessionKey"];
      } else {
        print(s["errorMsg"]);
      }
    } else {
      _sessionKey = params['sessionKey'];

      if (params["username"] != "" && params["userId"] != "") {
        if (params["fbRefresh"] == "1") {
        } else {
          var loginRes = await this.login(null);
          print(loginRes);
        }
      } else {
        print("Zoo.Idle?");
      }
    }

    notifyListeners();
  }

  get sessionKey => _sessionKey;

  login(loginUserInfo) async {
    print("login!");
    var res = await _rpc.callMethod('Zoo.Auth.login', [loginUserInfo.toJson()]);
    print(res["data"]);

    if (res["status"] == "ok") {
      _loginData = LoginData.fromJSON(res["data"]);
      _logged = true;
    }

    notifyListeners();

    return res;
  }

  LoginData get loginData => _loginData;
  bool get logged => _logged;

  logout() async {
    print("logout user.");

    var logoutRes = await _rpc.callMethod('Zoo.Auth.logout');
    print(logoutRes);
    _logged = false;

    notifyListeners();
  }

  getMachineCode() {
    if (_localPrefs != null && _localPrefs.getString("mc") != null) {
      return _localPrefs.getString("mc");
    }
    String mc = "";
    var rnd = Random();
    for (var i = 0; i < 16; i++) mc += rnd.nextInt(10).toString();

    _localPrefs.setString("mc", mc);
    return mc;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('sessionKey', _sessionKey));
    properties.add(DiagnosticsProperty<bool>('logged', _logged));
    properties.add(DiagnosticsProperty<LoginData>('loginData', _loginData));
  }
}
