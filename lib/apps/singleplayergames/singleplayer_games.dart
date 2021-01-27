import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleGameFrame.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_category_row.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

import '../../main.dart';

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
  bool _dataFetched = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["brain", "casual", "arcade", "action", "classic", "match3", "shooter", "runner", "sports", "racing"];
  ScrollController _controller;
  bool _gameVisible = false;
  int _maxPrefGames = 10;

  List<SinglePlayerCategoryRow> _rows = [];
  List<SinglePlayerGameInfo> prefGames = [];

  onCloseGame() {
    setState(() {
      _gameVisible = false;
      _refresh();
    });
  }

  onGameClickHandler(SinglePlayerGameInfo gameInfo) async {
      print("lets play " + gameInfo.gameName);

      if (UserProvider.instance.logged){
        List<dynamic> userPrefs = UserProvider.instance.singlegamesPrefs;

          if ((userPrefs.singleWhere((pref) => pref["gameId"] == gameInfo.gameId,
              orElse: () => null)) == null) {

            if (userPrefs.length == _maxPrefGames)
              userPrefs.removeLast();

              userPrefs.insert(0, {"gameId" : gameInfo.gameId, "order" : 1});

              for (int i=0; i<userPrefs.length; i++){
                if (i>0)
                  userPrefs[i]["order"]++;
              }

          UserProvider.instance.singlegamesPrefs = userPrefs;
        }
      }

      setState(() {
        gameViewContent = SingleGameFrame(
          gameInfo: gameInfo,
          availableSize: new Size(myWidth, myHeight),
          onCloseHandler: onCloseGame,
        );

        _gameVisible = true;
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
    myHeight = renderBox.size.height;
  }

  _refresh(){
    loadGames().then((_) {
      createListContent();
    });
  }

  createListContent() {
    categories.removeWhere((category) => category == "recent");
    prefGames = [];
    _rows = [];
    // zero out prefs;
    // List<dynamic> _prefs = UserProvider.instance.singlegamesPrefs;
    // _prefs.clear();
    // UserProvider.instance.singlegamesPrefs = _prefs;

    // if (UserProvider.instance.logged){
    //   print("lets see pref games:");
    //  for(int i=0; i<UserProvider.instance.singlegamesPrefs.length; i++)
    //    print("pref game: "+UserProvider.instance.singlegamesPrefs[i]["gameId"]);
    // }

    for (int i = 0; i < categories.length; i++) {
      List<SinglePlayerGameInfo> _catGames = _gamesData.singlePlayerGames.where((game) => game.category == categories[i]).toList();
      _catGames.sort((a, b) => a.order.compareTo(b.order));
      SinglePlayerCategoryRow row = new SinglePlayerCategoryRow(
        categoryName: AppLocalizations.of(context).translate("app_singleplayergames_category_" + categories[i]),
        data: _catGames,
        myWidth: myWidth - 10,
        thumbClickHandler: onGameClickHandler,
      );
      _rows.add(row);

      if (UserProvider.instance.logged){
        List<dynamic> userPrefs = UserProvider.instance.singlegamesPrefs;
        if (userPrefs.length > 0){
          for (int j = 0; j<_catGames.length; j++){
            for (int k=0; k<userPrefs.length; k++){
              if (userPrefs[k]["gameId"] == _catGames[j].gameId){
                _catGames[j].order = userPrefs[k]["order"];
                prefGames.add(_catGames[j]);
              }
            }
          }
          prefGames.sort((a,b) => a.order.compareTo(b.order));
        }
      }
    }

    if (prefGames.length > 0){
      SinglePlayerCategoryRow row = new SinglePlayerCategoryRow(
        categoryName: AppLocalizations.of(context).translate("app_singleplayergames_category_recent"),
        data: prefGames,
        myWidth: myWidth - 10,
        thumbClickHandler: onGameClickHandler,
      );
      _rows.insert(0, row);
      categories.insert(0, "recent");
    }

    setState(() {
      _dataFetched = true;
    });

  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    print("init state");
    super.initState();
    gameViewContent = Container();
    _controller = ScrollController();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Root.AppSize.width - GlobalSizes.panelWidth,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: Stack(
          children: [
            !_dataFetched
                ? Container()
                : DraggableScrollbar(
                    alwaysVisibleScrollThumb: true,
                    controller: _controller,
                    heightScrollThumb: 150.0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    scrollThumbBuilder: (
                        Color backgroundColor,
                        Animation<double> thumbAnimation,
                        Animation<double> labelAnimation,
                        double height, {
                          Text labelText,
                          BoxConstraints labelConstraints,
                        }) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xff616161),
                          borderRadius: BorderRadius.circular(4.5),
                        ),
                        height: 150,
                        width: 9.0,
                      );
                    },
                    child: ListView(
                      controller: _controller,
                      // itemExtent: SinglePlayerGameThumb.myHeight+50,
                     children: _rows,
                    )),
            Visibility(visible: _gameVisible, child: gameViewContent),
          ],
        ));
  }
}
