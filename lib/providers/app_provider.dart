import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/chat/chat.dart';
import 'package:zoo_flutter/apps/forum/forum.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';

enum AppType {
  Home,
  Chat,
  Forum,
  Multigames,
  Search,
  Messenger,
  PrivateChat,
}

class AppInfo {
  final AppType id;
  final String appName;
  final IconData iconPath;

  AppInfo({
    @required this.id,
    @required this.appName,
    @required this.iconPath,
  });

  @override
  String toString() {
    return "id: ${id}, appName: ${appName}";
  }
}

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map<AppType, Widget> _cachedAppWidgets;

  AppInfo _currentAppInfo;
  AppInfo get currentAppInfo => _currentAppInfo;

  Widget _currentAppWidget;
  Widget get currentAppWidget => _currentAppWidget;

  static AppProvider instance = null;

  AppProvider() {
    print("app provider");
    instance = this;
    _currentAppInfo = getAppInfo(AppType.Home);
    _currentAppWidget = _getAppWidget(AppType.Home);
  }

  activate(AppType app) {
    if (_currentAppInfo.id == app) {
      print("Already in app: ${app}");
      return;
    }
    _currentAppInfo = getAppInfo(app);
    _currentAppWidget = _getAppWidget(app);
    notifyListeners();
  }

  AppInfo getAppInfo(AppType popup) {
    AppInfo info;
    switch (popup) {
      case AppType.Home:
        info = AppInfo(id: popup, appName: "app_name_home", iconPath: Icons.home_filled);
        break;
      case AppType.Chat:
        info = AppInfo(id: popup, appName: "app_name_chat", iconPath: Icons.chat_bubble);
        break;
      case AppType.Forum:
        info = AppInfo(id: popup, appName: "app_name_forum", iconPath: Icons.notes);
        break;
      case AppType.Multigames:
        info = AppInfo(id: popup, appName: "app_name_multigames", iconPath: Icons.casino);
        break;
      case AppType.Search:
        info = AppInfo(id: popup, appName: "app_name_search", iconPath: Icons.search);
        break;
      case AppType.Messenger:
        info = AppInfo(id: popup, appName: "app_name_messenger", iconPath: Icons.comment);
        break;
      case AppType.PrivateChat:
        info = AppInfo(id: popup, appName: "app_name_privateChat", iconPath: Icons.chat_bubble);
        break;
      default:
        throw new Exception("Uknwown popup: ${popup}");
        break;
    }

    return info;
  }

  Widget _getAppWidget(AppType popup, [BuildContext context]) {
    if (_cachedAppWidgets == null) _cachedAppWidgets = Map<AppType, Widget>();
    if (_cachedAppWidgets.containsKey(popup)) return _cachedAppWidgets[popup];

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
        widget = Container();
        break;
      case AppType.Messenger:
        widget = MessengerChat();
        break;
      case AppType.PrivateChat:
        widget = PrivateChat();
        break;
      default:
        throw new Exception("Uknwown app: ${popup}");
        break;
    }

    _cachedAppWidgets[popup] = widget;

    return widget;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
