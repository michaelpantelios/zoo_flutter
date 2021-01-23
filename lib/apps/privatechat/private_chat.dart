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
  final Function(String username) onStateReady;
  PrivateChat({Key key, @required this.username, @required this.onPrivateSend, @required this.onIgnore, this.onStateReady}) : super(key: key);

  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  PrivateChatState();

  final GlobalKey<ChatMessagesListState> _prvMessagesListKey = new GlobalKey<ChatMessagesListState>();
  final GlobalKey<ChatControllerState> _chatControllerKey = new GlobalKey<ChatControllerState>();
  Size userContainerSize = new Size(250, 300);
  Map<String, dynamic> _basicUserInfo;
  RPC _rpc;

  @override
  void initState() {
    super.initState();
    _rpc = RPC();
    getProfileInfo();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    AppBarProvider.instance.addListener(_onAppBarProviderEvent);
  }

  @override
  void dispose() {
    super.dispose();
    AppBarProvider.instance.removeListener(_onAppBarProviderEvent);
  }

  _onAppBarProviderEvent() {
    List<NestedAppInfo> nestedApps = AppBarProvider.instance.getNestedApps(AppType.Chat);
    if (nestedApps.firstWhere((element) => element.id == widget.username && element.active, orElse: () => null) != null) {
      _chatControllerKey.currentState.focus();
    }
  }

  _afterLayout(e) {
    widget.onStateReady(widget.username);
  }

  onPrivateMsg(dynamic message) {
    print("_onPrivateMsg");
    print("message: $message");
    ChatInfo chatInfo;
    if (message is ChatInfo)
      chatInfo = message;
    else
      chatInfo = ChatInfo(from: message['from'], msg: message['msg'], colour: Color(message['colour']), fontFace: message['fontFace'], fontSize: message['fontSize'], bold: message['bold'], italic: message['italic']);

    _prvMessagesListKey.currentState.addMessage(chatInfo.from ?? "", chatInfo);
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
                  height: Root.AppSize.height - 222,
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
                  child: ChatMessagesList(key: _prvMessagesListKey, chatMode: ChatMode.private),
                ),
                SizedBox(
                  height: 5,
                ),
                ChatController(
                  key: _chatControllerKey,
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
