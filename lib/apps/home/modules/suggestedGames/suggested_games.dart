// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:zoo_flutter/utils/env.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_multigame.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_browsergame.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_singlegame.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:provider/provider.dart';

class HomeModuleSuggestedGames extends StatefulWidget {
  HomeModuleSuggestedGames();

  HomeModuleSuggestedGamesState createState() => HomeModuleSuggestedGamesState();
}

class HomeModuleSuggestedGamesState extends State<HomeModuleSuggestedGames>{
  HomeModuleSuggestedGamesState();

  final List<String> multigames = ["backgammon", "agonia", "wordfight"];
  final List<String> browsergames = ["ggempire", "farmerama", "smeet3dworld"];
  final List<String> singlegames = ["clashofgoblins", "monstertowerdefense", "galaxywarriors"];

  List<SuggestedMultigame> _multiGameThumbs = new List<SuggestedMultigame>();
  List<SuggestedBrowsergame> _browserGameThumbs = new List<SuggestedBrowsergame>();
  List<SuggestedSinglegame> _singleGameThumbs = new List<SuggestedSinglegame>();


  onMultiGameClickHandler(String id){
    //todo open specific game
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Multigames).id, context);
  }

  onBrowserGameClickHandler(String id){
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.BrowserGames).id, context);
  }

  onSingleGameClickHandler(String id){
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.SinglePlayerGames).id, context);
  }

  fetchMultigames() async {
    final response = await http.get(Env.ASSET_URL("fbapps/promoconfig/wordfight/default"));
    if (response.statusCode == 200) {
      setState(() {
        List<GameInfo> _allGamesData = GamesInfo.fromJson(json.decode(response.body)).games.toList();
        _allGamesData.forEach((game) {
          if (multigames.contains(game.gameid))
            _multiGameThumbs.add(SuggestedMultigame(onClickHandler: onMultiGameClickHandler, data: game));
        });
      });
    }
  }

  fetchBrowserGames() async {
    String jsonString = await rootBundle.loadString('assets/data/browsergames.json');
    setState(() {
      final jsonResponse = json.decode(jsonString);
      BrowserGamesInfo _gamesData = BrowserGamesInfo.fromJson(jsonResponse);
      _gamesData.browserGames.forEach((game) {
        if (browsergames.contains(game.gameId))
          _browserGameThumbs.add(SuggestedBrowsergame(data: game, onClickHandler: onBrowserGameClickHandler));
      });
    });
  }

  fetchSingleGames() async {
    String jsonString = await rootBundle.loadString('assets/data/singleplayergames.json');
    setState(() {
      final jsonResponse = json.decode(jsonString);
      SinglePlayerGamesInfo _gamesData = SinglePlayerGamesInfo.fromJson(jsonResponse);
      _gamesData.singlePlayerGames.forEach((game) {
        if (singlegames.contains(game.gameId))
          _singleGameThumbs.add(SuggestedSinglegame(data: game, onClickHandler: onSingleGameClickHandler ));
      });
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
    return Container(
      height: 570,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        // border: Border.all(color: Colors.deepOrange, width: 3),
        borderRadius: BorderRadius.circular(9),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_suggested_games")),
            Container(
              height: 28,
              color: Color(0xffBFC1C4),
              padding: EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context).translate("app_home_module_suggested_games_multi"),
                  style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.left),
                  GestureDetector(
                    onTap: (){
                      context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Multigames).id, context);
                    },
                    child: Text(AppLocalizations.of(context).translate("app_home_more_link"),
                        style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.left)
                  )
                ],
              )
            ),
            Container(
              height: 110,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _multiGameThumbs,
              )
            ),
            Container(
                height: 28,
                color: Color(0xffBFC1C4),
                padding: EdgeInsets.symmetric(horizontal: 13),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate("app_home_module_suggested_games_browser"),
                        style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.left),
                    GestureDetector(
                        onTap: (){
                          context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.BrowserGames).id, context);
                        },
                        child: Text(AppLocalizations.of(context).translate("app_home_more_link"),
                            style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.left)
                    )
                  ],
                )
            ),
            Container(
                height: 160,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _browserGameThumbs,
                )
            ),
            Container(
                height: 28,
                color: Color(0xffBFC1C4),
                padding: EdgeInsets.symmetric(horizontal: 13),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate("app_home_module_suggested_games_single"),
                        style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.left),
                    GestureDetector(
                        onTap: (){
                          context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.SinglePlayerGames).id, context);
                        },
                        child: Text(AppLocalizations.of(context).translate("app_home_more_link"),
                            style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.left)
                    )
                  ],
                )
            ),
            Container(
                height: 160,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _singleGameThumbs,
                )
            ),
          ],
        )
    );
  }


}