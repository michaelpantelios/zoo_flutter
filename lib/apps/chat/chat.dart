import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/apps/chat/chat_user_renderer.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
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

  bool operator = true;

  final sendMessageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sendMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onlineUsers = DataMocker.users;

    var t = "Τι λέει ρε?";
    var i = 1;
    Timer.periodic(Duration(milliseconds: 4000), (timer) {
      _key.currentState.addPublicMessage(DataMocker.users[i % 2 == 0 ? 1 : 0].username, "${t} ${i}");

      NotificationsProvider.instance.addNotification(NotificationInfo(AppType.Chat, "Title", "Body"));
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      icon: Icon(Icons.emoji_emotions, color: Colors.orange),
                      onPressed: () {},
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.font_download, color: Colors.brown),
                      onPressed: () {},
                    ),
                  ],
                ))),
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
                          decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                        ))),
                        SizedBox(width: 5),
                        Container(
                            height: 50,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                print(sendMessageController.text);
                                _key.currentState.addPublicMessage(UserProvider.instance.userInfo.username, sendMessageController.text);
                                sendMessageController.clear();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.send, color: Colors.green, size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_chat_btn_send"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
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
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: DropdownButton(
                      value: sortUsersByValue,
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
                            return ChatUserRenderer(userInfo: onlineUsers[index]);
                          }),
                    )),
                Expanded(child: Container(margin: EdgeInsets.only(bottom: 5), padding: EdgeInsets.all(5), child: Text(AppLocalizations.of(context).translate("app_chat_you_are_operator"), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)))),
                Container(
                    height: 50,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.stop_circle, color: Colors.red, size: 20), Padding(padding: EdgeInsets.all(3), child: Text("Ban", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
                      ),
                    ))
              ],
            ))
      ],
    );
  }
}
