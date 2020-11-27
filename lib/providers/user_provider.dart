import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/net/rpc.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _sessionKey = "";
  RPC _rpc;

  UserProvider() {
    print("user provider!");
    _init();
  }

  _init() async {
    _rpc = RPC();
    final uri = Uri.parse(window.location.toString());
    var params = uri.queryParameters;
    print("params:");
    print(params);
    if (params['sessionKey'] == null) {
      var s = await _rpc.callMethod('Zoo.Auth.simulateIndexPage');
      print(s);
    } else {
      _sessionKey = params['sessionKey'];
      print("_sessionKey: ${_sessionKey}");
      notifyListeners();
    }
  }

  get sessionKey => _sessionKey;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('sessionKey', _sessionKey));
  }
}
