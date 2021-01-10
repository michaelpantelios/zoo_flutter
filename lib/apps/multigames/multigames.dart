// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/apps/multigames/multigame_frame.dart';
import 'package:zoo_flutter/apps/multigames/multigame_thumb.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class Multigames extends StatefulWidget {
  Multigames();

  MultigamesState createState() => MultigamesState();
}

class MultigamesState extends State<Multigames> {
  MultigamesState();

  RenderBox renderBox;
  List<GameInfo> _gamesData;
  ScrollController _controller;
  double myWidth;
  double _gameThumbsDistance = 15;
  int _gameThumbsPerRow;
  List<Widget> _gameThumbs;
  List<String> excludedGames = ["backgammonus", "blackjack", "roulette", "scratch", "farkle"];
  List<GameInfo> _gamesHistory;
  String _gameBGImage = "";
  List<String> _sortedGames = [
    "backgammon",
    "kseri",
    "agonia",
    "wordfight",
    "mahjong",
    "yatzy",
    "klondike",
    "solitaire",
    "candy",
  ];

  @override
  void initState() {
    super.initState();

    _gamesHistory = [];

    _controller = ScrollController();
  }

  onGameClickHandler(String gameId) {
    if (AppBarProvider.instance.getNestedApps(AppType.Multigames).length == 3) {
      print("3 games MAX allowed!");
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("max_opened_games"));
      return;
    }
    _openGame(gameId);
  }

  _openGame(gameId) {
    print("_openGame " + gameId);
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenGame(gameId);
            }
          });
      return;
    }
    _doOpenGame(gameId);
  }

  _doOpenGame(gameId) {
    var gameToPlay = _gamesData.where((gameInfo) => gameInfo.gameid == gameId).first;
    var nestedApp = NestedAppInfo(id: gameToPlay.gameid, title: gameToPlay.name);
    nestedApp.active = true;
    var firstTimeAdded = context.read<AppBarProvider>().addNestedApp(AppType.Multigames, nestedApp);
    if (firstTimeAdded) {
      setState(() {
        _gamesHistory.add(gameToPlay);
      });
    } else {
      context.read<AppBarProvider>().activateApp(AppType.Multigames, nestedApp);
    }
  }

  Future<bool> fetchGamesInfo() async {
    final response = await http.get(Env.ASSET_URL("fbapps/promoconfig/wordfight/default"));
    if (response.statusCode == 200) {
      List<GameInfo> games = GamesInfo.fromJson(json.decode(response.body)).games.toList();

      List<Widget> _gameThumbsRows = [];

      games.forEach((element) {
        print(element.gameid);
      });
      excludedGames.forEach((exId) {
        games.removeWhere((game) => game.gameid == exId || game.variation != "default");
      });

      for (var i = 0; i < _sortedGames.length; i++) {
        var sortedGameID = _sortedGames[i];
        var gameInfoToReorder = games.firstWhere((element) => element.gameid == sortedGameID, orElse: () => null);
        if (gameInfoToReorder != null) {
          games.remove(gameInfoToReorder);
          games.insert(i, gameInfoToReorder);
          print("reorder:: $i - ${gameInfoToReorder.gameid}");
        }
      }
      print("games.length = "+games.length.toString());

      int _resultRows = (games.length / _gameThumbsPerRow).ceil();
      print("resultRows = "+_resultRows.toString());

      int gindex = -1;
      for (int j=0; j<_resultRows; j++){
        List<Widget> rowItems = [];
        for (int k=0; k<_gameThumbsPerRow; k++){
          gindex++;
          if (gindex < games.length) {
            rowItems.add(
                MultigameThumb(
                    onClickHandler: onGameClickHandler, data: games[gindex])
            );
          } else rowItems.add(
            SizedBox(width: MultigameThumb.myWidth, height: MultigameThumb.myHeight)
          );
        }
        _gameThumbsRows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: rowItems));
        _gameThumbsRows.add(SizedBox(height: _gameThumbsDistance));
      }

      setState(() {
        _gamesData = games;
        _gameThumbs = _gameThumbsRows;
      });

    }
    return false;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    myWidth = MediaQuery.of(context).size.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding;
    _gameThumbsPerRow = (myWidth / (MultigameThumb.myWidth + _gameThumbsDistance)).floor();

    fetchGamesInfo();
  }

  _widgetTree() {
    List<NestedAppInfo> nestedMultigames = context.watch<AppBarProvider>().getNestedApps(AppType.Multigames);
    // print("nestedMultigames: ${nestedMultigames.length}");
    // List<GameInfo> lst = [];
    for (var i = _gamesHistory.length - 1; i >= 0; i--) {
      var gameToCheck = _gamesHistory[i];
      if (nestedMultigames.firstWhere((e) => e.id == gameToCheck.gameid, orElse: () => null) == null) {
        // lst.add(element);
        _gamesHistory.remove(gameToCheck);
      }
    }

    // _gamesHistory = lst;

    var firstActiveGame = nestedMultigames.firstWhere((element) => element.active, orElse: () => null);
    GameInfo currentGame;
    if (firstActiveGame != null) {
      currentGame = _gamesHistory.firstWhere((element) => element.gameid == firstActiveGame.id);
      _gameBGImage = currentGame.bgImage;
    }

    print("multigames --- currentGame: ${currentGame?.gameid}");

    return _gamesData != null
        ? Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Theme.of(context).backgroundColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0), bottomRight: Radius.circular(9.0))),
                    height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - 40,
                    child: SingleChildScrollView(
                     child: Column(
                       children: _gameThumbs,
                     )
                    )
                  ),
                  Container(
                    height: 35,
                    margin: EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(9)
                    ),
                    child: Center(child: Html(
                        data: """${AppLocalizations.of(context).translate("rest_games")}""",
                        onLinkTap: (url) async {
                          print("Open $url");
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        style: {
                          "html": Style(color: Colors.black, fontSize: FontSize.large, textAlign: TextAlign.center, verticalAlign: VerticalAlign.BASELINE),
                        }
                    ) ),
                  )
                ],
              ),
              currentGame != null
                  ? Container(
                      width: myWidth,
                      height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
                      decoration: BoxDecoration(
                        // color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(Env.ASSET_URL(_gameBGImage)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(),
            ]..addAll(_gamesHistory.map((e) {
                return MultiGamesFrame(key: Key(e.gameid), gameInfo: e);
              })),
          )
        : Center(
            child: Container(
              width: MediaQuery.of(context).size.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding,
              height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
              child: Text(
                AppLocalizations.of(context).translate("pleaseWait"),
                style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return _widgetTree();
  }
}
