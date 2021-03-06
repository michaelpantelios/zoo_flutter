// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_browsergame.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_multigame.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_singlegame.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class HomeModuleSuggestedGames extends StatefulWidget {
  HomeModuleSuggestedGames();

  HomeModuleSuggestedGamesState createState() => HomeModuleSuggestedGamesState();
}

class HomeModuleSuggestedGamesState extends State<HomeModuleSuggestedGames> {
  HomeModuleSuggestedGamesState();

  final List<String> multigames = ["backgammon", "kseri", "mahjong"];
  final List<String> browsergames = ["ggempire", "farmerama", "smeet3dworld"];
  final List<String> singlegames = ["2048legend", "minigolfmaster", "zumbamania"];

  List<SuggestedMultigame> _multiGameThumbs = [];
  List<SuggestedBrowsergame> _browserGameThumbs = [];
  List<SuggestedSinglegame> _singleGameThumbs = [];

  onMultiGameClickHandler(String id) {
    //todo open specific game
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Multigames).id, context);
  }

  onBrowserGameClickHandler(String id) {
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.BrowserGames).id, context);
  }

  onSingleGameClickHandler(String id) {
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.SinglePlayerGames).id, context);
  }

  fetchMultigames() async {
    final response = await http.get(Env.ASSET_URL("fbapps/promoconfig/wordfight/default"));
    if (response.statusCode == 200) {
      List<SuggestedMultigame> lst = [];
      List<GameInfo> _allGamesData = GamesInfo.fromJson(json.decode(response.body)).games.toList();
      _allGamesData.forEach((game) {
        if (multigames.contains(game.gameid)) lst.add(SuggestedMultigame(onClickHandler: onMultiGameClickHandler, data: game));
      });

      setState(() {
        _multiGameThumbs = lst;
      });
    }
  }

  fetchBrowserGames() async {
    String jsonString = await rootBundle.loadString('assets/data/browsergames.json');

    List<SuggestedBrowsergame> lst = [];
    final jsonResponse = json.decode(jsonString);
    BrowserGamesInfo _gamesData = BrowserGamesInfo.fromJson(jsonResponse);
    _gamesData.browserGames.forEach((game) {
      if (browsergames.contains(game.gameId)) lst.add(SuggestedBrowsergame(data: game, onClickHandler: onBrowserGameClickHandler));
    });

    setState(() {
      _browserGameThumbs = lst;
    });
  }

  fetchSingleGames() async {
    String jsonString = await rootBundle.loadString('assets/data/singleplayergames.json');
    List<SuggestedSinglegame> lst = [];
    final jsonResponse = json.decode(jsonString);
    SinglePlayerGamesInfo _gamesData = SinglePlayerGamesInfo.fromJson(jsonResponse);
    _gamesData.singlePlayerGames.forEach((game) {
      if (singlegames.contains(game.gameId)) lst.add(SuggestedSinglegame(data: game, onClickHandler: onSingleGameClickHandler));
    });
    setState(() {
      _singleGameThumbs = lst;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMultigames();
    fetchBrowserGames();
    fetchSingleGames();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_suggested_games"), context),
        Container(
            height: 28,
            color: Theme.of(context).secondaryHeaderColor,
            padding: EdgeInsets.symmetric(horizontal: 13),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate("app_home_module_suggested_games_multi"), style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left),
                GestureDetector(
                    onTap: () {
                      context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Multigames).id, context);
                    },
                    child: Text(AppLocalizations.of(context).translate("app_home_more_link"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left))
              ],
            )),
        Container(
            height: 160,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _multiGameThumbs,
            )),
        Container(
            height: 28,
            color: Theme.of(context).secondaryHeaderColor,
            padding: EdgeInsets.symmetric(horizontal: 13),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate("app_home_module_suggested_games_browser"), style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left),
                GestureDetector(
                    onTap: () {
                      context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.BrowserGames).id, context);
                    },
                    child: Text(AppLocalizations.of(context).translate("app_home_more_link"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left))
              ],
            )),
        Container(
            height: 160,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _browserGameThumbs,
            )),
        Container(
            height: 28,
            color: Theme.of(context).secondaryHeaderColor,
            padding: EdgeInsets.symmetric(horizontal: 13),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate("app_home_module_suggested_games_single"), style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left),
                GestureDetector(
                    onTap: () {
                      context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.SinglePlayerGames).id, context);
                    },
                    child: Text(AppLocalizations.of(context).translate("app_home_more_link"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left))
              ],
            )),
        Container(
            height: 160,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _singleGameThumbs,
            )),
      ],
    );
  }
}
