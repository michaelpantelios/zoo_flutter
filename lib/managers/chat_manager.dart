import 'package:js/js_util.dart';
import 'package:lazytime/Connection.dart';
import 'package:lazytime/SharedObject.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

import '../jsTypes.dart';

class ChatManager {
  Connection _con;
  SharedObject _soUsers;
  SharedObject _soOpers;
  ChatManager._privateConstructor();

  static final ChatManager instance = ChatManager._privateConstructor();

  Function onConnect;
  Function onUserEntered;
  Function(List<UserInfo> users) onSyncUsers;
  Function(List<dynamic> messages) onPublicMessages;
  Function(String notice, String user, dynamic from) onNotice;
  Function(Message message) onPrivateMessage;
  Function(dynamic operators) onSyncOperators;
  Function(dynamic operators) onBanned;

  init() {
    print("init chat manager.");
    // setup connection
    _con = Connection();

    _con.onClose.listen((event) {
      print("connection closed");
    });

    _con.registerHandler("chat_setPrivate", (Message message) {
      print("got private message from ${message.from} : ${message.msg}");
      onPrivateMessage(message);
    });

    _con.registerHandler("chat_noAccess", () {
      print("chat_noAccess callback");
    });
    _con.registerHandler("chat_doBan", (dynamic time) {
      print("chat_doBan callback");
      onBanned(time);
    });
    _con.registerHandler("chat_newFeeling", () {
      print("chat_newFeeling callback");
    });
  }

  void connect() async {
    var url = "https://llgames-ltfallback.lazyland.biz/zoo_chat/el_GR";

    print("chat manager -- connect : $url");

    var sessionKey = UserProvider.instance?.sessionKey;
    print("sessionKey: $sessionKey");

    await _con.connect(url, [sessionKey]);
    print("connected");
    onConnect();

    await _con.call("chat_userEntered", []);
    print("userEntered done");
    onUserEntered();

    // Operators SharedObject
    _soOpers = SharedObject("chat/mainroom-opers", _con);

    _soOpers.onSync.listen((data) {
      // the so contains a list of operators
      print("so operators sync:");
      Map<String, dynamic> opersMap = jsToMap<dynamic>(data);
      print(opersMap);

      onSyncOperators(opersMap);
    });

    await _soOpers.connect();
    print("_soOpers connected");

    // Users SharedObject
    _soUsers = SharedObject("chat/mainroom", _con);

    _soUsers.onSync.listen((data) {
      // the so contains a list of users
      print("so sync");
      Map<String, User> usersMap = jsToMap<User>(data);
      List<UserInfo> users = [];
      usersMap.forEach((username, user) {
        print("$username => ${user.userId}");
        var info = UserInfo(
          username: username,
          userId: user.userId,
          mainPhoto: user.mainPhoto,
          star: user.star,
          sex: user.sex,
          level: user.level,
          points: user.points,
        );
        info.activated = user.activated;
        info.code = user.code;
        info.isChatMaster = user.isChatMaster;
        users.add(info);
      });

      onSyncUsers(users);
    });

    _soUsers.registerHandler("chat_setPublic", (List<dynamic> messages) {
      print("got public messages");
      for (Message message in messages) {
        print(message);
      }
      onPublicMessages(messages);
    });

    _soUsers.registerHandler("chat_setNotice", (dynamic n) {
      print("chat_setNotice");
      onNotice(n.notice, n.username, n.from);
    });

    _soUsers.registerHandler("chat_setNotices", (List<dynamic> notices) {
      if (notices.length == 0) return;

      print("chat notices!!!!");
      for (Notice n in notices) {
        onNotice(n.notice, n.username, n.from);
      }
    });

    await _soUsers.connect();
    print("_soUsers connected");
  }

  void sendPublic(ChatInfo chatInfo) async {
    Map<String, dynamic> chatInfoMap = Map();
    chatInfoMap["msg"] = chatInfo.msg;
    chatInfoMap["colour"] = chatInfo.colour.value;
    chatInfoMap["fontFace"] = chatInfo.fontFace;
    chatInfoMap["fontSize"] = chatInfo.fontSize;
    chatInfoMap["bold"] = chatInfo.bold;
    chatInfoMap["italic"] = chatInfo.italic;
    print("sendPublic:");
    print(chatInfoMap);
    var res = await _con.call("chat_setPublic", [jsify(chatInfoMap)]);
    print("chat_setPublic done");
    print(res);
  }

  void sendPrivate(ChatInfo chatInfoPrivate) async {
    Map<String, dynamic> chatInfoMap = Map();
    chatInfoMap["msg"] = chatInfoPrivate.msg;
    chatInfoMap["colour"] = chatInfoPrivate.colour.value;
    chatInfoMap["fontFace"] = chatInfoPrivate.fontFace;
    chatInfoMap["fontSize"] = chatInfoPrivate.fontSize;
    chatInfoMap["bold"] = chatInfoPrivate.bold;
    chatInfoMap["italic"] = chatInfoPrivate.italic;
    chatInfoMap["to"] = chatInfoPrivate.to;
    await _con.call("chat_setPrivate", [jsify(chatInfoMap)]);
    print("chat_setPrivate done");
  }
}
