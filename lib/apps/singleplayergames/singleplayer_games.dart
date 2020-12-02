// ignore: avoid_web_libraries_in_flutter
import 'dart:async' show Future;
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_thumb.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleGameFrame.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SinglePlayerGames extends StatefulWidget{
  SinglePlayerGames();

  SinglePlayerGamesState createState() => SinglePlayerGamesState();
}

class SinglePlayerGamesState extends State<SinglePlayerGames>{
  SinglePlayerGamesState();

  Widget content;
  Widget listContent;
  Widget gameViewContent;
  RenderBox renderBox;
  SinglePlayerGamesInfo _gamesData;
  bool _inited = false;
  double myWidth;
  double myHeight;
  final double categoryRowHeight = 200;
  List<String> categories = ["brain", "casual", "arcade", "action", "classic", "match3", "shooter", "runner", "sports", "racing"];

  onCloseGame(){
    setState(() {
      content = listContent;
    });
  }

  onGameClickHandler(SinglePlayerGameInfo gameInfo){
    setState(() {
      print("lets play "+gameInfo.gameName);

      gameViewContent = Container(
        padding: EdgeInsets.all(2),
        width: myWidth,
        height: myHeight-80,
        decoration: BoxDecoration(
            color: Colors.black
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:  Container(
                      margin: EdgeInsets.only(top:5),
                      // width: myWidth / 2,
                      height: 30,
                      child: Text(
                        gameInfo.gameName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ), textAlign: TextAlign.center,
                      )
                  )
                ),
                Container(
                  width: 40,
                  height: 30,
                  child: ZButton(
                    key: new GlobalKey(),
                    clickHandler: onCloseGame,
                    iconData: Icons.close,
                    iconSize: 20,
                    iconColor: Colors.white,
                    buttonColor: Colors.red,
                  )
                )
              ],
            ),
            SingleGameFrame(gameInfo: gameInfo, availableSize: new Size(myWidth, myHeight)),
          ],
        )

      );

      content = gameViewContent;
    });
  }

  Future<void> loadGames() async {
    String jsonString = await rootBundle.loadString('assets/data/singleplayergames.json');
    final jsonResponse = json.decode(jsonString);
    _gamesData =  SinglePlayerGamesInfo.fromJson(jsonResponse);
  }

  _afterLayout(_){
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    content = Container();

    loadGames().then((value) => createContent());
  }

  Widget getCategoryRow(String categoryName, List<SinglePlayerGameInfo> gamesData){
    return Container(
        height: 200,
        child: Column(
          children: [
            Container(
              width: myWidth,
              height: 30,
              color: Colors.orange[700],
              padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
              child: Text(categoryName + " ("+gamesData.length.toString()+")",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
                width: myWidth,
                height: 170,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemCount:gamesData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                    return SinglePlayerGameThumb(
                        data: gamesData[index],
                        onClickHandler: onGameClickHandler,
                    );
                  },
                )
            )
          ],
        )
    );
  }

  createContent(){
    setState(() {
      print("createContent");
      listContent =
        Container(
          width: myWidth,
          height: myHeight-80,
          child:
          ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index){
             return getCategoryRow(
                 AppLocalizations.of(context).translate("app_singleplayergames_category_"+categories[index]),
                 _gamesData.singlePlayerGames.where((game) => game.category == categories[index]).toList()
             );
            },
        )
     );

      content = listContent;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inited){
      myHeight = MediaQuery.of(context).size.height;
      _inited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}