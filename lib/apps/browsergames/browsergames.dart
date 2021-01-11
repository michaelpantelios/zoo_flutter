// ignore: avoid_web_libraries_in_flutter
import 'dart:async' show Future;
import 'dart:convert';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_thumb.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames_category_row.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';


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

  List<List<BrowserGameInfo>> rowGamesData = new List<List<BrowserGameInfo>>();

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
    _controller = ScrollController();
    loadGames().then((value) => createListContent());
  }

  createListContent() {
    for (int i = 0; i < categories.length; i++) {
      List<BrowserGameInfo> _catGames = _gamesData.browserGames.where((game) => game.category == categories[i]).toList();

      _catGames.sort((a, b) => a.order.compareTo(b.order));
      rowGamesData.add(_catGames);
    }

    setState(() {
      _dataFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - GlobalSizes.panelWidth,
        height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
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
          child: ListView.builder(
            controller: _controller,
            itemExtent: BrowserGameThumb.myHeight + 50,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(padding: EdgeInsets.only(right: 10), child:BrowserGamesCategoryRow(
                categoryName: AppLocalizations.of(context).translate("app_browsergames_category_" + categories[index]),
                data: rowGamesData[index],
                myWidth: myWidth-10,
                thumbClickHandler: onGameClickHandler,
              ));
            },
          ),
        )
    );
  }
}
