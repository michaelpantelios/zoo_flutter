import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/user_basic_info.dart';

class PrivateChat extends StatefulWidget {
  final UserInfo userInfo;
  PrivateChat({Key key, this.userInfo}) : super(key: key);

  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  PrivateChatState();

  final GlobalKey<ChatMessagesListState> _messagesListKey = new GlobalKey<ChatMessagesListState>();
  Size userContainerSize = new Size(200, 250);
  TextEditingController sendMessageController = TextEditingController();
  ProfileInfo _profileInfo;
  RPC _rpc;

  @override
  void initState() {
    super.initState();
    _rpc = RPC();
    getProfileInfo();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sendMessageController.dispose();
    super.dispose();
  }

  getProfileInfo() async {
    var userid = int.parse(widget.userInfo.userId.toString());
    setState(() {
      _profileInfo = DataMocker.fakeProfiles.firstWhere((element) => element.user.userId == widget.userInfo.userId);
    });

    return;
    var res = await _rpc.callMethod("Profile.Main.getProfileInfo", [userid]);

    if (res["status"] == "ok") {
      print(res["data"]);
      setState(() {
        _profileInfo = ProfileInfo.fromJSON(res["data"]);
      });
    } else {
      print("ERROR");
      print(res);
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFffffff),
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
                                        _messagesListKey.currentState.addPublicMessage(UserProvider.instance.userInfo.username, sendMessageController.text, Colors.black);
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
                    UserBasicInfo(profileInfo: _profileInfo, size: userContainerSize),
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
