import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames.dart';
import 'package:zoo_flutter/apps/chat/chat.dart';
import 'package:zoo_flutter/apps/forum/forum.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';
import 'package:zoo_flutter/apps/search/search.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_games.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

enum AppType {
  Home,
  Multigames,
  BrowserGames,
  SinglePlayerGames,
  Chat,
  Forum,
  Search,
  Messenger,
  PrivateChat,
}

class AppInfo {
  final AppType id;
  final String appName;
  final IconData iconPath;
  final bool hasPanelShortcut;
  final bool requiresLogin;

  AppInfo({
    @required this.id,
    @required this.appName,
    @required this.iconPath,
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

  AppProvider() {
    instance = this;
    _currentAppInfo = getAppInfo(AppType.Home);
  }

  activate(AppType app, BuildContext context) {
    if (_currentAppInfo.id == app) {
      print("Already in app: $app");
      return;
    }

    var appInfo = getAppInfo(app);

    print("activate: $app");

    print("_currentAppInfo.requiresLogin: ${appInfo.requiresLogin},  UserProvider.instance.logged: ${UserProvider.instance.logged}");
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

    notifyListeners();
  }

  AppInfo getAppInfo(AppType popup) {
    AppInfo info;
    switch (popup) {
      case AppType.Home:
        info = AppInfo(id: popup, appName: "app_name_home", iconPath: Icons.home_filled, hasPanelShortcut: true);
        break;
      case AppType.Chat:
        info = AppInfo(id: popup, appName: "app_name_chat", iconPath: Icons.chat_bubble, hasPanelShortcut: true, requiresLogin: true);
        break;
      case AppType.Forum:
        info = AppInfo(id: popup, appName: "app_name_forum", iconPath: Icons.notes, hasPanelShortcut: true);
        break;
      case AppType.Multigames:
        info = AppInfo(id: popup, appName: "app_name_multigames", iconPath: Icons.casino, hasPanelShortcut: true);
        break;
      case AppType.Search:
        info = AppInfo(id: popup, appName: "app_name_search", iconPath: Icons.search, hasPanelShortcut: true);
        break;
      case AppType.Messenger:
        info = AppInfo(id: popup, appName: "app_name_messenger", iconPath: Icons.comment, hasPanelShortcut: false, requiresLogin: true);
        break;
      case AppType.PrivateChat:
        info = AppInfo(id: popup, appName: "app_name_privateChat", iconPath: Icons.chat_bubble, hasPanelShortcut: false, requiresLogin: true);
        break;
      case AppType.BrowserGames:
        info = AppInfo(id: popup, appName: "app_name_browsergames", iconPath: FontAwesomeIcons.rocket, hasPanelShortcut: true);
        break;
      case AppType.SinglePlayerGames:
        info = AppInfo(id: popup, appName: "app_name_singleplayergames", iconPath: FontAwesomeIcons.pastafarianism, hasPanelShortcut: true);
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
        widget = Chat();
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
      case AppType.Messenger:
        widget = MessengerChat();
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
