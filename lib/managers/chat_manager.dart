import 'package:lazytime/connection.dart';
import 'package:lazytime/shared_object.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/env.dart';

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
  Function(String notice, String user, Map from) onNotice;
  Function(Map message) onPrivateMessage;
  Function(Map operators) onSyncOperators;
  Function(int operators) onBanned;
  Function() onNoAccess;
  Function() onConnectionClosed;

  init() {
    print("init chat manager.");
    // setup connection
    _con = Connection();

    _con.onClose.listen((event) {
      print("connection closed");
      onConnectionClosed();
    });

    _con.registerHandler("chat_setPrivate", (Map message) {
      print("got private message from ${message['from']} : ${message['msg']}");
      onPrivateMessage(message);
    });

    _con.registerHandler("chat_noAccess", () {
      print("chat_noAccess callback");
      onNoAccess();
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
    var url = Env.chatUri;

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
      Map<String, dynamic> opersMap = data;

      onSyncOperators(opersMap);
    });

    await _soOpers.connect();
    print("_soOpers connected");

    // Users SharedObject
    _soUsers = SharedObject("chat/mainroom", _con);

    _soUsers.onSync.listen((data) {
      // the so contains a list of users
      // print("so sync");
      Map<String, dynamic> usersMap = data;
      List<UserInfo> users = [];
      usersMap.forEach((username, user) {
        // print("$username => ${user['userId']}");
        var info = UserInfo(
          username: username,
          userId: user['userId'],
          mainPhoto: user['mainPhoto'],
          star: int.parse(user['star']),
          sex: user['sex'],
          level: user['level'],
          points: user['points'],
        );
        info.activated = user['activated'];
        info.code = user['code'];
        info.isChatMaster = user['isChatMaster'];
        users.add(info);
      });

      onSyncUsers(users);
    });

    _soUsers.registerHandler("chat_setPublic", (List<dynamic> messages) {
      // print("got public messages");
      // for (Map message in messages) {
      //   print(message);
      // }
      onPublicMessages(messages);
    });

    _soUsers.registerHandler("chat_setNotice", (dynamic n) {
      // print("chat_setNotice");
      Map res = n;
      onNotice(res["notice"], res["username"], res["from"]);
    });

    _soUsers.registerHandler("chat_setNotices", (List<dynamic> notices) {
      if (notices.length == 0) return;

      // print("chat notices!!!!");
      for (Map notice in notices) {
        onNotice(notice['notice'], notice['username'], notice['from']);
      }
    });

    await _soUsers.connect();
    // print("_soUsers connected");
  }

  void banUser(String username, int time, String type) async {
    print("Ban: ${username} - $time - $type");
    await _con.call("chat_banUser", [
      {"username": username},
      time,
      type
    ]);
  }

  void sendPublic(ChatInfo chatInfo) async {
    Map<String, dynamic> chatInfoMap = Map();
    chatInfoMap["msg"] = chatInfo.msg;
    chatInfoMap["colour"] = chatInfo.colour.value;
    chatInfoMap["fontFace"] = chatInfo.fontFace;
    chatInfoMap["fontSize"] = chatInfo.fontSize;
    chatInfoMap["bold"] = chatInfo.bold;
    chatInfoMap["italic"] = chatInfo.italic;
    // print("sendPublic:");
    // print(chatInfoMap);
    var res = await _con.call("chat_setPublic", [chatInfoMap]);
    print("chat_setPublic done");
    // print(res);
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
    await _con.call("chat_setPrivate", [chatInfoMap]);
    // print("chat_setPrivate done");
  }

  close() {
    _con.close();
  }
}
