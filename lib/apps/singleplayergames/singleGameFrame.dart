// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:math';
import 'package:zoo_flutter/js/zoo_lib.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/utils.dart';

class SingleGameFrame extends StatefulWidget {
  SingleGameFrame({Key key, this.availableSize, this.onCloseHandler}) : super(key: key);

  final Function onCloseHandler;
  // final SinglePlayerGameInfo gameInfo;
  final Size availableSize;

  @override
  SingleGameFrameState createState() => SingleGameFrameState(key: key);
}

class SingleGameFrameState extends State<SingleGameFrame> {
  SingleGameFrameState({Key key});
  Widget _gameFrameWidget;
  html.IFrameElement _gameFrameElement = html.IFrameElement();

  SinglePlayerGameInfo _gameInfo;

  String _gamedistributionPublisherId = "gamedistribution";
  String _wanted5gamesPublisherId = "wanted5games";

  String _gameDistributionUrl = "https://html5.gamedistribution.com/gamecode/";
  String _wanted5gamesUrl = "https://wanted5games.com/games/html5/gamecode/index.html?pub=515";

  double iframeScale = 1.0;

  double unneededHeight = 60;

  double _availableGameHeight;

  _onClose() {
    widget.onCloseHandler();
  }

  _onFullScreen() {
    _gameFrameElement.requestFullscreen();
  }

  getSoftGamesPath(String gameId) {
    String url = "assets/data/singleplayergames/"+gameId+".html";
    if (html.window.location.href.contains("localhost")) return url;
    return Zoo.relativeToAbsolute("assets/"+url);
  }

  updateGame(SinglePlayerGameInfo gameInfo){
    setState(() {
      _gameInfo = gameInfo;
      _gameFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'gameIframeElement');

      String url = "";
      switch(gameInfo.publisher){
        case "gamedistribution":
          url = _gameDistributionUrl.replaceAll("gamecode", gameInfo.gameCode);
          break;
        case "wanted5games":
          url =  _wanted5gamesUrl.replaceAll("gamecode", gameInfo.gameCode);
          break;
        case "softgames":
          url = getSoftGamesPath(gameInfo.gameId);
          break;
      }

      iframeScale = min(( _availableGameHeight  / gameInfo.gameHeight ), 1.0);
      print("iframeScale = "+iframeScale.toString());

      print("url = " + url);
      _gameFrameElement.src = url;

      if (gameInfo.gameId == "2048legend")
        _gameFrameElement.name = "cloudgames-com";
      else _gameFrameElement.name = "";
    });
  }


  @override
  void initState() {
    print("INIT SINGLE GAME FRAME");
    super.initState();
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('gameIframeElement', (int viewId) => _gameFrameElement);

    _availableGameHeight = widget.availableSize.height - unneededHeight;

    _gameFrameElement.style.border = "none";
    _gameFrameElement.style.padding = "0";
    _gameFrameElement.style.backgroundColor = "#000000";
    _gameFrameElement.style.alignContent = "center";
    _gameFrameElement.style.zIndex = '10000';

  }

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(2),
            width: widget.availableSize.width,
            height: widget.availableSize.height,
            decoration: BoxDecoration(color: Colors.black),
            alignment: Alignment.center,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(top: 5),
                            // width: myWidth / 2,
                            height: 30,
                            child: Text(
                              _gameInfo != null ? _gameInfo.gameName : "",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                    // Tooltip(
                    //     message: AppLocalizations.of(context).translate("tooltip_btnFullscreen"),
                    //     child:
                        FlatButton(
                          onPressed: _onFullScreen,
                          child: Container(
                            width: 40,
                            height: 30,
                            color: Colors.green,
                            child: Center(
                              child: Icon(Icons.photo_size_select_large, color: Colors.white, size: 20)
                            )
                          )
                        ),
                        // ),
                        // Container(
                        //     width: 40,
                        //     height: 30,
                        //     margin: EdgeInsets.only(right: 5),
                        //     child: ZButton(
                        //       key: new GlobalKey(),
                        //       clickHandler: _onFullScreen,
                        //       iconData: Icons.photo_size_select_large,
                        //       iconSize: 20,
                        //       iconColor: Colors.white,
                        //       buttonColor: Colors.green,
                        //     )
                        //     )
                         //  ),
                    FlatButton(
                        onPressed:_onClose,
                        child: Container(
                            width: 40,
                            height: 30,
                            color: Colors.red,
                            child: Center(
                                child: Icon(Icons.close, color: Colors.white, size: 20)
                            )
                        )
                    ),
                    // Tooltip(
                    //     message: AppLocalizations.of(context).translate("tooltip_btnClose"),
                    //     child: Container(
                    //         width: 40,
                    //         height: 30,
                    //         child: ZButton(
                    //           key: new GlobalKey(),
                    //           clickHandler: _onClose,
                    //           iconData: Icons.close,
                    //           iconSize: 20,
                    //           iconColor: Colors.white,
                    //           buttonColor: Colors.red,
                    //         )))
                  ],
                ),
                Container(
                    width: widget.availableSize.width,
                    height: 20,
                    child: Text(
                      _gameInfo!=null ? _gameInfo.gameDesc : "",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    )
                ),
                 Center(
                   child: Transform.scale(
                       scale: iframeScale,
                       alignment: Alignment.topCenter,
                       child:SizedBox(
                           width: _gameInfo!= null ? double.parse(_gameInfo.gameWidth.toString()) : 1,
                           height: _gameInfo!= null ? double.parse(_gameInfo.gameHeight.toString()) : 1,
                           child: _gameFrameWidget
                       )
                   )
                 )

              ],
            ));
  }
}
