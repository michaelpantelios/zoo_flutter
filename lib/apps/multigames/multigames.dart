// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/multigames/models/gamesInfo.dart';
import 'package:zoo_flutter/apps/multigames/multigame_thumb.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Multigames extends StatefulWidget {
  Multigames({Key key});

  MultigamesState createState() => MultigamesState();
}

class MultigamesState extends State<Multigames>{
  MultigamesState();

  RenderBox renderBox;
  Widget gamesListContent;
  Widget currentGameContent;
  Widget content;
  List<GameInfo> _gamesData;
  ScrollController _controller;
  bool _inited = false;
  double myWidth;
  double myHeight;
  List<String> excludedGames = ["backgammonus", "blackjack", "roulette", "scratch"];

  List<String> _selectedGames;
  GameInfo currentGame;

  onGameClickHandler(String gameId){
    setState(() {
      print("Lets play "+gameId);
      _selectedGames.add(gameId);
      currentGame = _gamesData.where((gameInfo) => gameInfo.gameid == gameId).first;
      print(MultigameThumb.getAssetUrl(currentGame.bgImage));
      currentGameContent = Container(
        width: myWidth,
        height: myHeight-100,
        decoration: BoxDecoration(
          // color: const Color(0xff7c94b6),
          image: DecorationImage(
            image: NetworkImage(MultigameThumb.getAssetUrl(currentGame.bgImage)),
            fit: BoxFit.cover,
          ),
        ),
        child: Icon(Icons.face, size: 200, color: Colors.red)
      );

      content = currentGameContent;
    });
  }

  Future<bool> fetchGamesInfo() async {
    final response = await http.get(MultigameThumb.getAssetUrl("/fbapps/promoconfig/wordfight/default"));
    if (response.statusCode == 200) {
      _gamesData = GamesInfo.fromJson(json.decode(response.body)).games.toList();
       excludedGames.forEach((exId) { _gamesData.removeWhere((game) => game.gameid == exId || game.variation != "default"); }) ;

       if (_gamesData.length > 0)
        return true;
    }
    return false;
  }

  _afterLayout(_){
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();

    _selectedGames = new List<String>();

    _controller = ScrollController();

    fetchGamesInfo().then((res) => {
      setState(() {
        if (res) {
          gamesListContent =
              Center(
                  child: Container(
                      // width: myWidth,
                      height: myHeight - 100,
                      child: GridView.builder(
                        itemCount: _gamesData.length,
                        scrollDirection: Axis.vertical,
                        controller: _controller,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          maxCrossAxisExtent: MultigameThumb.myWidth
                        ),
                        itemBuilder: (BuildContext context, int index){
                          return MultigameThumb(
                              onClickHandler: onGameClickHandler,
                              data: _gamesData[index]);
                        },
                      )
                  )
              );

          content = gamesListContent;
        }

      })
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    myHeight = MediaQuery.of(context).size.height;
    if (!_inited){
      content = Center(
          child: Container(
            width: 300,
            height: myHeight - 100,
            child: Text(
                AppLocalizations.of(context).translate("pleaseWait"),
                style: TextStyle( color: Colors.grey, fontSize: 30, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              )
          )
      );
      _inited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}