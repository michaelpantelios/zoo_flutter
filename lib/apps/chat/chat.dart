import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/chat/chat_emoticons_layer.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/apps/chat/chat_user_renderer.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class Chat extends StatefulWidget {
  Chat({Key key});

  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatState();

  final _key = new GlobalKey<ChatMessagesListState>();
  int sortUsersByValue = 0;
  List<UserInfo> onlineUsers;
  List<UserInfo> _prvChatHistory = [];

  bool operator = true;

  final sendMessageController = TextEditingController();
  OverlayEntry _overlayEmoticons;
  Offset rendererPosition;
  Size rendererSize;
  RenderBox renderBox;
  bool isEmoticonsLayerOpen = false;

  @override
  void dispose() {
    print("CHAT DISPOSED!");
    sendMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    onlineUsers = DataMocker.users;

    print("CHAT INIT!");

    var t =
        "<span style='color: blueviolet'>Τι λέει ρε? <img src='/assets/images/emoticons/1.gif'></img> <b>yo</b> <a href='https://www.google.com'>google</a></span>";
    var i = 1;
    Timer.periodic(Duration(milliseconds: 4000), (timer) {
      if (_key.currentState != null) {
        _key.currentState.addPublicMessage(
            DataMocker.users[i % 2 == 0 ? 1 : 0].username,
            "${t} ${i}",
            Colors.deepOrange);

        // NotificationsProvider.instance.addNotification(NotificationInfo(AppType.Chat, "Title", "Body"));
      }

      i++;
    });
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
  }

  OverlayEntry _overlayMenuBuilder() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        top: rendererPosition.dy + rendererSize.height - 320,
        left: rendererPosition.dx + 10,
        width: 400,
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[800],
                width: 0.1,
              ),
            ),
            child: ChatEmoticonsLayer(
                onSelected: (emoIndex) => _onEmoSelected(emoIndex)),
          ),
        ),
      );
    });
  }

  _onEmoSelected(emoIndex) {
    print('emoIndex: $emoIndex');
    _appendEmoticon(emoIndex);
    _closeEmoticons();
  }

  _appendEmoticon(emoIndex) {
    var path = ChatEmoticonsLayer.emoticons[emoIndex]["path"];
    var symbol = ChatEmoticonsLayer.emoticons[emoIndex]["symbol"];
    print(path);
    sendMessageController.text = sendMessageController.text + symbol;
  }

  void _closeEmoticons() {
    _overlayEmoticons.remove();
    isEmoticonsLayerOpen = !isEmoticonsLayerOpen;
  }

  void _openEmoticons() {
    _findEmoticonsLayerPosition();
    _overlayEmoticons = _overlayMenuBuilder();
    Overlay.of(context).insert(_overlayEmoticons);
    isEmoticonsLayerOpen = !isEmoticonsLayerOpen;
  }

  _findEmoticonsLayerPosition() {
    rendererSize = renderBox.size;
    rendererPosition = renderBox.localToGlobal(Offset.zero);
  }

  _onUserRendererChoice(String choice, UserInfo userInfo) {
    print("_onUserRendererChoice :" + choice);
    if (choice == "private") {
      print("add or activate private chat with user ${userInfo.username}");

      var prvChatID = userInfo.userId;
      print("prvChatID: $prvChatID");
      var privateChatApp = NestedAppInfo(
          id: prvChatID.toString(),
          title: "Private chat with ${userInfo.username}",
          data: userInfo);
      privateChatApp.active = true;

      var firstTimeAdded = context
          .read<AppBarProvider>()
          .addNestedApp(AppType.Chat, privateChatApp);
      if (firstTimeAdded) {
        setState(() {
          _prvChatHistory.add(userInfo);
        });
      } else {
        context
            .read<AppBarProvider>()
            .activateApp(AppType.Chat, privateChatApp);
      }
    } else if (choice == "profile") {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Profile,
          options: userInfo.userId,
          callbackAction: (res) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<NestedAppInfo> privateNestedChats =
        context.watch<AppBarProvider>().getNestedApps(AppType.Chat);
    List<UserInfo> lst = [];

    _prvChatHistory.forEach((element) {
      if (privateNestedChats.firstWhere(
              (e) => e.id.toString() == element.userId.toString(),
              orElse: () => null) !=
          null) {
        lst.add(element);
      }
    });
    _prvChatHistory = lst;

    print("_prvChatHistory AFTER:");
    _prvChatHistory.forEach((element) {
      print(element.username);
    });

    var firstActiveChat = privateNestedChats
        .firstWhere((element) => element.active, orElse: () => null);
    print("firstActiveChat: ${firstActiveChat?.title}");
    UserInfo currentPrvUser;
    if (firstActiveChat != null) {
      currentPrvUser = _prvChatHistory.firstWhere(
          (element) =>
              element.userId.toString() == firstActiveChat.id.toString(),
          orElse: () => null);
    }

    var selectedIndex = currentPrvUser == null
        ? 0
        : (_prvChatHistory.indexOf(currentPrvUser) + 1);
    return IndexedStack(
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
                        height: MediaQuery.of(context).size.height - 195,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        )),
                        padding: EdgeInsets.all(3),
                        // color: Colors.black,
                        child: ChatMessagesList(
                          key: _key,
                          chatMode: ChatMode.public,
                        )),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.emoji_emotions,
                                  color: Colors.orange),
                              onPressed: () {
                                print("emoticons!");
                                if (isEmoticonsLayerOpen)
                                  _closeEmoticons();
                                else
                                  _openEmoticons();
                              },
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.font_download,
                                  color: Colors.brown),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 30,
                        child: Row(
                          children: [
                            Container(
                                child: Expanded(
                                    child: TextField(
                              controller: sendMessageController,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  border: OutlineInputBorder()),
                            ))),
                            SizedBox(width: 5),
                            Container(
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    print(sendMessageController.text);
                                    _key.currentState.addPublicMessage(
                                        UserProvider.instance.userInfo.username,
                                        sendMessageController.text,
                                        Colors.limeAccent);
                                    sendMessageController.clear();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send,
                                          color: Colors.green, size: 20),
                                      Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      "app_chat_btn_send"),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)))
                                    ],
                                  ),
                                ))
                          ],
                        ))
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
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5.0),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder()),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: DropdownButton(
                          value: sortUsersByValue,
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("app_chat_dropdown_value_0"),
                                  style: Theme.of(context).textTheme.bodyText1),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("app_chat_dropdown_value_1"),
                                  style: Theme.of(context).textTheme.bodyText1),
                              value: 1,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              sortUsersByValue = value;
                            });
                          },
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: MediaQuery.of(context).size.height - 300,
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
                              itemCount: onlineUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChatUserRenderer(
                                  userInfo: onlineUsers[index],
                                  onMenuChoice: (choice, userInfo) =>
                                      _onUserRendererChoice(choice, userInfo),
                                );
                              }),
                        )),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.all(5),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("app_chat_you_are_operator"),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)))),
                    Container(
                        height: 50,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stop_circle,
                                  color: Colors.red, size: 20),
                              Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text("Ban",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)))
                            ],
                          ),
                        ))
                  ],
                ))
          ],
        ),
      ]..addAll(_prvChatHistory
          .map((e) => PrivateChat(key: Key(e.userId.toString()), userInfo: e))),
    );
  }
}
