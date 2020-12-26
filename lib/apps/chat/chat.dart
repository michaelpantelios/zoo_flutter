import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/apps/chat/chat_user_renderer.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/chat_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

import '../../jsTypes.dart';

class Chat extends StatefulWidget {
  Chat({Key key});

  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatState();

  RenderBox _renderBox;

  final _messagesListKey = new GlobalKey<ChatMessagesListState>();
  int _sortUsersByValue = 0;
  List<UserInfo> _onlineUsers = [];
  Map<String, dynamic> _opersData;
  List<String> _prvChatHistory = [];

  bool _pendingConnection = true;
  bool _pendingSync = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    ChatManager.instance.init();
    ChatManager.instance.onConnect = _onChatConnected;
    ChatManager.instance.onUserEntered = _onChatUserEntered;
    ChatManager.instance.onSyncUsers = _onSyncUsers;
    ChatManager.instance.onPublicMessages = _onPublicMessages;
    ChatManager.instance.onPrivateMessage = _onPrivateMessage;
    ChatManager.instance.onNotice = _onNotice;
    ChatManager.instance.onSyncOperators = _onSyncOperators;
    ChatManager.instance.onBanned = _onBanned;
    ChatManager.instance.connect();
  }

  _afterLayout(e) {
    _renderBox = context.findRenderObject();
  }

  _onNotice(String notice, String user, dynamic from) {
    String str = "";
    print("_onNotice called from - ${from}");

    if (notice == "NOTICE_BANNED") {
      if (from.webmaster != null) {
        str = AppLocalizations.of(context).translateWithArgs("webmasterBan", [user]);
      } else {
        str = AppLocalizations.of(context).translateWithArgs("opersBan", [user, from.username.split().join(", ")]);
      }

      print(str);

      _showNoticeToChat(str);
    } else if (notice == "NOTICE_ENTERED" || notice == "NOTICE_LEFT") {
      print(" notice: " + notice);
    }
  }

  _showNoticeToChat(String str) {
    var noticeChatInfo = ChatInfo(msg: str, colour: Color(0xff000000), fontFace: "Verdana", fontSize: 12, bold: false, italic: false);

    _messagesListKey.currentState.addMessage("", noticeChatInfo);
  }

  _onChatConnected() {
    print("I am connected to the chat!");
    setState(() {
      _pendingConnection = false;
    });
    for (int i = 0; i <= 7; i++) {
      _messagesListKey.currentState.addMessage("", ChatInfo(msg: AppLocalizations.of(context).translate("app_chat_intro_text_$i")));
    }
  }

  _onChatUserEntered() {
    print("I have entered the chat room.");
  }

  _onSyncUsers(List<UserInfo> users) {
    List<UserInfo> usersLst = [];
    users.forEach((user) {
      user.isOper = _opersData[user.code] == true;
      usersLst.add(user);
    });
    setState(() {
      _onlineUsers = usersLst;
    });

    _refreshOpers();
  }

  _refreshOpers() {
    if (_onlineUsers == null) return;

    _onlineUsers.forEach((user) {
      user.isOper = _opersData[user.code] == true;
      if (user.username == UserProvider.instance.userInfo.username) {
        print("my user code: " + user.code);
        setState(() {
          UserProvider.instance.userInfo.activated = user.activated;
          UserProvider.instance.userInfo.isOper = user.isOper;
          UserProvider.instance.userInfo.code = user.code;
          _pendingSync = false;
        });

        print("i am oper? ${UserProvider.instance.userInfo.isOper}");
      }
    });
  }

  _onSyncOperators(dynamic data) {
    _opersData = data;

    _refreshOpers();
  }

  _onBanned(dynamic time) {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translateWithArgs("banned", [time.toString()]));
  }

  _onPublicMessages(List<dynamic> messages) {
    for (var message in messages) {
      var chatInfo = ChatInfo(msg: message.msg, colour: Color(message.colour), fontFace: message.fontFace, fontSize: message.fontSize, bold: message.bold, italic: message.italic);
      _messagesListKey.currentState.addMessage(message.from, chatInfo);
    }
  }

  _onPrivateMessage(Message msg) {
    print("private message from : ${msg.from}");

    _openPrivateChat(msg.from, msg: msg);
  }

  _onUserRendererChoice(String choice, UserInfo userInfo) {
    print("_onUserRendererChoice :" + choice);
    if (choice == "private") {
      print("add or activate private chat with user ${userInfo.username}");

      _openPrivateChat(userInfo.username);
    } else if (choice == "profile") {
      PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(userInfo.userId.toString()), callbackAction: (res) {});
    }
  }

  _openPrivateChat(String username, {Message msg}) {
    print("_openPrivateChat with: $username");
    var privateChatWindow = context.read<AppBarProvider>().getNestedApps(AppType.Chat).firstWhere((element) => element.id == username, orElse: () => null);

    bool firstTimeAdded = false;
    if (privateChatWindow == null) {
      privateChatWindow = NestedAppInfo(id: username, title: "${username}");
      firstTimeAdded = true;
    }
    privateChatWindow.active = true;

    setState(() {
      if (firstTimeAdded) {
        context.read<AppBarProvider>().addNestedApp(AppType.Chat, privateChatWindow);
        _prvChatHistory.add(username);
      } else {
        context.read<AppBarProvider>().activateApp(AppType.Chat, privateChatWindow);
      }
    });

    if (msg != null) {
      Future.delayed(Duration(milliseconds: 300), () => privateChatWindow.addData(msg));
    }
  }

  _sendMyMessage(ChatInfo chatInfo) {
    print("sendMyMessage: $chatInfo");
    if (chatInfo.to != null) {
      ChatManager.instance.sendPrivate(chatInfo);
      chatInfo.from = UserProvider.instance.userInfo.username;
      var privateChatWindow = AppBarProvider.instance.getNestedApps(AppType.Chat).firstWhere((element) => element.id == chatInfo.to, orElse: () => null);
      if (privateChatWindow != null) {
        Future.delayed(Duration(milliseconds: 300), () => privateChatWindow.addData(chatInfo));
      }
    } else {
      if (UserProvider.instance.userInfo.activated) {
        ChatManager.instance.sendPublic(chatInfo);
      } else {
        AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: AppLocalizations.of(context).translate("notActivated"),
            callbackAction: (res) {
              print(res);
              if (res == 1) {
                print("show activation sms popup");
                _showSmsPopup();
              }
            },
            dialogButtonChoice: AlertChoices.OK_CANCEL);
      }
    }
  }

  _showSmsPopup() {
    PopupManager.instance.show(
        context: context,
        popup: PopupType.SMSActivation,
        callbackAction: (res) {
          print(res);
        });
  }

  Widget _loadingView() {
    return _renderBox != null
        ? Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
            width: _renderBox.size.width,
            height: _renderBox.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  backgroundColor: Colors.white,
                ),
                _pendingConnection
                    ? Text(AppLocalizations.of(context).translate("chat_connecting"))
                    : _pendingSync
                        ? Text(
                            AppLocalizations.of(context).translate("chat_synchronizing"),
                            style: TextStyle(color: Colors.white),
                          )
                        : Container()
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    List<NestedAppInfo> privateNestedChats = context.watch<AppBarProvider>().getNestedApps(AppType.Chat);
    List<String> lst = [];

    _prvChatHistory.forEach((username) {
      if (privateNestedChats.firstWhere((e) => e.id.toString() == username, orElse: () => null) != null) {
        lst.add(username);
      }
    });
    _prvChatHistory = lst;

    var firstActiveChat = privateNestedChats.firstWhere((element) => element.active, orElse: () => null);
    String currentPrvUser;
    if (firstActiveChat != null) {
      currentPrvUser = _prvChatHistory.firstWhere((username) => username == firstActiveChat.id.toString(), orElse: () => null);
    }

    var selectedIndex = currentPrvUser == null ? 0 : (_prvChatHistory.indexOf(currentPrvUser) + 1);
    return Stack(
      children: [
        IndexedStack(
          index: selectedIndex,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: MediaQuery.of(context).size.height - 165,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            )),
                            padding: EdgeInsets.all(3),
                            // color: Colors.black,
                            child: ChatMessagesList(
                              key: _messagesListKey,
                              chatMode: ChatMode.public,
                            )),
                        Spacer(),
                        ChatController(
                          onSend: (chatInfo) => _sendMyMessage(chatInfo),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    width: 200,
                    height: MediaQuery.of(context).size.height - 80,
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: DropdownButton(
                              value: _sortUsersByValue,
                              items: [
                                DropdownMenuItem(
                                  child: Text(AppLocalizations.of(context).translate("app_chat_dropdown_value_0"), style: Theme.of(context).textTheme.bodyText1),
                                  value: 0,
                                ),
                                DropdownMenuItem(
                                  child: Text(AppLocalizations.of(context).translate("app_chat_dropdown_value_1"), style: Theme.of(context).textTheme.bodyText1),
                                  value: 1,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _sortUsersByValue = value;
                                });
                              },
                            )),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: MediaQuery.of(context).size.height - 270,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          )),
                          padding: EdgeInsets.all(3),
                          // color: Colors.black,
                          child: Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _onlineUsers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ChatUserRenderer(
                                    userInfo: _onlineUsers[index],
                                    onMenuChoice: (choice, userInfo) => _onUserRendererChoice(choice, userInfo),
                                  );
                                }),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              UserProvider.instance.userInfo.isOper ? AppLocalizations.of(context).translate("app_chat_you_are_operator") : AppLocalizations.of(context).translate("app_chat_you_are_not_operator"),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ),
                        ),
                        Container(
                            height: 30,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.stop_circle, color: Colors.red, size: 20),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text(
                                      "Ban",
                                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ))
              ],
            ),
          ]..addAll(
              _prvChatHistory.map(
                (username) => PrivateChat(
                  key: Key(username),
                  username: username,
                  onPrivateSend: (chatInfo) => _sendMyMessage(chatInfo),
                ),
              ),
            ),
        ),
        (_pendingConnection || _pendingSync) ? _loadingView() : Container()
      ],
    );
  }
}
