// ignore: avoid_web_libraries_in_flutter
import 'dart:async' show Future;
import 'dart:convert';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames_category_row.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

import '../../main.dart';


class BrowserGames extends StatefulWidget {
  BrowserGames();

  BrowserGamesState createState() => BrowserGamesState();
}

class BrowserGamesState extends State<BrowserGames> {
  BrowserGamesState();

  RenderBox renderBox;
  BrowserGamesInfo _gamesData;
  bool _dataFetched = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["strategy", "virtualworlds", "simulation", "farms", "action", "rpg"];
  ScrollController _controller;
  int _maxPrefGames = 10;

  List<BrowserGamesCategoryRow> _rows = [];
  List<BrowserGameInfo> prefGames = [];

  onGameClickHandler(BrowserGameInfo gameInfo) async {
    print("lets play " + gameInfo.gameName);

    if (UserProvider.instance.logged){
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
    }

    if (await canLaunch(gameInfo.gameUrl)) {
      await launch(gameInfo.gameUrl);
    } else {
      throw 'Could not launch ' + gameInfo.gameUrl;
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
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _controller = ScrollController();
    _refresh();
  }

  createListContent() {
    categories.removeWhere((category) => category == "recent");
    prefGames = [];
    _rows = [];

    // zero out prefs;
    // List<dynamic> _prefs = UserProvider.instance.browsergamesPrefs;
    // _prefs.clear();
    // UserProvider.instance.browsergamesPrefs = _prefs;

    for (int i = 0; i < categories.length; i++) {
      List<BrowserGameInfo> _catGames = _gamesData.browserGames.where((game) => game.category == categories[i]).toList();
      _catGames.sort((a, b) => a.order.compareTo(b.order));
      BrowserGamesCategoryRow row =  new BrowserGamesCategoryRow(
        categoryName: AppLocalizations.of(context).translate("app_browsergames_category_" + categories[i]),
        data: _catGames,
        myWidth: myWidth-10,
        thumbClickHandler: onGameClickHandler,
      );
      _rows.add(row);

      if (UserProvider.instance.logged){
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
      }
    }

    if (prefGames.length > 0){
      print("prefGames.length = "+prefGames.length.toString());
      BrowserGamesCategoryRow row =  new BrowserGamesCategoryRow(
        categoryName: AppLocalizations.of(context).translate("app_browsergames_category_recent"),
        data: prefGames,
        myWidth: myWidth-10,
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
  Widget build(BuildContext context) {
    return SizedBox(
        width: Root.AppSize.width - GlobalSizes.panelWidth,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: !_dataFetched
            ? Container()
            : new DraggableScrollbar(
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
          child: ListView(
            controller: _controller,
            // itemExtent: BrowserGameThumb.myHeight + 50,
            children: _rows,
          ),
        )
    );
  }
}
