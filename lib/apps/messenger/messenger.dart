import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat_list.dart';
import 'package:zoo_flutter/apps/messenger/messenger_user_renderer.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/js/zoo_lib.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/friends/friend_info.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/utils/utils.dart';

import '../../main.dart';

class Messenger extends StatefulWidget {
  Messenger({Key key, this.options, this.onClose, this.setBusy}) : super(key: key);

  final dynamic options;
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  MessengerState createState() => MessengerState();
}

class MessengerState extends State<Messenger> {
  MessengerState();

  FocusNode _searchUsernameFocusNode = FocusNode();
  TextEditingController _searchUsernameController = TextEditingController();
  ScrollController _friendsScrollController;
  ScrollPosition _currentScrollPos;
  UserInfo _selectedUser;
  int _friendsRequests = 0;
  final _messengerChatListKey = new GlobalKey<MessengerChatListState>();

  RPC _rpc;
  List<FriendInfo> _friends = [];
  Map<String, int> _unreadMessages = Map();
  double _scrollThreshold = 50;
  int _currentPage = 1;
  int _recsPerPage = 500;
  int _totalFriends = -1;
  double _friendsListHeight = 0;
  double _friendsListWidth = 0;

  @override
  void initState() {
    super.initState();
    _friendsListHeight = Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - 80;
    _friendsListWidth = 240;
    _friendsScrollController = ScrollController();
    _rpc = RPC();

    _recsPerPage = 2 * (_friendsListHeight / 27).floor();
    print('_recsPerPage: ${_recsPerPage}');

    var s = () async {
      await _fetchData();
      await _fetchFriendsRequests();

      if (_friends.length > 0) {
        setState(() {
          _selectedUser = _friends[0].user;
          _onFriendSelected(0, _selectedUser.username);
        });
      }
    };

    s();

    NotificationsProvider.instance.addListener(_onNotification);
  }

