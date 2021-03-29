// ignore: avoid_web_libraries_in_flutter
import 'dart:async' show Future;
import 'dart:convert';
import 'dart:html';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_thumb.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';

import '../../main.dart';


class BrowserGames extends StatefulWidget {
  BrowserGames();

  BrowserGamesState createState() => BrowserGamesState();
}

class BrowserGamesState extends State<BrowserGames> {
  BrowserGamesState();

  dynamic _initOptions;
  RenderBox renderBox;
  BrowserGamesInfo _gamesData;
  bool _ready = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["strategy", "virtualworlds", "simulation", "farms", "action", "rpg"];
  ScrollController _controller;
  int _maxPrefGames = 10;

  List<Widget> _allRows = [];
  List<BrowserGameInfo> prefGames = [];

  int _gameThumbsPerRow;

  double _gameThumbsDistance = 15;

  onGameClickHandler(BrowserGameInfo gameInfo) async {

    // if (UserProvider.instance.logged){
      List<dynamic> userPrefs = UserProvider.instance.browsergamesPrefs;

      if ((userPrefs.singleWhere((pref) => pref["gameId"] == gameInfo.gameId,
          orElse: () => null)) == null) {

        if (userPrefs.length == _maxPrefGames)
          userPrefs.removeLast();

        userPrefs.insert(0, {"gameId" : gameInfo.gameId, "order" : 1});

        for (int i=0; i<userPrefs.length; i++){
          if (i>0)
            userPrefs[i]["order"]++;
        }

        UserProvider.instance.browsergamesPrefs = userPrefs;
      }
    // }

    String url = gameInfo.gameUrl;

    if (gameInfo.gameId == "smeet3dworldweb"){
      url = url.replaceAll("sessionKey", UserProvider.instance.sessionKey.toString());
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ' + url;
    }

     _refresh();
  }

  _refresh(){
    loadGames().then((value) => createListContent());
  }

  Future<void> loadGames() async {
    String jsonString = await rootBundle.loadString('assets/data/browsergames.json');
    final jsonResponse = json.decode(jsonString);
    _gamesData = BrowserGamesInfo.fromJson(jsonResponse);
  }

  _afterLayout(_) {
    // renderBox = context.findRenderObject();
    // myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    AppProvider.instance.addListener(_onAppProviderListener);

    _controller = ScrollController();
    _refresh();
  }

  _onAppProviderListener(){
    if (!_ready) return;
    if (AppProvider.instance.currentAppInfo.id == AppProvider.instance.getAppInfo(AppType.BrowserGames).id){
      if (AppProvider.instance.currentAppInfo.options != null){
        _initOptions = AppProvider.instance.currentAppInfo.options;
        BrowserGameInfo info = _initOptions["gameInfo"];
        onGameClickHandler(info);
      } else {
        _initOptions = null;
        print("_initOptions = null");
      }
    }
  }

  createListContent() {
    prefGames = [];
    _allRows = [];

    myWidth = Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding;
    _gameThumbsPerRow = (myWidth / (BrowserGameThumb.myWidth)).floor();

    for (int i = 0; i < categories.length; i++) {
      List<Widget> categoryGameThumbsRows = [];
      List<BrowserGameInfo> _catGames = _gamesData.browserGames.where((game) => game.category == categories[i]).toList();
      _catGames.sort((a, b) => a.order.compareTo(b.order));

      _allRows.add(
          Container(
            width:myWidth,
            margin: EdgeInsets.only(bottom : _gameThumbsDistance / 2),
            height: 30,
            color: Theme.of(context).secondaryHeaderColor,
            padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
            child: Text(AppLocalizations.of(context).translate("app_browsergames_category_"+categories[i]) + " ("+ _catGames.length.toString()+")",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          )
      );

      int _rowsNum = (_catGames.length / _gameThumbsPerRow).ceil();

      int gindex = -1;

      for (int j = 0; j < _rowsNum; j++){
        categoryGameThumbsRows = [];
        List<Widget> rowItems = [];
        for(int k = 0; k < _gameThumbsPerRow; k++){
          gindex++;
          if(gindex < _catGames.length){
            rowItems.add(BrowserGameThumb(data: _catGames[gindex], onClickHandler: onGameClickHandler));
          } else {
            rowItems.add(SizedBox(width: BrowserGameThumb.myWidth, height: BrowserGameThumb.myHeight ));
          }
        }
        categoryGameThumbsRows.add( Container(
          margin: EdgeInsets.only(bottom: _gameThumbsDistance / 2),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: rowItems))
        );

        _allRows += categoryGameThumbsRows;
      }

      //get recent (preferred) games
      // if (UserProvider.instance.logged){
        List<dynamic> userPrefs = UserProvider.instance.browsergamesPrefs;
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
      // }
    } // end of categories loop

    if (prefGames.length > 0){
        _allRows.insert(0,
            Container(
              width:myWidth,
              margin: EdgeInsets.only(bottom : _gameThumbsDistance / 2),
              height: 30,
              color: Theme.of(context).secondaryHeaderColor,
              padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
              child: Text(AppLocalizations.of(context).translate("app_browsergames_category_recent") + " ("+ prefGames.length.toString()+")",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            )
        );

        int _recentRowsNum = (prefGames.length / _gameThumbsPerRow).ceil();
        List<Widget> recentRowItems = [];
        int rindex = -1;
        for (int m = 0; m < _recentRowsNum; m++){
          for(int r = 0; r < _gameThumbsPerRow; r++){
            rindex++;
            if(rindex < prefGames.length){
              recentRowItems.add(BrowserGameThumb(data: prefGames[rindex], onClickHandler: onGameClickHandler));
            } else {
              recentRowItems.add(SizedBox(width: BrowserGameThumb.myWidth, height: BrowserGameThumb.myHeight ));
            }
          }

          _allRows.insert(1+m, Container(
              margin: EdgeInsets.only(bottom: _gameThumbsDistance / 2),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: recentRowItems))
          );
        }
      }

    setState(() {
      _ready = true;
      _onAppProviderListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Root.AppSize.width - GlobalSizes.panelWidth,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child:
            new DraggableScrollbar(
              alwaysVisibleScrollThumb: true,
              heightScrollThumb: 100.0,
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
                  height: 100,
                  width: 9.0,
                );
              },
          controller: _controller,
          child:
          ListView(
            key: new GlobalKey(),
            controller: _controller,
            // itemExtent: BrowserGameThumb.myHeight + 50,
            children: _allRows,
          ),
        )
    );
  }
}
