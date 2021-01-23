import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames.dart';
import 'package:zoo_flutter/apps/chat/chat.dart';
import 'package:zoo_flutter/apps/forum/forum.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';
import 'package:zoo_flutter/apps/search/search.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_games.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

enum AppType { Home, Multigames, BrowserGames, SinglePlayerGames, Chat, Forum, Search, PrivateChat }

class AppInfo {
  final AppType id;
  final String appName;
  final bool hasPanelShortcut;
  final bool requiresLogin;
  final String iconImagePath;

  dynamic _options;
  set options(value) {
    _options = value;
  }

  get options => _options;

  AppInfo({
    @required this.id,
    @required this.appName,
    @required this.iconImagePath,
    this.hasPanelShortcut = false,
    this.requiresLogin = false,
  });

  @override
  String toString() {
    return "id: $id, appName: $appName";
  }
}

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  AppInfo _currentAppInfo;
  AppInfo get currentAppInfo => _currentAppInfo;

  static AppProvider instance;

  GlobalKey<ChatState> _chatGlobalKey = GlobalKey<ChatState>();

  AppProvider() {
    instance = this;
    _currentAppInfo = getAppInfo(AppType.Home);
  }

  GlobalKey<ChatState> get chatGlobalKey => _chatGlobalKey;

  activate(AppType app, BuildContext context, [dynamic options]) {
    if (_currentAppInfo.id == app) {
      print("Already in app: $app");
      return;
    }

    var appInfo = getAppInfo(app);

    print("activate: $app");

    // print("_currentAppInfo.requiresLogin: ${appInfo.requiresLogin},  UserProvider.instance.logged: ${UserProvider.instance.logged}");
    if (appInfo.requiresLogin && !UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            print("cb:: $res");
            if (res) {
              _currentAppInfo = appInfo;
              notifyListeners();
            }
          });
    } else {
      _currentAppInfo = appInfo;
    }

    _currentAppInfo.options = options;

    notifyListeners();
  }

  AppInfo getAppInfo(AppType popup) {
    var prefix = "assets/images/full_app_icons";
    AppInfo info;
    switch (popup) {
      case AppType.Home:
        info = AppInfo(id: popup, appName: "app_name_home", iconImagePath: "$prefix/home_app_icon.png", hasPanelShortcut: true);
        break;
      case AppType.Chat:
        info = AppInfo(id: popup, appName: "app_name_chat", iconImagePath: "$prefix/chat_app_icon.png", hasPanelShortcut: true, requiresLogin: true);
        break;
      case AppType.Forum:
        info = AppInfo(id: popup, appName: "app_name_forum", iconImagePath: "$prefix/forum_app_icon.png", hasPanelShortcut: true);
        break;
      case AppType.Multigames:
        info = AppInfo(id: popup, appName: "app_name_multigames", iconImagePath: "$prefix/multiplayer_app_icon.png", hasPanelShortcut: true);
        break;
      case AppType.Search:
        info = AppInfo(id: popup, appName: "app_name_search", iconImagePath: "$prefix/search_app_icon.png", hasPanelShortcut: true);
        break;
      case AppType.PrivateChat:
        info = AppInfo(id: popup, appName: "app_name_privateChat", iconImagePath: "$prefix/chat_app_icon.png", hasPanelShortcut: false, requiresLogin: true);
        break;
      case AppType.BrowserGames:
        info = AppInfo(id: popup, appName: "app_name_browsergames", iconImagePath: "$prefix/browser_app_icon.png", hasPanelShortcut: true);
        break;
      case AppType.SinglePlayerGames:
        info = AppInfo(id: popup, appName: "app_name_singleplayergames", iconImagePath: "$prefix/singleplayer_app_icon.png", hasPanelShortcut: true);
        break;
      default:
        throw new Exception("Unknown popup: $popup");
        break;
    }

    return info;
  }

  Widget getAppWidget(AppType popup, [BuildContext context]) {
    Widget widget;
    switch (popup) {
      case AppType.Home:
        widget = Home();
        break;
      case AppType.Chat:
        widget = Chat(key: _chatGlobalKey);
        break;
      case AppType.Forum:
        widget = Forum();
        break;
      case AppType.Multigames:
        widget = Multigames();
        break;
      case AppType.Search:
        widget = Search();
        break;
      case AppType.PrivateChat:
        widget = PrivateChat();
        break;
      case AppType.BrowserGames:
        widget = BrowserGames();
        break;
      case AppType.SinglePlayerGames:
        widget = SinglePlayerGames();
        break;
      default:
        throw new Exception("Unknown app: $popup");
        break;
    }

    return widget;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppInfo>('currentAppInfo', _currentAppInfo));
  }
}
