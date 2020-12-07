import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/user_basic_info.dart';

class PrivateChat extends StatefulWidget {
  PrivateChat({Key key});

  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  PrivateChatState();

  final GlobalKey<ChatMessagesListState> _messagesListKey = new GlobalKey<ChatMessagesListState>();
  Size userContainerSize = new Size(200, 250);
  ProfileInfo testUser = DataMocker.fakeProfiles[0];
  TextEditingController sendMessageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sendMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        // padding: EdgeInsets.all(5),
        child: Row(
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
                            height: MediaQuery.of(context).size.height - 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            )),
                            padding: EdgeInsets.all(3),
                            // color: Colors.black,
                            child: ChatMessagesList(key: _messagesListKey, chatMode: ChatMode.private)),
                        Container(height: 40),
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
                                        _messagesListKey.currentState.addPublicMessage(UserProvider.instance.userInfo.username, sendMessageController.text);
                                        sendMessageController.clear();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [Icon(Icons.send, color: Colors.green, size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_privateChat_btnSend"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
                                      ),
                                    ))
                              ],
                            ))
                      ],
                    ))),
            SizedBox(width: 5),
            Container(
                width: userContainerSize.width + 10,
                child: Column(
                  children: [
                    UserBasicInfo(profileInfo: testUser, size: userContainerSize),
                    SizedBox(height: 15),
                    Container(
                        width: userContainerSize.width,
                        height: 30,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {},
                          child: Text(AppLocalizations.of(context).translate("app_privateChat_btnIgnore"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                        ))
                  ],
                ))
          ],
        ));
  }
}
