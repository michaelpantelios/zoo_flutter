import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat_list.dart';
import 'package:zoo_flutter/models/login/login_user_info.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/net/zmq_connection.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
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
    if (params['sessionKey'] == null) {
      var s = await _rpc.callMethod('Zoo.Auth.simulateIndexPage');
      if (s["status"] != "ok") {
        print(s["errorMsg"]);
        return;
      }

      _sessionKey = s["data"]["sessionKey"];

      // if the user is already logged we get a userId. In this case perform an "automatic login"
      if (s["data"]["userId"] != null) {
        print("got user id ${s["data"]["userId"]}, performing automatic login");
        await login(LoginUserInfo(username: null, password: null)); // null -> automatic login from the existing session
      } else {
        // not logged, connect to zmq now (just start, no need to await)
        _zmqConnect();
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

    // connect to zmq on success (but even on failure if not already connected)
    if (_logged || zmq == null) _zmqConnect(); // just start, no need to await

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

  Future<void> _zmqConnect() async {
    // _zmqConnect will be called twice if the user is not logged when the page loads (once at load, and once
    // after the login). The second time we just call authenticate()
    if (zmq != null) return zmq.authenticate(_sessionKey);

    zmq = ZMQConnection();

    zmq.onMessage.listen((ZMQMessage msg) {
      print("got message from zmq: ${msg.name} ${msg.args}");
      NotificationsProvider.instance.addNotification(NotificationInfo(msg.name, msg.args));
      switch (msg.name) {
        case NotificationType.ON_COINS_CHANGED:
          _userInfo.coins = int.parse(msg.args["newCoins"].toString());
          notifyListeners();
          break;
        case NotificationType.ON_NEW_POINTS:
          _userInfo.levelPoints += int.parse(msg.args["points"].toString());
          notifyListeners();
          if (int.parse(_userInfo.levelPoints.toString()) >= int.parse(_userInfo.levelTotal.toString())) {
            _getUserPoints();
          }
          break;
        case NotificationType.ON_NEW_MAIL:
          _userInfo.unreadMail++;
          notifyListeners();
          break;
        case NotificationType.ON_MESSENGER_CHAT_MESSAGE:
          var from = msg.args["message"]["from"];
          List<MessengerMsg> messages = UserProvider.instance.loadMessengerHistory(from["username"]);
          if (messages == null) messages = [];
          messages.add(MessengerMsg.fromJSON(msg.args["message"]));
          UserProvider.instance.saveMessengerHistory(messages, from["username"]);
          break;
        default:
          break;
      }
    });

    // Only pass a sessionKey if we are logged. Note: ZMQConnect reconnects automatically
    await zmq.connect(_logged ? sessionKey : null);
  }

  _getUserPoints() async {
    var res = await _rpc.callMethod("Points.Main.getUserPoints", []);
    print(res);
    if (res["status"] == "ok") {
      _userInfo.levelPoints = int.parse(res["data"]["levelPoints"].toString());
      _userInfo.level = int.parse(res["data"]["level"].toString());
      _userInfo.levelTotal = int.parse(res["data"]["levelTotal"].toString());
      notifyListeners();
    }
  }

  mailRead() {
    _userInfo.unreadMail--;
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

  set chatPrefs(dynamic settings) {
    if (_localPrefs == null) return;

    _localPrefs.setString("chatPrefs", jsonEncode(settings));
  }

  Map<String, dynamic> get chatPrefs {
    print("chatPrefs");
    if (_localPrefs == null) {
      return new Map<String, dynamic>();
    }
    var s = _localPrefs.getString("chatPrefs");
    if (s == null || s.isEmpty) {
      return new Map<String, dynamic>();
    }

    Map<String, dynamic> decoded = jsonDecode(_localPrefs.getString("chatPrefs"));
    return decoded;
  }

  saveMessengerHistory(List<MessengerMsg> messages, String recipient) {
    print('saveMessengerHistory for ${recipient}');
    if (_localPrefs == null) return;

    List<String> lst = [];
    var key = "";
    for (var msg in messages) {
      if (key.isEmpty) key = "messengerHistory|${UserProvider.instance.userInfo.username}|$recipient";
      // String encoded = base64.encode(utf8.encode(jsonEncode(msg)));
      String encoded = jsonEncode(msg.toJson());

      lst.add(encoded);
    }

    _localPrefs.setStringList(key, lst);
  }

  List<MessengerMsg> loadMessengerHistory(String recipient) {
    print('loadMessengerHistory for ${recipient}');
    if (_localPrefs == null) {
      return null;
    }
    var key = "messengerHistory|${UserProvider.instance.userInfo.username}|$recipient";
    var messagesList = _localPrefs.getStringList(key);
    if (messagesList == null || messagesList.length == 0) {
      return null;
    }

    List<MessengerMsg> lst = [];
    for (var msg in messagesList) {
      // String strDecoded = utf8.decode(base64.decode(msg));
      dynamic strDecoded = jsonDecode(msg);
      MessengerMsg decodedMsg = MessengerMsg.fromJSON(strDecoded);

      lst.add(decodedMsg);
    }

    return lst;
  }

  set singlegamesPrefs(List<dynamic> prefs) {
    if (_localPrefs == null) return;

    _localPrefs.setString("singlegamePrefs", jsonEncode(prefs));
  }

  List<dynamic> get singlegamesPrefs {
    print("singlegamePrefs");
    if (_localPrefs == null) {
      return [];
    }

    var s = _localPrefs.getString("singlegamePrefs");
    if (s == null || s.isEmpty) {
      return [];
    }

    List<dynamic> decoded = jsonDecode((_localPrefs.getString("singlegamePrefs")));
    return decoded;
  }

  set browsergamesPrefs(List<dynamic> prefs) {
    if (_localPrefs == null) return;

    _localPrefs.setString("browsergamesPrefs", jsonEncode(prefs));
  }

  List<dynamic> get browsergamesPrefs {
    print("browsergamesPrefs");
    if (_localPrefs == null) {
      return [];
    }

    var s = _localPrefs.getString("browsergamesPrefs");
    if (s == null || s.isEmpty) {
      return [];
    }

    List<dynamic> decoded = jsonDecode((_localPrefs.getString("browsergamesPrefs")));
    return decoded;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('sessionKey', _sessionKey));
    properties.add(DiagnosticsProperty<bool>('logged', _logged));
    properties.add(DiagnosticsProperty<UserInfo>('userInfo', _userInfo));
  }
}
