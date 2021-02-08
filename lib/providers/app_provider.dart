import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

enum AppType {
  Home,
  Multigames,
  BrowserGames,
  SinglePlayerGames,
  Chat,
  Forum,
  Messenger,
  Search,
  PrivateChat,
}

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

  AppProvider() {
    instance = this;
    _currentAppInfo = getAppInfo(AppType.Home);
  }

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
      case AppType.Messenger:
        info = AppInfo(id: popup, appName: "app_name_messenger", iconImagePath: "$prefix/messenger_icon.png", hasPanelShortcut: true, requiresLogin: true);
        break;
      default:
        throw new Exception("Unknown popup: $popup");
        break;
    }

    return info;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppInfo>('currentAppInfo', _currentAppInfo));
  }
}
