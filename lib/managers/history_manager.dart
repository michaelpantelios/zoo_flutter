import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:lazytime/js/aux.dart';
import 'package:zoo_flutter/providers/app_provider.dart';

class HistoryManager {
  HistoryManager._privateConstructor();

  static final HistoryManager instance = HistoryManager._privateConstructor();

  handleUrlNavigation(BuildContext context) {
    var location = window.location.toString();

    Uri uri = Uri.parse(location);
    String originUrl = "";
    if (uri.hasQuery) {
      originUrl = location.substring(7, location.indexOf(uri.query) - 1);
    } else {
      originUrl = location.substring(7);
    }

    print(originUrl);

    var firstSlashIndex = originUrl.indexOf('/');
    if (firstSlashIndex == -1) AppProvider.instance.activate(AppType.Home, context);
    var mainApp = null;
    var nested1 = null;
    var nested2 = null;

    var splitedUrl = originUrl.split('/');
    print('splitedUrl: $splitedUrl');
    if (splitedUrl.length > 1) mainApp = splitedUrl[1];

    if (splitedUrl.length > 2) nested1 = splitedUrl[2];

    if (splitedUrl.length > 3) nested2 = splitedUrl[3];

    switch (mainApp) {
      case "home":
        AppProvider.instance.activate(AppType.Home, context);
        break;
      case "games":
        AppProvider.instance.activate(AppType.Multigames, context, {"game": nested1});
        break;
      case "browsergames":
        AppProvider.instance.activate(AppType.BrowserGames, context, {"game": nested1});
        break;
      case "singleplayer":
        AppProvider.instance.activate(AppType.SinglePlayerGames, context, {"game": nested1});
        break;
      case "chat":
        AppProvider.instance.activate(AppType.Chat, context);
        break;
      case "forum":
        AppProvider.instance.activate(AppType.Forum, context, {"topicId": nested1, "forumId": nested2});
        break;
      case "messenger":
        AppProvider.instance.activate(AppType.Messenger, context);
        break;
      case "search":
        AppProvider.instance.activate(AppType.Search, context);
        break;
    }
  }

  push(AppType appType) {
    String appTypeID = appType.toString().split('.').last;
    print('appTypeID: ${appTypeID}');
    var location = window.location.toString();

    Uri uri = Uri.parse(location);
    String originUrl = "";
    if (uri.hasQuery) {
      originUrl = location.substring(7, location.indexOf(uri.query) - 1);
    } else {
      originUrl = location.substring(7);
    }
    // Aux.jsHistoryPush({}, '', mainApp.toLowerCase() + (nested1 != null && nested1.isNotEmpty ? "/" + nested1 : "") + (uri.hasQuery ? "?" + uri.query : ""));
    String appTypeUrl = "";
    // Home,
    // Multigames,
    // BrowserGames,
    // SinglePlayerGames,
    // Chat,
    // Forum,
    // Messenger,
    // Search,
    // PrivateChat,
    switch (appTypeID) {
      case "Home":
        Aux.jsHistoryPush({}, '', "home");
        break;
      case "Multigames":
        Aux.jsHistoryPush({}, '', "games");
        break;
      case "SinglePlayerGames":
        Aux.jsHistoryPush({}, '', "singlegames");
        break;
      case "BrowserGames":
        Aux.jsHistoryPush({}, '', "browsergames");
        break;
      default:
        Aux.jsHistoryPush({}, '', "");
        break;
    }
  }
}
