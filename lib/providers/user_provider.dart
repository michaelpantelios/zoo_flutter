import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isLoggedIn = false;
  String _username = "";
  int _coins = 0;

  User() {
    _isLoggedIn = false;
    _username = "";
    _coins = 0;
  }

  set isLoggedIn(value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  get isLoggedIn => _isLoggedIn;

  set username(value) {
    _username = value;
    notifyListeners();
  }

  get username => _username;

  set coins(value) {
    _coins = value;
    notifyListeners();
  }

  get coins => _coins;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isLoggedIn', _isLoggedIn));
    properties.add(StringProperty('username', _username));
    properties.add(IntProperty('coins', _coins));
  }
}
