import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UsersCounter with ChangeNotifier, DiagnosticableTreeMixin {
  int _onLineUsers = 0;
  int _onGamesUsers = 0;
  int _onChatUsers = 0;

  UsersCounter() {
    _onLineUsers = 0;
    _onGamesUsers = 0;
    _onChatUsers = 0;
  }

  set onLineUsers(value) {
    _onLineUsers = value;
    notifyListeners();
  }

  set onGamesUsers(value) {
    _onGamesUsers = value;
    notifyListeners();
  }

  set onChatUsers(value) {
    _onChatUsers = value;
    notifyListeners();
  }

  get onLineUsers {
    return _onLineUsers;
  }

  get onGamesUsers {
    return _onGamesUsers;
  }

  get onChatUsers {
    return _onChatUsers;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(IntProperty('onLineUsers', _onLineUsers));
    properties.add(IntProperty('onGameUsers', _onGamesUsers));
    properties.add(IntProperty('onChatUsers', _onChatUsers));
  }
}
