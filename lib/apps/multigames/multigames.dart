// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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
import 'package:zoo_flutter/widgets/draggable_scrollbar.dart';

import '../../main.dart';

class Multigames extends StatefulWidget {
  Multigames();

  MultigamesState createState() => MultigamesState();
}

class MultigamesState extends State<Multigames> {
  MultigamesState();

  dynamic _initOptions;
  RenderBox renderBox;
  List<GameInfo> _gamesData;
  ScrollController _controller;
  double myWidth;
  double _gameThumbsDistance = 15;
  int _gameThumbsPerRow;
  List<Widget> _gameThumbs = [];
  List<String> excludedGames = ["backgammonus", "blackjack", "roulette", "scratch", "farkle"];
  List<GameInfo> _gamesHistory;
  String _gameBGImage = "";
  // List<String> _sortedGames = ["backgammon", "kseri", "agonia", "biriba", "wordfight", "wordwar", "wordtower", "mahjong", "yatzy", "klondike", "solitaire", "candy", "fishing"];
  List<String> _sortedBoardGames = ["backgammon", "mahjong", "yatzy", "candy", "fishing","hercules"];
  List<String> _sortedCardGames = ["kseri", "agonia", "biriba", "klondike", "solitaire"];
  List<String> _sortedWordGames = ["wordfight", "wordwar", "wordtower", "sevenwonders","wordmania"];

  List<String> _categories = ["board", "card", "word"];

  @override
  void initState() {
    super.initState();

    AppProvider.instance.addListener(_onAppProviderListener);

    _gamesHistory = [];

    _controller = ScrollController();

    fetchGamesInfo();
  }

