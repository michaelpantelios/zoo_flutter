import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleGameFrame.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_category_row.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class SinglePlayerGames extends StatefulWidget {
  SinglePlayerGames();

  SinglePlayerGamesState createState() => SinglePlayerGamesState();
}

class SinglePlayerGamesState extends State<SinglePlayerGames> {
  SinglePlayerGamesState();

  Widget content;
  Widget listContent;
  Widget gameViewContent;
  RenderBox renderBox;
  SinglePlayerGamesInfo _gamesData;
  bool _inited = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["brain", "casual", "arcade", "action", "classic", "match3", "shooter", "runner", "sports", "racing"];
  ScrollController _controller;

  onCloseGame() {
    setState(() {
      content = listContent;
    });
  }

  onGameClickHandler(SinglePlayerGameInfo gameInfo) {
    setState(() {
      print("lets play " + gameInfo.gameName);

      gameViewContent = SingleGameFrame(gameInfo: gameInfo, availableSize: new Size(myWidth, myHeight), onCloseHandler: onCloseGame);

      content = gameViewContent;
    });
  }

  Future<void> loadGames() async {
    String jsonString = await rootBundle.loadString('assets/data/singleplayergames.json');
    final jsonResponse = json.decode(jsonString);
    _gamesData = SinglePlayerGamesInfo.fromJson(jsonResponse);
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    print("init state");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    content = Container();
    _controller = ScrollController();
    loadGames().then((_) {
      createListContent();
      print("hi");
    });
  }

  createListContent() {
    setState(() {
      print("createContent");
      listContent = Container(
          width: myWidth,
          height: myHeight - 80,
          child: Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              child: ListView.builder(
                controller: _controller,
                // itemExtent: SinglePlayerGameThumb.myHeight+50,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  List<SinglePlayerGameInfo> rowGamesData = _gamesData.singlePlayerGames.where((game) => game.category == categories[index]).toList();
                  rowGamesData.sort((a, b) => a.order.compareTo(b.order));
                  return SinglePlayerCategoryRow(
                    categoryName: AppLocalizations.of(context).translate("app_singleplayergames_category_" + categories[index]),
                    data: rowGamesData,
                    myWidth: myWidth,
                    thumbClickHandler: onGameClickHandler,
                  );
                },
              )));

      content = listContent;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inited) {
      myHeight = MediaQuery.of(context).size.height;
      _inited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
