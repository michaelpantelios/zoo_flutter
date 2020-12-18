// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/apps/multigames/multigame_frame.dart';
import 'package:zoo_flutter/apps/multigames/multigame_thumb.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class Multigames extends StatefulWidget {
  Multigames() {}

  MultigamesState createState() => MultigamesState();
}

class MultigamesState extends State<Multigames> {
  MultigamesState();

  RenderBox renderBox;
  List<GameInfo> _gamesData;
  ScrollController _controller;
  double myWidth;
  double myHeight;
  List<String> excludedGames = ["backgammonus", "blackjack", "roulette", "scratch"];
  List<GameInfo> _gamesHistory;
  String _gameBGImage = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();

    _gamesHistory = [];

    _controller = ScrollController();
    fetchGamesInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    myHeight = MediaQuery.of(context).size.height;
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
      setState(() {
        _gamesData = GamesInfo.fromJson(json.decode(response.body)).games.toList();
        excludedGames.forEach((exId) {
          _gamesData.removeWhere((game) => game.gameid == exId || game.variation != "default");
        });
      });

      if (_gamesData.length > 0) return true;
    }
    return false;
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  _widgetTree() {
    List<NestedAppInfo> nestedMultigames = context.watch<AppBarProvider>().getNestedApps(AppType.Multigames);
    // print("nestedMultigames: ${nestedMultigames.length}");
    List<GameInfo> lst = [];
    _gamesHistory.forEach((element) {
      if (nestedMultigames.firstWhere((e) => e.id == element.gameid, orElse: () => null) != null) {
        lst.add(element);
      }
    });
    _gamesHistory = lst;

    var firstActiveGame = nestedMultigames.firstWhere((element) => element.active, orElse: () => null);
    GameInfo currentGame;
    if (firstActiveGame != null) {
      currentGame = _gamesHistory.firstWhere((element) => element.gameid == firstActiveGame.id);
      _gameBGImage = currentGame.bgImage;
    }

    // print("_gamesHistory: ${_gamesHistory.length}");

    return _gamesData != null
        ? Stack(
            children: [
              Center(
                child: Container(
                  // width: myWidth,
                  height: myHeight - 100,
                  child: GridView.builder(
                    itemCount: _gamesData.length,
                    scrollDirection: Axis.vertical,
                    controller: _controller,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(mainAxisSpacing: 10, crossAxisSpacing: 10, maxCrossAxisExtent: MultigameThumb.myWidth),
                    itemBuilder: (BuildContext context, int index) {
                      return MultigameThumb(onClickHandler: onGameClickHandler, data: _gamesData[index]);
                    },
                  ),
                ),
              ),
              currentGame != null
                  ? Container(
                      width: myWidth,
                      height: myHeight - 80,
                      decoration: BoxDecoration(
                        // color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(Env.ASSET_URL(_gameBGImage)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(),
            ]..addAll(_gamesHistory.map((e) => MultiGamesFrame(gameInfo: e))),
          )
        : Center(
            child: Container(
              width: 300,
              height: myHeight - 100,
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
