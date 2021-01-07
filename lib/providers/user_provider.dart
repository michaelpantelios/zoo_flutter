import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_flutter/models/login/login_user_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/net/zmq_connection.dart';
import 'package:zoo_flutter/utils/utils.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _sessionKey = "";
  bool _logged = false;
  UserInfo _userInfo;

  RPC _rpc;
  ZMQConnection zmq;
  SharedPreferences _localPrefs;
  static UserProvider instance;

  UserProvider() {
    instance = this;
    _init();
  }

  _init() async {
    _localPrefs = await SharedPreferences.getInstance();
    _rpc = RPC();
    final uri = Utils.instance.windowURL();
    var params = uri.queryParameters;
    print("params: $params");
    if (params['sessionKey'] == null) {
      var s = await _rpc.callMethod('Zoo.Auth.simulateIndexPage');
      if (s["status"] != "ok") {
        print(s["errorMsg"]);
        return;
      }

      _sessionKey = s["data"]["sessionKey"];

      // if the user is already logged we get a userId. In this case perform an "automatic login"
      if(s["data"]["userId"] != null) {
        print("got user id ${s["data"]["userId"]}, performing automatic login");
        await login(LoginUserInfo(username:null, password:null));    // null -> automatic login from the existing session
      }

    } else {
      _sessionKey = params['sessionKey'];

      if (params["username"] != "" && params["userId"] != "") {
        if (params["fbRefresh"] == "1") {
        } else {
          var loginUserInfo = LoginUserInfo(
            username: null,
            password: null,
          );
          var loginRes = await this.login(loginUserInfo);
          print(loginRes);
        }
      } else {
        print("Zoo.Idle?");
      }
    }

    notifyListeners();
  }

  get sessionKey => _sessionKey;

  login(LoginUserInfo loginUserInfo) async {
    var res = await _rpc.callMethod('Zoo.Auth.login', [loginUserInfo.toJson()]);
    print(res["data"]);

    if (res["status"] == "ok") {
      _userInfo = UserInfo.fromJSON(res["data"]);
      _logged = true;
    }

    notifyListeners();

    await _zmqConnect();

    return res;
  }

  UserInfo get userInfo => _userInfo;
  bool get logged => _logged;

  logout() async {
    print("logout user.");

    var logoutRes = await _rpc.callMethod('Zoo.Auth.logout');
    print(logoutRes);
    if (logoutRes["status"] == "ok") {
      _logged = false;
      window.location.reload();
    }

    notifyListeners();
  }

  Future<void>_zmqConnect() async {
    zmq = ZMQConnection();

    zmq.onMessage.listen((ZMQMessage msg) {
      print("got message from zmq: ${msg.name} ${msg.args}");
    });

    await zmq.connect(sessionKey);    // ZMQConnect reconnects automatically
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
    properties.add(DiagnosticsProperty<UserInfo>('userInfo', _userInfo));
  }
}
