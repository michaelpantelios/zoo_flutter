import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleGameFrame.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_thumb.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/providers/app_provider.dart';

import '../../main.dart';

class SinglePlayerGames extends StatefulWidget {
  SinglePlayerGames();

  SinglePlayerGamesState createState() => SinglePlayerGamesState();
}

class SinglePlayerGamesState extends State<SinglePlayerGames> {
  SinglePlayerGamesState();

  dynamic _initOptions;
  Widget content;
  Widget listContent;
  Widget gameViewContent;
  RenderBox renderBox;
  SinglePlayerGamesInfo _gamesData;
  bool _ready = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["brain", "match3", "casual", "arcade", "action", "classic",  "shooter", "runner", "sports", "racing"];
  ScrollController _controller;
  bool _gameVisible = false;
  int _maxPrefGames = 10;

  int _gameThumbsPerRow;

  double _gameThumbsDistance = 15;

  List<Widget> _rows = [];
  List<SinglePlayerGameInfo> prefGames = [];

  onCloseGame() {
    setState(() {
      _gameVisible = false;
      // _refresh();
    });
  }

  onGameClickHandler(SinglePlayerGameInfo gameInfo) async {
      print("lets play " + gameInfo.gameName);

      // if (UserProvider.instance.logged){
      //   List<dynamic> userPrefs = UserProvider.instance.singlegamesPrefs;
      //
      //     if ((userPrefs.singleWhere((pref) => pref["gameId"] == gameInfo.gameId,
      //         orElse: () => null)) == null) {
      //
      //       if (userPrefs.length == _maxPrefGames)
      //         userPrefs.removeLast();
      //
      //         userPrefs.insert(0, {"gameId" : gameInfo.gameId, "order" : 1});
      //
      //         for (int i=0; i<userPrefs.length; i++){
      //           if (i>0)
      //             userPrefs[i]["order"]++;
      //         }
      //
      //     UserProvider.instance.singlegamesPrefs = userPrefs;
      //   }
      // }

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
    String jsonString = await rootBundle.loadString('assets/data/singleplayergames/singleplayergames.json');
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
    // categories.removeWhere((category) => category == "recent");
    // prefGames = [];
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

     myWidth = Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding;
    _gameThumbsPerRow = (myWidth / (SinglePlayerGameThumb.myWidth + _gameThumbsDistance)).floor();

    List<Widget> gameThumbsRows = [];

    for (int i = 0; i < categories.length; i++) {
      List<SinglePlayerGameInfo> _catGames = _gamesData.singlePlayerGames.where((game) => game.category == categories[i]).toList();
      _catGames.removeWhere((game) => game.active == "false");
      _catGames.sort((a, b) => a.order.compareTo(b.order));

      _rows.add(
          Container(
            width:myWidth,
            margin: EdgeInsets.only(bottom : _gameThumbsDistance / 2),
            height: 30,
            color: Theme.of(context).secondaryHeaderColor,
            padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
            child: Text(categories[i] + " ("+ _catGames.length.toString()+")",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          )
      );

      List<Widget> rowItems = [];

      int _rowsNum = (_catGames.length / _gameThumbsPerRow).ceil();

      int gindex = -1;
      for (int j = 0; j < _rowsNum; j++){
        gameThumbsRows = [];
        List<Widget> rowItems = [];
        for(int k = 0; k < _gameThumbsPerRow; k++){
          gindex++;
          if(gindex < _catGames.length){
            rowItems.add(SinglePlayerGameThumb(data: _catGames[gindex], onClickHandler: onGameClickHandler));
          } else {
            rowItems.add(SizedBox(width: SinglePlayerGameThumb.myWidth + (_gameThumbsDistance / 2), height: SinglePlayerGameThumb.myHeight));
          }
        }
        gameThumbsRows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: rowItems));
        gameThumbsRows.add(SizedBox(height: _gameThumbsDistance / 2));

        _rows += gameThumbsRows;
      }

      // if (UserProvider.instance.logged){
      //   List<dynamic> userPrefs = UserProvider.instance.singlegamesPrefs;
      //   if (userPrefs.length > 0){
      //     for (int j = 0; j<_catGames.length; j++){
      //       for (int k=0; k<userPrefs.length; k++){
      //         if (userPrefs[k]["gameId"] == _catGames[j].gameId){
      //           _catGames[j].order = userPrefs[k]["order"];
      //           prefGames.add(_catGames[j]);
      //         }
      //       }
      //     }
      //     prefGames.sort((a,b) => a.order.compareTo(b.order));
      //   }
      // }
    }

    // if (prefGames.length > 0){
    //   SinglePlayerCategoryRow row = new SinglePlayerCategoryRow(
    //     categoryName: AppLocalizations.of(context).translate("app_singleplayergames_category_recent"),
    //     data: prefGames,
    //     myWidth: myWidth - 10,
    //     thumbClickHandler: onGameClickHandler,
    //   );
    //   _rows.insert(0, row);
    //   categories.insert(0, "recent");
    // }

    setState(() {
     _ready = true;
     _onAppProviderListener();
    });

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    print("init state");

    AppProvider.instance.addListener(_onAppProviderListener);

    gameViewContent = Container();
    _controller = ScrollController();
    _refresh();
  }

  _onAppProviderListener(){
    if (!_ready) return;
    if (AppProvider.instance.currentAppInfo.id == AppProvider.instance.getAppInfo(AppType.SinglePlayerGames).id){
      if (AppProvider.instance.currentAppInfo.options != null){
        _initOptions = AppProvider.instance.currentAppInfo.options;
        SinglePlayerGameInfo info = _initOptions["gameInfo"];
        onGameClickHandler(info);
      } else {
        _initOptions = null;
        print("_initOptions = null");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Root.AppSize.width - GlobalSizes.panelWidth,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: Stack(
          children: [
            DraggableScrollbar(
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
                     children: _rows,
                    )),
            Visibility(visible: _gameVisible, child: gameViewContent),
          ],
        ));
  }
}
