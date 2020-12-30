// ignore: avoid_web_libraries_in_flutter
import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames_category_row.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class BrowserGames extends StatefulWidget {
  BrowserGames();

  BrowserGamesState createState() => BrowserGamesState();
}

class BrowserGamesState extends State<BrowserGames> {
  BrowserGamesState();

  Widget content;
  RenderBox renderBox;
  BrowserGamesInfo _gamesData;
  bool _inited = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["strategy", "virtualworlds", "simulation", "farms", "action", "rpg"];
  ScrollController _controller;

  onGameClickHandler(BrowserGameInfo gameInfo) {
    print("lets play " + gameInfo.gameName);
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
    content = Container();
    _controller = ScrollController();
    loadGames().then((value) => createListContent());
  }


  createListContent() {
    setState(() {
      content = Container(
          width: myWidth,
          height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
          child: Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              child: ListView.builder(
                controller: _controller,
                // itemExtent: SinglePlayerGameThumb.myHeight+50,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  List<BrowserGameInfo> rowGamesData = _gamesData.browserGames.where((game) => game.category == categories[index]).toList();
                  rowGamesData.sort((a, b) => a.order.compareTo(b.order));
                  return BrowserGamesCategoryRow(
                    categoryName: AppLocalizations.of(context).translate("app_browsergames_category_" + categories[index]),
                    data: rowGamesData,
                    myWidth: myWidth,
                    thumbClickHandler: onGameClickHandler,
                  );
                },
              )));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inited) {
      myHeight = MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding;
      _inited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
