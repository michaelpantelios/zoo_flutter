import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_flutter/net/rpc.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _sessionKey = "";
  RPC _rpc;
  SharedPreferences _localPrefs;
  static UserProvider instance = null;

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
    print("params: ${params}");
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
          var loginRes = await _rpc.callMethod('Zoo.Auth.login');
        }
      } else {
        print("Zoo.Idle?");
      }
    }
    notifyListeners();
  }

  get sessionKey => _sessionKey;

  logout() {
    print("logout user.");

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
  }
}