  _onAppProviderListener(){
    if (_gamesData == null) return;
    if (AppProvider.instance.currentAppInfo.id == AppProvider.instance.getAppInfo(AppType.Multigames).id){
      if (AppProvider.instance.currentAppInfo.options != null){
        _initOptions = AppProvider.instance.currentAppInfo.options;
        GameInfo info = _initOptions["gameInfo"];
        onGameClickHandler(info.gameid);
      } else {
        _initOptions = null;
        print("_initOptions = null");
      }
    }
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
    print("_doOpenGame:");
    var gameToPlay = _gamesData.where((gameInfo) => gameInfo.gameid == gameId).first;
    print((gameToPlay as GameInfo).bgImage);
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

  fetchGamesInfo() async {
    String jsonString = await rootBundle.loadString('assets/data/multigames.json');
    List<dynamic> jsonResponse = json.decode(jsonString);
    List<GameInfo> games = [];

    List<GameInfo> boardGames = [];
    List<GameInfo> cardGames = [];
    List<GameInfo> wordGames = [];

    for (var game in jsonResponse) {
      GameInfo gameInfo = GameInfo.fromJson(game);
      switch(gameInfo.category){
        case "board" :
          boardGames.add(gameInfo);
          break;
        case "card" :
          cardGames.add(gameInfo);
          break;
        case "word":
          wordGames.add(gameInfo);
          break;
      }
    }

    myWidth = Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding;
    _gameThumbsPerRow = (myWidth / (MultigameThumb.myWidth + _gameThumbsDistance)).floor();

    List<Widget> _boardGameThumbsRows = [];
    List<Widget> _cardGameThumbRows = [];
    List<Widget> _wordGameThumbRows = [];

    excludedGames.forEach((exId) {
      boardGames.removeWhere((game) => game.gameid == exId || game.variation != "default");
      cardGames.removeWhere((game) => game.gameid == exId || game.variation != "default");
      wordGames.removeWhere((game) => game.gameid == exId || game.variation != "default");
    });

    for (var i = 0; i < _sortedBoardGames.length; i++) {
      var sortedGameID = _sortedBoardGames[i];
      var gameInfoToReorder = boardGames.firstWhere((element) => element.gameid == sortedGameID, orElse: () => null);
      if (gameInfoToReorder != null) {
        boardGames.removeWhere((element) => element.gameid == sortedGameID);
        boardGames.insert(i, gameInfoToReorder);
      }
    }

    for (var i = 0; i < _sortedCardGames.length; i++) {
      var sortedGameID = _sortedCardGames[i];
      var gameInfoToReorder = cardGames.firstWhere((element) => element.gameid == sortedGameID, orElse: () => null);
      if (gameInfoToReorder != null) {
        cardGames.removeWhere((element) => element.gameid == sortedGameID);
        cardGames.insert(i, gameInfoToReorder);
      }
    }

    for (var i = 0; i < _sortedWordGames.length; i++) {
      var sortedGameID = _sortedWordGames[i];
      var gameInfoToReorder = wordGames.firstWhere((element) => element.gameid == sortedGameID, orElse: () => null);
      if (gameInfoToReorder != null) {
        wordGames.removeWhere((element) => element.gameid == sortedGameID);
        wordGames.insert(i, gameInfoToReorder);
      }
    }

    int _boardResultRows = (boardGames.length / _gameThumbsPerRow).ceil();
    int _cardResultRows = (cardGames.length / _gameThumbsPerRow).ceil();
    int _wordResultRows = (wordGames.length / _gameThumbsPerRow).ceil();

   Widget boardGamesHeader =
        Container(
          width: myWidth,
          margin: EdgeInsets.only(bottom : _gameThumbsDistance / 2),
          height: 30,
          color: Theme.of(context).secondaryHeaderColor,
          padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
          child: Text(AppLocalizations.of(context).translate("app_multigames_category_board"),
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      );

    Widget cardGamesHeader =
      Container(
        width: myWidth,
        margin: EdgeInsets.only(bottom : _gameThumbsDistance / 2),
        height: 30,
        color: Theme.of(context).secondaryHeaderColor,
        padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
        child: Text(AppLocalizations.of(context).translate("app_multigames_category_card"),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      );

    Widget wordGamesHeader =
      Container(
        width: myWidth,
        margin: EdgeInsets.only(bottom : _gameThumbsDistance / 2),
        height: 30,
        color: Theme.of(context).secondaryHeaderColor,
        padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
        child: Text(AppLocalizations.of(context).translate("app_multigames_category_word"),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      );


    int gindex = -1;
    for (int j = 0; j < _boardResultRows; j++) {
      List<Widget> rowItems = [];
      for (int k = 0; k < _gameThumbsPerRow; k++) {
        gindex++;
        if (gindex < boardGames.length) {
          rowItems.add(MultigameThumb(onClickHandler: onGameClickHandler, data: boardGames[gindex]));
        } else
          rowItems.add(SizedBox(width: MultigameThumb.myWidth + (_gameThumbsDistance / 2), height: MultigameThumb.myHeight));
      }
      _boardGameThumbsRows.add(Padding(padding: EdgeInsets.symmetric(horizontal: _gameThumbsDistance / 2), child: Row(mainAxisAlignment: MainAxisAlignment.start, children: rowItems)));
      _boardGameThumbsRows.add(SizedBox(height: _gameThumbsDistance / 2));
    }

    gindex = -1;
    for (int j = 0; j < _cardResultRows; j++) {
      List<Widget> rowItems = [];
      for (int k = 0; k < _gameThumbsPerRow; k++) {
        gindex++;
        if (gindex < cardGames.length) {
          rowItems.add(MultigameThumb(onClickHandler: onGameClickHandler, data: cardGames[gindex]));
        } else
          rowItems.add(SizedBox(width: MultigameThumb.myWidth + (_gameThumbsDistance / 2), height: MultigameThumb.myHeight));
      }
      _cardGameThumbRows.add(Padding(padding: EdgeInsets.symmetric(horizontal: _gameThumbsDistance / 2), child: Row(mainAxisAlignment: MainAxisAlignment.start, children: rowItems)));
      _cardGameThumbRows.add(SizedBox(height: _gameThumbsDistance / 2));
    }

    gindex = -1;
    for (int j = 0; j < _wordResultRows; j++) {
      List<Widget> rowItems = [];
      for (int k = 0; k < _gameThumbsPerRow; k++) {
        gindex++;
        if (gindex < wordGames.length) {
          rowItems.add(MultigameThumb(onClickHandler: onGameClickHandler, data: wordGames[gindex]));
        } else
          rowItems.add(SizedBox(width: MultigameThumb.myWidth + (_gameThumbsDistance / 2), height: MultigameThumb.myHeight));
      }
      _wordGameThumbRows.add(Padding(padding: EdgeInsets.symmetric(horizontal: _gameThumbsDistance / 2), child: Row(mainAxisAlignment: MainAxisAlignment.start, children: rowItems)));
      _wordGameThumbRows.add(SizedBox(height: _gameThumbsDistance / 2));
    }

    setState(() {
      _gamesData = boardGames + cardGames + wordGames;
      _gameThumbs.add(boardGamesHeader);
      _gameThumbs += _boardGameThumbsRows;
      _gameThumbs.add(cardGamesHeader);
      _gameThumbs += _cardGameThumbRows;
      _gameThumbs.add(wordGamesHeader);
      _gameThumbs += _wordGameThumbRows;
      _onAppProviderListener();
    });
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

    return _gamesData != null
        ? Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0), bottomRight: Radius.circular(9.0))),
                      width: Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding,
                      height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - 10,
                      child: DraggableScrollbar(
                          heightScrollThumb: 100,
                          controller: _controller,
                          child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SingleChildScrollView(
                                  controller: _controller,
                                  child: Column(
                                    children: _gameThumbs,
                                  ))))),
                  // Container(
                  //   height: 45,
                  //   margin: EdgeInsets.only(top: 5),
                  //   padding: const EdgeInsets.symmetric(vertical: 2),
                  //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
                  //   child: Center(
                  //       child: Html(
                  //           data: """${AppLocalizations.of(context).translate("rest_games")}""",
                  //           onLinkTap: (url) async {
                  //             print("Open $url");
                  //             if (await canLaunch(url)) {
                  //               await launch(url);
                  //             } else {
                  //               throw 'Could not launch $url';
                  //             }
                  //           },
                  //           style: {
                  //             "html": Style(color: Colors.black, fontSize: FontSize.large, textAlign: TextAlign.center, verticalAlign: VerticalAlign.BASELINE),
                  //           })),
                  // )
                ],
              ),
              currentGame != null
                  ? Container(
                      width: myWidth,
                      height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
                      decoration: _gameBGImage.isNotEmpty
                          ? BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(Env.ASSET_URL(_gameBGImage)),
                                fit: BoxFit.cover,
                              ),
                            )
                          : BoxDecoration(
                              color: const Color(0xffffffff),
                            ),
                    )
                  : Container(),
            ]..addAll(_gamesHistory.map((e) {
                return MultiGamesFrame(key: Key(e.gameid), gameInfo: e);
              })),
          )
        : Center(
            child: Container(
              width: Root.AppSize.width - GlobalSizes.panelWidth - GlobalSizes.fullAppMainPadding,
              height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
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
