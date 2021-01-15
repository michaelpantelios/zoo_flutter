import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/user_basic_info.dart';

import '../../main.dart';

class PrivateChat extends StatefulWidget {
  final String username;
  final Function(ChatInfo chatInfo) onPrivateSend;
  final Function(String username) onIgnore;
  PrivateChat({Key key, @required this.username, @required this.onPrivateSend, @required this.onIgnore}) : super(key: key);

  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  PrivateChatState();

  final GlobalKey<ChatMessagesListState> _messagesListKey = new GlobalKey<ChatMessagesListState>();
  Size userContainerSize = new Size(250, 300);
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
    print("lastMessage: $lastMessage");
    ChatInfo chatInfo;
    if (lastMessage is ChatInfo)
      chatInfo = lastMessage;
    else
      chatInfo = ChatInfo(from: lastMessage['from'], msg: lastMessage['msg'], colour: Color(lastMessage['colour']), fontFace: lastMessage['fontFace'], fontSize: lastMessage['fontSize'], bold: lastMessage['bold'], italic: lastMessage['italic']);

    _messagesListKey.currentState.addMessage(chatInfo.from ?? "", chatInfo);
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
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Root.AppSize.height - 190,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xff9598a4),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  // color: Colors.black,
                  child: ChatMessagesList(key: _messagesListKey, chatMode: ChatMode.private),
                ),
                SizedBox(
                  height: 5,
                ),
                ChatController(
                  onSend: (chatInfo) {
                    chatInfo.to = widget.username;
                    widget.onPrivateSend(chatInfo);
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _basicUserInfo != null ? UserBasicInfo(basicUserInfo: _basicUserInfo, size: userContainerSize) : Container(),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  widget.onIgnore(widget.username);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffdc5b42),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context).translate("app_privateChat_btnIgnore"),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "assets/images/general/ban_icon.png",
                              color: Color(0xffffffff),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
