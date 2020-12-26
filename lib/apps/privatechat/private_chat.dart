import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/jsTypes.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/user_basic_info.dart';

class PrivateChat extends StatefulWidget {
  final String username;
  final Function(ChatInfo chatInfo) onPrivateSend;
  PrivateChat({Key key, @required this.username, @required this.onPrivateSend}) : super(key: key);

  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  PrivateChatState();

  final GlobalKey<ChatMessagesListState> _messagesListKey = new GlobalKey<ChatMessagesListState>();
  Size userContainerSize = new Size(200, 250);
  TextEditingController sendMessageController = TextEditingController();
  Map<String, dynamic> _basicUserInfo;
  RPC _rpc;
  NestedAppInfo _prvChat;

  @override
  void initState() {
    super.initState();
    _rpc = RPC();
    getProfileInfo();

    _prvChat = AppBarProvider.instance.getNestedApps(AppType.Chat).firstWhere((element) => element.id == widget.username, orElse: () => null);
    print("get current private chat for ${widget.username}");
    _prvChat.addListener(_onPrivateMsg);
  }

  _onPrivateMsg() {
    print("_onPrivateMsg");
    List<dynamic> messages = _prvChat.getData();
    dynamic lastMessage = messages.last;
    print("lastMessage: ${lastMessage}");
    var chatInfo;
    if (lastMessage is Message)
      chatInfo = ChatInfo(msg: lastMessage.msg, colour: Color(lastMessage.colour), fontFace: lastMessage.fontFace, fontSize: lastMessage.fontSize, bold: lastMessage.bold, italic: lastMessage.italic);
    else
      chatInfo = lastMessage;
    _messagesListKey.currentState.addMessage(lastMessage.from, chatInfo);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sendMessageController.dispose();
    _prvChat.removeListener(_onPrivateMsg);
    super.dispose();
  }

  getProfileInfo() async {
    var data = new Map<String, String>();
    // data["sessionKey"] = UserProvider.instance.sessionKey;
    data["username"] = widget.username;
    print("getProfileInfo for ${data["username"]}");
    print(data);
    var res = await _rpc.callMethod("OldApps.User.getBasicInfo", widget.username);

    if (res["status"] == "ok") {
      print(res["data"]);
      setState(() {
        _basicUserInfo = res["data"];
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
                      height: MediaQuery.of(context).size.height - 165,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      )),
                      padding: EdgeInsets.all(3),
                      // color: Colors.black,
                      child: ChatMessagesList(key: _messagesListKey, chatMode: ChatMode.private),
                    ),
                    Spacer(),
                    ChatController(
                      onSend: (chatInfo) {
                        chatInfo.to = widget.username;
                        widget.onPrivateSend(chatInfo);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            Container(
                width: userContainerSize.width + 10,
                child: Column(
                  children: [
                    _basicUserInfo != null ? UserBasicInfo(basicUserInfo: _basicUserInfo, size: userContainerSize) : Container(),
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
