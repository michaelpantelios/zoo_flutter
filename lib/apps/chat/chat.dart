import 'dart:html';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';
import 'package:zoo_flutter/apps/chat/chat_user_dropdown_item.dart';
import 'package:zoo_flutter/apps/chat/chat_user_renderer.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/chat_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/utils/utils.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.options, this.onClose, this.setBusy}) : super(key: key);

  final dynamic options;
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatState();

  RenderBox _renderBox;

  final _messagesListKey = new GlobalKey<ChatMessagesListState>();
  int _sortUsersByValue = 0;
  List<UserInfo> _lastSyncedUsers = [];
  List<UserInfo> _onlineUsers = [];
  Map<String, dynamic> _opersData;
  List<String> _prvChatHistory = [];

  bool _pendingConnection = true;
  bool _pendingSync = true;
  bool _banned = false;
  bool _connectionClosed = false;

  TextEditingController _searchFieldController = TextEditingController();

  bool isMenuOpen = false;
  OverlayEntry _overlayMenu;

  String _selectedUsername;

  RPC _rpc;

  List<dynamic> _blockedUsers = [];
  List<DropdownMenuItem<int>> _sortChoices;

  ScrollController _usersScrollController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  refresh() {
    if (_connectionClosed) {
      print("refresh chat!");
      ChatManager.instance.connect();

      _loadBlocked();
    }
  }

  _init() {
    _usersScrollController = ScrollController();
    _rpc = RPC();

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
    ChatManager.instance.onNoAccess = _onNoAccess;
    ChatManager.instance.onConnectionClosed = _onConnectionClosed;
    ChatManager.instance.connect();

    _loadBlocked();
  }

  _loadBlocked() async {
    print("Loading blocked");
    var res = await _rpc.callMethod("Messenger.Client.getBlockedUsers");
    print(res);
    if (res["status"] == "ok") {
      _blockedUsers = res["data"];
    } else {
      _blockedUsers = [];
    }
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  _afterLayout(e) {
    _renderBox = context.findRenderObject();

    _sortChoices = [
      DropdownMenuItem(
        child: Text(AppLocalizations.of(context).translate("app_chat_dropdown_value_0"), style: Theme.of(context).textTheme.bodyText1),
        value: 0,
      ),
      DropdownMenuItem(
        child: Text(AppLocalizations.of(context).translate("app_chat_dropdown_value_1"), style: Theme.of(context).textTheme.bodyText1),
        value: 1,
      ),
    ];
  }

  _onNotice(String notice, String user, Map from) {
    String str = "";
    // print("_onNotice called - ${notice} - $user");

    if (notice == "NOTICE_BANNED") {
      if (from["webmaster"] != null) {
        str = Utils.instance.format(AppLocalizations.of(context).translateWithArgs("webmasterBan", [user]), ["<b>|</b>"]);
      } else {
        str = Utils.instance.format(AppLocalizations.of(context).translateWithArgs("opersBan", [user, from["username"].split().join(", ")]), ["<b>|</b>"]);
      }
      _showNoticeToChat(str);
    } else if (notice == "NOTICE_ENTERED" || notice == "NOTICE_LEFT") {
      _showNoticeToPrivateChats(AppLocalizations.of(context).translateWithArgs("app_privateChat_" + notice.toLowerCase(), [user]), user);
    }
  }

  _showNoticeToChat(String str) {
    var noticeChatInfo = ChatInfo(msg: str, colour: Color(0xff000000), fontFace: "Verdana", fontSize: 12, bold: false, italic: false);
    _messagesListKey.currentState.addMessage("", noticeChatInfo);
  }

  _showNoticeToPrivateChats(String str, String username) {
    var noticeChatInfo = ChatInfo(msg: str, colour: Color(0xff000000), fontFace: "Verdana", fontSize: 12, bold: false, italic: false);
    var privateChatWindows = context.read<AppBarProvider>().getNestedApps(AppType.Chat);

    for (var chatWindow in privateChatWindows) {
      if (chatWindow.id == username) Future.delayed(Duration(milliseconds: 300), () => chatWindow.addData(noticeChatInfo));
    }
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
    _lastSyncedUsers = usersLst;

    _refreshOpers();
    _refreshUsersList();
  }

  _refreshOpers() {
    if (_lastSyncedUsers == null) return;

    _lastSyncedUsers.forEach((user) {
      user.isOper = _opersData[user.code] == true;
      if (UserProvider.instance.userInfo != null && user.username == UserProvider.instance.userInfo.username) {
        setState(() {
          UserProvider.instance.userInfo.activated = user.activated;
          UserProvider.instance.userInfo.isOper = user.isOper;
          UserProvider.instance.userInfo.code = user.code;
          UserProvider.instance.userInfo.isChatMaster = user.isChatMaster;
          _pendingSync = false;
        });

        // print("i am oper? ${UserProvider.instance.userInfo.isOper}");
        // print("i am chatMaster? ${UserProvider.instance.userInfo.isChatMaster}");
      }
    });
  }

  _onSyncOperators(Map data) {
    _opersData = data;

    _refreshOpers();
  }

  _onBanned(int time) {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: Utils.instance.format(AppLocalizations.of(context).translateWithArgs("banned", [time.toString()]), ["<b>|</b>"]));
    ChatManager.instance.close();
  }

  _onConnectionClosed() {
    setState(() {
      _connectionClosed = true;
    });
    _messagesListKey.currentState.clearAll();
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("chat_connection_closed"),
        callbackAction: (r) {
          setState(() {
            _pendingConnection = true;
            _pendingSync = true;
          });
          AppProvider.instance.activate(AppType.Home, context);
        });
  }

  _onNoAccess() {
    ChatManager.instance.close();
    setState(() {
      _banned = true;
    });

    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("noAccess"),
        callbackAction: (r) {
          AppProvider.instance.activate(AppType.Home, context);
        });
  }

  _onPublicMessages(List<dynamic> messages) {
    for (Map message in messages) {
      var chatInfo = ChatInfo(msg: message['msg'], colour: Color(message['colour']), fontFace: message['fontFace'], fontSize: message['fontSize'], bold: message['bold'], italic: message['italic']);
      _messagesListKey.currentState.addMessage(message['from'], chatInfo);
    }
  }

  _onPrivateMessage(Map msg) {
    String from = msg["from"];
    print("private message from : $from");
    bool fromBlocked = false;
    for (int i = 0; i <= _blockedUsers.length - 1; i++) {
      if (_blockedUsers[i]["username"] == from) {
        fromBlocked = true;
        break;
      }
    }

    if (!fromBlocked) _refreshPrivateChat(from, msg: msg);
  }

  _onExitChat() {
    print("EXIT CHAT!");
    ChatManager.instance.close();
  }

  _refreshUsersList() {
    String searchTerm = _searchFieldController.text;
    List<UserInfo> matchingUsers = [];

    if (searchTerm.trim().isEmpty) {
      matchingUsers = _lastSyncedUsers;
    } else {
      matchingUsers = _lastSyncedUsers.where((user) => user.username.toLowerCase().indexOf(searchTerm.toLowerCase()) == 0).toList();
    }

    if (_sortUsersByValue == 0) {
      matchingUsers.sort((a, b) => a.username.compareTo(b.username) < 0 ? 1 : -1);
    } else if (_sortUsersByValue == 1) {
      matchingUsers.sort((a, b) {
        return a.points < b.points ? -1 : 1;
      });
    }

    setState(() {
      _onlineUsers = matchingUsers;
    });
  }

  void closeMenu() {
    if (!isMenuOpen) return;
    _overlayMenu.remove();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu(Offset rendererPosition, Size rendererSize) {
    _overlayMenu = _overlayMenuBuilder(rendererPosition, rendererSize);
    Overlay.of(context).insert(_overlayMenu);
    isMenuOpen = !isMenuOpen;
  }

  _onUserMenu(Offset rendererPosition, Size rendererSize) {
    if (isMenuOpen)
      closeMenu();
    else
      openMenu(rendererPosition, rendererSize);
  }

  OverlayEntry _overlayMenuBuilder(Offset rendererPosition, Size rendererSize) {
    UserInfo user = _onlineUsers.firstWhere((element) => element.username == _selectedUsername, orElse: () => null);
    return OverlayEntry(builder: (context) {
      return PointerInterceptor(
        child: Positioned(
            top: rendererPosition.dy + rendererSize.height,
            left: rendererPosition.dx + 10,
            width: 200,
            child: Material(
                child: MouseRegion(
              onExit: (e) => closeMenu(),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey[800],
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_0"), iconData: Icons.chat_bubble, onTapHandler: () => _onMenuChoiceClicked("chat", user)),
                      user.mainPhoto == null ? Container() : ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_1"), iconData: Icons.photo, onTapHandler: () => _onMenuChoiceClicked("photo", user)),
                      ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_2"), iconData: Icons.casino, onTapHandler: () => _onMenuChoiceClicked("game", user)),
                      ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_3"), iconData: Icons.card_giftcard, onTapHandler: () => _onMenuChoiceClicked("gift", user)),
                      ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_4"), iconData: Icons.outgoing_mail, onTapHandler: () => _onMenuChoiceClicked("mail", user)),
                      ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_5"), iconData: Icons.account_box, onTapHandler: () => _onMenuChoiceClicked("profile", user)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 3), child: Divider(color: Colors.grey[300], height: 2, thickness: 2)),
                      ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_6"), iconData: Icons.not_interested, onTapHandler: () => _onMenuChoiceClicked("ignore", user))
                    ],
                  )),
            ))),
      );
    });
  }

  _onMenuChoiceClicked(String choice, UserInfo user) {
    closeMenu();
    if (user == null) return;
    print("_onUserRendererChoice :" + choice);
    switch (choice) {
      case "chat":
        _refreshPrivateChat(user.username);
        break;
      case "photo":
        _openPhoto(int.parse(user.mainPhoto["image_id"].toString()));
        break;
      case "game":
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("under_construction"));
        break;
      case "gift":
        PopupManager.instance.show(context: context, popup: PopupType.Gifts, headerOptions: user.username, options: user.username, callbackAction: (retValue) {});
        break;
      case "mail":
        PopupManager.instance.show(context: context, popup: PopupType.MailNew, options: user.username, callbackAction: (retValue) {});
        break;
      case "profile":
        PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(user.userId.toString()), callbackAction: (res) {});
        break;
      case "ignore":
        _ignoreUser(user.username);
        break;
    }
  }

  _getUserIdFromUsername(String username) {
    var user = _onlineUsers.firstWhere((element) => element.username == username, orElse: () => null);
    if (user != null) return user.userId;

    return null;
  }

  _ignoreUser(String username) async {
    AlertManager.instance.showSimpleAlert(
      context: context,
      bodyText: AppLocalizations.of(context).translateWithArgs("mail_userIgnore", [username]),
      callbackAction: (retVal) async {
        if (retVal == 1) {
          String userId = _getUserIdFromUsername(username);
          if (userId == null) return;
          var res = await _rpc.callMethod("Messenger.Client.addBlocked", [userId]);
          print(res);

          if (res["status"] == "ok") {
            AlertManager.instance.showSimpleAlert(
              context: context,
              bodyText: Utils.instance.format(AppLocalizations.of(context).translateWithArgs("ignored", [username]), ["<b>|</b>"]),
            );
            _loadBlocked();
          } else {
            AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("mail_" + res["errorMsg"]));
          }
        }
      },
      dialogButtonChoice: AlertChoices.OK_CANCEL,
    );
  }

  _openPhoto(int imageID) {
    print("imageID: $imageID");
    PopupManager.instance.show(context: context, popup: PopupType.PhotoViewer, options: imageID, callbackAction: (res) {});
  }

  _refreshPrivateChat(String username, {Map msg}) {
    print("_openPrivateChat with: $username");
    var privateChatWindow = context.read<AppBarProvider>().getNestedApps(AppType.Chat).firstWhere((element) => element.id == username, orElse: () => null);

    bool firstTimeAdded = false;
    if (privateChatWindow == null) {
      privateChatWindow = NestedAppInfo(id: username, title: "${username}");
      firstTimeAdded = true;
    }

    if (msg != null) {
      Future.delayed(Duration(milliseconds: 300), () {
        context.read<AppBarProvider>().notifyApp(AppType.Chat, privateChatWindow);
        privateChatWindow.addData(msg);
      });
    } else {
      privateChatWindow.active = true;
    }

    if (firstTimeAdded) {
      context.read<AppBarProvider>().addNestedApp(AppType.Chat, privateChatWindow);
      setState(() {
        _prvChatHistory.add(username);
      });
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
        ? SizedBox(
            height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
              width: _renderBox.size.width,
              height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _connectionClosed
                      ? Text(
                          AppLocalizations.of(context).translate("chat_connection_closed"),
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      : _banned
                          ? Text(
                              AppLocalizations.of(context).translate("chat_already_banned"),
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                backgroundColor: Colors.white,
                              ),
                            ),
                  _pendingConnection
                      ? Text(
                          AppLocalizations.of(context).translate("chat_connecting"),
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      : _pendingSync && !_banned
                          ? Text(
                              AppLocalizations.of(context).translate("chat_synchronizing"),
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            )
                          : Container(),
                ],
              ),
            ))
        : Container();
  }

  _onUserMessageClicked(String username) {
    setState(() {
      _searchFieldController.clear();
      closeMenu();
      _refreshUsersList();
      UserInfo user = _onlineUsers.firstWhere((element) => element.username == username, orElse: () => null);
      if (user == null) {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_chat_user_not_exists"), callbackAction: (res) {});
      } else {
        _selectedUsername = username;
        var index = _onlineUsers.indexOf(user);
        _usersScrollController.jumpTo(index * 30.0);
      }
    });
  }

  _requestBan() {
    if (_selectedUsername != null) {
      if (!UserProvider.instance.userInfo.isOper && !UserProvider.instance.userInfo.isChatMaster) {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("noOper"), callbackAction: (res) {});
        return;
      }
      //if this user has left the chat do an offline ban
      bool notFilteredBySearch = _searchFieldController.text.trim().isEmpty;
      UserInfo user = _onlineUsers.firstWhere((element) => element.username == _selectedUsername, orElse: () => null);
      if (notFilteredBySearch && user == null) {
        print("ban user: $_selectedUsername that has left the room.");
        if (UserProvider.instance.userInfo.isOper || UserProvider.instance.userInfo.isChatMaster) {
          AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: Utils.instance.format(AppLocalizations.of(context).translateWithArgs("offlineBan", [_selectedUsername]), ["<b>|</b>"]),
            callbackAction: (res) {
              if (res == 1) {
                ChatManager.instance.banUser(_selectedUsername, 20, null);
                AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("banInited"));
              }
            },
            dialogButtonChoice: AlertChoices.OK_CANCEL,
          );
        }
      } else {
        print("user is online, ban him!");
        if (UserProvider.instance.userInfo.isChatMaster) {
          PopupManager.instance.show(
              context: context,
              popup: PopupType.ChatMasterBan,
              options: _selectedUsername,
              callbackAction: (res) {
                print("res: $res");
                if (res != null) {
                  ChatManager.instance.banUser(_selectedUsername, int.parse(res["time"].toString()), res["type"]);
                }
              });
        } else {
          AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: Utils.instance.format(AppLocalizations.of(context).translateWithArgs("sureBan", [_selectedUsername]), ["<b>|</b>"]),
            callbackAction: (res) {
              if (res == 1) {
                ChatManager.instance.banUser(_selectedUsername, 20, null);

                AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("banInited"));
              }
            },
            dialogButtonChoice: AlertChoices.OK_CANCEL,
          );
        }
      }
    } else {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("noSelection"), callbackAction: (res) {});
    }
  }

  getSearchInputDecoration() {
    return InputDecoration(
      prefixIcon: Icon(
        FontAwesomeIcons.search,
        size: 20,
      ),
      fillColor: Color(0xffffffff),
      filled: false,
      enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    double theHeight = MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding;
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
    return SizedBox(
        height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: Stack(
          children: [
            IndexedStack(
              index: selectedIndex,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: theHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: theHeight - 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xff9598a4),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(3),
                                  // color: Colors.black,
                                  child: ChatMessagesList(
                                    key: _messagesListKey,
                                    onUserMessageClicked: (username) => _onUserMessageClicked(username),
                                    chatMode: ChatMode.public,
                                  )),
                              ChatController(
                                onSend: (chatInfo) => _sendMyMessage(chatInfo),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: 250,
                          height: theHeight,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _onExitChat(),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    AppLocalizations.of(context).translate("app_chat_exit"),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(
                                        0xffdc5b42,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: TextField(
                                  controller: _searchFieldController,
                                  onChanged: (e) {
                                    closeMenu();
                                    _selectedUsername = null;
                                    _refreshUsersList();
                                  },
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  decoration: getSearchInputDecoration(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                    height: 35,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 260,
                                          height: 30,
                                          // padding: EdgeInsets.all(5),
                                          // margin: EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black26, width: 1), borderRadius: BorderRadius.circular(9), boxShadow: [
                                            new BoxShadow(
                                              color: Color(0x33000000),
                                              offset: new Offset(0.0, 0.0),
                                              blurRadius: 0.6,
                                              spreadRadius: 0.6,
                                            ),
                                          ]),
                                          alignment: Alignment.center,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                              iconSize: 22,
                                              isDense: true,
                                              value: _sortUsersByValue,
                                              items: _sortChoices,
                                              onChanged: (value) {
                                                setState(() {
                                                  _sortUsersByValue = value;
                                                });
                                                closeMenu();
                                                _selectedUsername = null;
                                                _refreshUsersList();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                height: MediaQuery.of(context).size.height - 277,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: DraggableScrollbar(
                                        alwaysVisibleScrollThumb: true,
                                        heightScrollThumb: 100.0,
                                        backgroundColor: Theme.of(context).backgroundColor,
                                        scrollThumbBuilder: (
                                          Color backgroundColor,
                                          Animation<double> thumbAnimation,
                                          Animation<double> labelAnimation,
                                          double height, {
                                          Text labelText,
                                          BoxConstraints labelConstraints,
                                        }) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff616161),
                                              borderRadius: BorderRadius.circular(3.5),
                                            ),
                                            height: 100,
                                            width: 7.0,
                                          );
                                        },
                                        controller: _usersScrollController,
                                        child: ListView.builder(
                                            controller: _usersScrollController,
                                            shrinkWrap: true,
                                            itemCount: _onlineUsers.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              UserInfo user = _onlineUsers[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 3, top: 5, right: 3),
                                                child: ChatUserRenderer(
                                                    userInfo: user,
                                                    selected: _selectedUsername == user.username,
                                                    onMenu: (rendererPosition, rendererSize) => _onUserMenu(rendererPosition, rendererSize),
                                                    onSelected: (username) {
                                                      setState(() {
                                                        closeMenu();
                                                        _selectedUsername = username;
                                                      });
                                                    }),
                                              );
                                            }),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Color(0xfff8f8f9),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          UserProvider.instance.userInfo.isOper
                                              ? AppLocalizations.of(context).translate("app_chat_you_are_operator")
                                              : AppLocalizations.of(context).translate(
                                                  "app_chat_you_are_not_operator",
                                                ),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                0xffdc5b42,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    _requestBan();
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
                                            padding: const EdgeInsets.only(left: 40),
                                            child: Text(
                                              AppLocalizations.of(context).translate("ban"),
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
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ]..addAll(
                  _prvChatHistory.map(
                    (username) => PrivateChat(
                      key: Key(username),
                      username: username,
                      onIgnore: (username) => _ignoreUser(username),
                      onPrivateSend: (chatInfo) => _sendMyMessage(chatInfo),
                    ),
                  ),
                ),
            ),
            (_pendingConnection || _pendingSync) ? _loadingView() : Container()
          ],
        ));
  }
}
