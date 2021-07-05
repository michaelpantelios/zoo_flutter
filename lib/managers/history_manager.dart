import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:lazytime/js/aux.dart';
import 'package:zoo_flutter/models/login/login_user_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class HistoryManager {
  HistoryManager._privateConstructor();

  static final HistoryManager instance = HistoryManager._privateConstructor();

  handleUrlNavigation(BuildContext context) async {
    var location = window.location.toString();
    var mainApp = null;
    var nested1 = null;
    var nested2 = null;

    Uri uri = Uri.parse(location);
    if (uri.hasQuery) {
      print('query: ' + uri.query + " length: " + uri.query.length.toString());
      String username = uri.queryParameters["user"];
      String pass = uri.queryParameters["pass"];
      String game = uri.queryParameters["game"];
      print(username);
      print(pass);
      print(game);
      if (game.isNotEmpty && username.isNotEmpty && pass.isNotEmpty) {
        var loginUserInfo = LoginUserInfo(
          username: username,
          password: pass,
          activationCode: null,
          machineCode: UserProvider.instance.getMachineCode(),
          keepLogged: 0,
        );
        var loginRes = await UserProvider.instance.login(loginUserInfo);
        mainApp = "multigames";
        nested1 = uri.queryParameters["game"];
      }
    }

    switch (mainApp) {
      case "home":
        AppProvider.instance.activate(AppType.Home, context);
        break;
      case "multigames":
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
      default:
        AppProvider.instance.activate(AppType.Home, context);
        break;
    }
  }

  push(String mainApp, {String nested1}) {
    Aux.jsHistoryPush({}, '', mainApp.toLowerCase() + (nested1 != null && nested1.isNotEmpty ? "/" + nested1 : ""));
  }
}
