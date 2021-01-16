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

  List<List<SinglePlayerGameInfo>> rowGamesData = new List<List<SinglePlayerGameInfo>>();

  onCloseGame() {
    setState(() {
      _gameVisible = false;
    });
  }

  onGameClickHandler(SinglePlayerGameInfo gameInfo) async {
    setState(() {
      print("lets play " + gameInfo.gameName);

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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    print("init state");
    super.initState();
    gameViewContent = Container();
    _controller = ScrollController();
    loadGames().then((_) {
      createListContent();
    });
  }

  createListContent() {
    setState(() {
      for (int i = 0; i < categories.length; i++) {
        List<SinglePlayerGameInfo> _catGames = _gamesData.singlePlayerGames.where((game) => game.category == categories[i]).toList();
        _catGames.sort((a, b) => a.order.compareTo(b.order));
        rowGamesData.add(_catGames);
      }

      setState(() {
        _dataFetched = true;
      });
    });
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
                    child: ListView.builder(
                      controller: _controller,
                      // itemExtent: SinglePlayerGameThumb.myHeight+50,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(padding: EdgeInsets.only(right: 10), child:
                          SinglePlayerCategoryRow(
                            categoryName: AppLocalizations.of(context).translate("app_singleplayergames_category_" + categories[index]),
                            data: rowGamesData[index],
                            myWidth: myWidth - 10,
                            thumbClickHandler: onGameClickHandler,
                          )
                        );
                      },
                    )),
            Visibility(visible: _gameVisible, child: gameViewContent),
          ],
        ));
  }
}