  _onNotification() {
    var messengerNotification = NotificationsProvider.instance.notifications.firstWhere((element) => element.type == NotificationType.ON_MESSENGER_CHAT_MESSAGE, orElse: () => null);
    if (messengerNotification != null) {
      NotificationsProvider.instance.removeNotification(messengerNotification);
      _onMsg(messengerNotification.args["message"]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _friendsScrollController.dispose();
    NotificationsProvider.instance.removeListener(_onNotification);
  }

  _onFriendSelected(int index, String username) {
    if (_friends[index].online == "1") {
      setState(() {
        _selectedUser = _friends.firstWhere((element) => element.user.username == username).user;
        if (_unreadMessages.containsKey(username)) {
          _unreadMessages[username] = 0;
        }
      });
      _loadMessengerHistory();
    } else {
      PopupManager.instance.show(context: context, popup: PopupType.MailNew, options: username, callbackAction: (r) {});
    }
  }

  _fetchFriendsRequests() async {
    var res = await _rpc.callMethod("Messenger.Client.getFriendshipRequests", []);
    List<UserInfo> lst = [];
    if (res["status"] == "ok") {
      for (var i = 0; i < res["data"]["records"].length; i++) {
        var item = res["data"]["records"][i];
        lst.add(UserInfo.fromJSON(item));
      }
    }

    setState(() {
      _friendsRequests = lst.length;
    });
  }

  _scrollListener() async {
    if (_friendsScrollController.position.pixels > (_friendsScrollController.position.maxScrollExtent - _scrollThreshold) && _friends.length < _totalFriends) {
      _friendsScrollController.removeListener(_scrollListener);

      _currentPage++;
      _currentScrollPos = _friendsScrollController.position;
      if (_searchUsernameController.text != null && _searchUsernameController.text.isNotEmpty)
        await _fetchData(username: _searchUsernameController.text);
      else
        await _fetchData();
    }
  }

  _fetchData({String username}) async {
    if (_currentScrollPos != null) _friendsScrollController.detach(_currentScrollPos);

    var res;
    Map<String, dynamic> filter = {
      "online": 1,
      "facebook": null,
    };
    print('username: $username');
    if (username != null) {
      filter["username"] = username;
    }

    res = await _rpc.callMethod("Messenger.Client.getFriends", [
      filter,
      {"page": _currentPage, "recsPerPage": _recsPerPage, "getCount": 1}
    ]);

    List<FriendInfo> lst = _friends.toList();
    Map<String, int> unreadMessages = _unreadMessages;
    if (res["status"] == "ok") {
      _totalFriends = res["data"]["count"];
      for (var i = 0; i < res["data"]["records"].length; i++) {
        var item = res["data"]["records"][i];
        var friend = FriendInfo.fromJSON(item);
        lst.add(friend);

        if (!unreadMessages.containsKey(friend.user.username)) unreadMessages[friend.user.username] = 0;
      }
    }

    lst.sort((a, b) => int.parse(a.online.toString()) < int.parse(b.online.toString()) ? 1 : -1);
    setState(() {
      _friends = lst;
      _unreadMessages = unreadMessages;
    });
    if (!_friendsScrollController.hasListeners) _friendsScrollController.addListener(_scrollListener);

    if (_currentScrollPos != null) _friendsScrollController.attach(_currentScrollPos);
    _friendsScrollController.jumpTo(_friendsScrollController.position.minScrollExtent);
  }

  _searchByUsername() {
    print("search by username: ${_searchUsernameController.text}");
    _friends.clear();
    _currentPage = 1;
    _fetchData(username: _searchUsernameController.text);
    _searchUsernameFocusNode.requestFocus();
  }

  getFieldsInputDecoration() {
    return InputDecoration(
      prefixIcon: Image.asset("assets/images/chat/search_icon.png"),
      fillColor: Color(0xffffffff),
      filled: false,
      enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  static getImgFriends() {
    if (window.location.href.contains("localhost")) return "assets/images/messenger/friends_icon.png";
    return Zoo.relativeToAbsolute("assets/assets/images/messenger/friends_icon.png");
  }

  _onFriendsPopup() {
    PopupManager.instance.show(context: context, popup: PopupType.Friends, callbackAction: (r) {});
  }

  _loadMessengerHistory() {
    print('load messenger history for: ${_selectedUser.username}');
    List<MessengerMsg> messages = UserProvider.instance.loadMessengerHistory(_selectedUser.username);
    if (messages == null) messages = [];
    _messengerChatListKey.currentState.clearAll();
    _messengerChatListKey.currentState.addMessages(messages);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: _friendsListWidth,
                child: TextField(
                  focusNode: _searchUsernameFocusNode,
                  controller: _searchUsernameController,
                  onSubmitted: (txt) => _searchByUsername(),
                  decoration: getFieldsInputDecoration(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).translate("lblOnlineFriends"),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff393e54),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: _friendsListHeight,
                      width: _friendsListWidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff9598a4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      padding: EdgeInsets.all(3),
                      // color: Colors.black,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        controller: _friendsScrollController,
                        child: ListView.builder(
                            controller: _friendsScrollController,
                            shrinkWrap: true,
                            itemCount: _friends.length,
                            itemBuilder: (BuildContext context, int index) {
                              UserInfo user = _friends[index].user;
                              int newMessagesForUser = _unreadMessages[user.username];
                              return MessengerUserRenderer(
                                width: 130,
                                userInfo: user,
                                online: _friends[index].online == "1",
                                unread: newMessagesForUser,
                                selected: _selectedUser?.username == user.username,
                                onSelected: (username) {
                                  _onFriendSelected(index, username);
                                },
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        _onFriendsPopup();
                      },
                      child: Container(
                        width: 220,
                        height: 40,
                        child: Html(
                          data: _friendsRequests > 0
                              ? AppLocalizations.of(context).translateWithArgs("messenger_friends_requests", ["<span>" + _friendsRequests.toString() + "</span>"]) + "<img src='${getImgFriends()}'></img>"
                              : AppLocalizations.of(context).translate("messenger_friends_manage") + "<img src='${getImgFriends()}'></img>",
                          style: {
                            "html": Style(color: Colors.black, fontWeight: FontWeight.w500, fontSize: FontSize.medium, textAlign: TextAlign.center),
                            "span": Style(color: Color(0xff3c8d40)),
                            "img": Style(width: 25, height: 25, padding: EdgeInsets.only(left: 5)),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                _chatHeader(),
                _chatMain(),
                _chatFooter()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _chatHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xfff8f8f9),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          boxShadow: [
            new BoxShadow(color: Color(0xffaeaeae), offset: new Offset(0.0, 2.0), blurRadius: 3, spreadRadius: 1),
          ],
        ),
        child: _selectedUser != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            PopupManager.instance.show(context: context, popup: PopupType.Profile, options: _selectedUser.userId, callbackAction: (r) {});
                          },
                          child: ClipOval(
                            child: _selectedUser.mainPhoto != null
                                ? Image.network(Utils.instance.getUserPhotoUrl(photoId: _selectedUser.mainPhoto["image_id"].toString()), height: 60, width: 60, fit: BoxFit.cover)
                                : Image.asset(_selectedUser.sex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 60, width: 60, fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            _selectedUser.username,
                            style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff393e54), fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      PopupManager.instance.show(context: context, popup: PopupType.Gifts, headerOptions: _selectedUser.username, options: _selectedUser.username, callbackAction: (r) {});
                    },
                    child: Image.asset(
                      "assets/images/messenger/gift_icon.png",
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _chatMain() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Container(
          child: MessengerChatList(
            key: _messengerChatListKey,
          ),
        ),
      ),
    );
  }

  _sendMyMessage(ChatInfo chatInfo) async {
    print("sendMyMessage: $chatInfo");

    MessengerMsg msg = MessengerMsg(
      from: {
        "username": UserProvider.instance.userInfo.username,
        "mainPhoto": UserProvider.instance.userInfo.mainPhoto,
        "sex": UserProvider.instance.userInfo.sex,
      },
      text: chatInfo.msg,
      colour: chatInfo.colour.value,
      fontFace: chatInfo.fontFace,
      fontSize: chatInfo.fontSize,
      bold: chatInfo.bold,
      italic: chatInfo.italic,
    );

    var res = await _rpc.callMethod("Messenger.Client.sendMessage", [_selectedUser.userId, msg.toJson(), false]);
    print(res);
    if (res["status"] == "ok") {
      _doSendMsg(msg);
    } else {
      if (res["errorMsg"] == "user_blocked")
        AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: Utils.instance.format(
            AppLocalizations.of(context).translateWithArgs("messenger_user_blocked", [_selectedUser.username]),
            ["<b>|</b>"],
          ),
        );
      else if (res["errorMsg"] == "invalid_user")
        AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: Utils.instance.format(
            AppLocalizations.of(context).translateWithArgs("messenger_invalid_user", [_selectedUser.username]),
            ["<b>|</b>"],
          ),
        );
      else if (res["errorMsg"] == "no_coins")
        PopupManager.instance.show(context: context, popup: PopupType.Coins, callbackAction: (r) {});
      else if (res["errorMsg"] == "user_not_online")
        AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: Utils.instance.format(
            AppLocalizations.of(context).translateWithArgs("messenger_user_not_online", [_selectedUser.username]),
            ["<b>|</b>"],
          ),
        );
      else if (res["errorMsg"] == "user_not_online")
        AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: Utils.instance.format(
            AppLocalizations.of(context).translateWithArgs("messenger_user_not_online", [_selectedUser.username]),
            ["<b>|</b>"],
          ),
        );
      else if (res["errorMsg"] == "coins_required")
        PopupManager.instance.show(context: context, options: CostTypes.live_chat, popup: PopupType.Protector, callbackAction: (retVal) => {if (retVal == "ok") _doSendMsg(msg)});
      else
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("messenger_error"));
    }
  }

  _doSendMsg(msg) {
    _messengerChatListKey.currentState.addMessage(msg);
    _storeHistory();
  }

  _onMsg(dynamic message) {
    print("Messenger - _onMsg: $message");

    MessengerMsg msg = MessengerMsg.fromJSON(message);

    if (_selectedUser != null && (_selectedUser.username == msg.from["username"])) {
      _messengerChatListKey.currentState.addMessage(msg);
    } else {
      setState(() {
        if (_unreadMessages.containsKey(msg.from["username"])) {
          _unreadMessages[msg.from["username"]]++;
        }
      });
    }
  }

  _storeHistory() {
    List<MessengerMsg> history = _messengerChatListKey.currentState.getHistory();
    UserProvider.instance.saveMessengerHistory(history, _selectedUser.username);
  }

  Widget _chatFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 16),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xfff8f8f9),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
          boxShadow: [
            new BoxShadow(color: Color(0xffaeaeae), offset: new Offset(0.0, -2.0), blurRadius: 3, spreadRadius: 1),
          ],
        ),
        child: _selectedUser != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ChatController(
                  onSend: (chatInfo) => _sendMyMessage(chatInfo),
                ),
              )
            : Container(),
      ),
    );
  }
}
