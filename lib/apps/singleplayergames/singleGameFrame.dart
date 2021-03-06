// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:zoo_flutter/js/zoo_lib.dart';

import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SingleGameFrame extends StatefulWidget {
  SingleGameFrame({Key key, this.gameInfo, this.availableSize, this.onCloseHandler}) : super(key: key);

  final Function onCloseHandler;
  final SinglePlayerGameInfo gameInfo;
  final Size availableSize;

  @override
  _SingleGameFrameState createState() => _SingleGameFrameState();
}

class _SingleGameFrameState extends State<SingleGameFrame> {
  Widget _gameFrameWidget;
  html.IFrameElement _gameFrameElement = html.IFrameElement();

  String _defaultUrl = "https://html5.gamedistribution.com/gamecode/";

  // ignore: non_constant_identifier_names
  String _2048legendUrl = "https://wanted5games.com/games/html5/2048-legend-new-en-s-iga-cloud/index.html?pub=515";
  String _zumbaManiaUrl = "https://wanted5games.com/games/html5/zumba-mania-new-en-s-iga-cloud/index.html?pub=515";

  String jellyUrl = "assets/data/jelly_bomb.html";
  String rocketateUrl = "assets/data/rocketate.html";

  _onClose() {
    widget.onCloseHandler();
  }

  _onFullScreen() {
    _gameFrameElement.requestFullscreen();
  }

  static getPath(String url) {
    if (html.window.location.href.contains("localhost")) return url;
    return Zoo.relativeToAbsolute("assets/"+url);
  }

  @override
  void initState() {
    print("INIT SINGLE GAME FRAME");
    super.initState();
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('gameIframeElement' + widget.gameInfo.gameId, (int viewId) => _gameFrameElement);
    _gameFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'gameIframeElement' + widget.gameInfo.gameId);

    String url = _defaultUrl.replaceAll("gamecode", widget.gameInfo.gameCode);

    if (widget.gameInfo.gameId == "2048legend"){
      url = _2048legendUrl;
    }

    if (widget.gameInfo.gameId == "zumbamania")
      url = _zumbaManiaUrl;

    if (widget.gameInfo.gameId == "jellybomb")
      url = getPath(jellyUrl);

    if (widget.gameInfo.gameId == "rocketate")
      url = getPath(rocketateUrl);

    _gameFrameElement.src = url;

    print("url = " + url);
    _gameFrameElement.style.border = "none";
    _gameFrameElement.style.padding = "0";
    if (widget.gameInfo.gameId == "2048legend")
      _gameFrameElement.name = "cloudgames-com";
    else _gameFrameElement.name = "";
  }

  Size _calculateIframeSize() {
    final double screenWidth = widget.availableSize.width;
    final double screenHeight = widget.availableSize.height - 150;

    double gameRatio = widget.gameInfo.gameWidth / widget.gameInfo.gameHeight;
    String orientation = widget.gameInfo.gameWidth > widget.gameInfo.gameHeight ? "landscape" : "portrait";

    double iframeHeight;
    double iframeWidth;

    if (orientation == "portrait") {
      iframeHeight = screenHeight;
      iframeWidth = iframeHeight * gameRatio;
    } else {
      iframeHeight = screenHeight;
      iframeWidth = iframeHeight * gameRatio;
      if (iframeWidth > screenWidth) {
        iframeWidth = screenWidth - 20;
        iframeHeight = iframeWidth / gameRatio;
      }
    }

    return new Size(iframeWidth, iframeHeight);
  }

  @override
  Widget build(BuildContext context) {
    var iframeSize = _calculateIframeSize();
    return Center(
        child: Container(
            padding: EdgeInsets.all(2),
            width: widget.availableSize.width,
            height: widget.availableSize.height - 80,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
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
                              widget.gameInfo.gameName,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                    Tooltip(
                        message: AppLocalizations.of(context).translate("tooltip_btnFullscreen"),
                        child: Container(
                            width: 40,
                            height: 30,
                            margin: EdgeInsets.only(right: 5),
                            child: ZButton(
                              key: new GlobalKey(),
                              clickHandler: _onFullScreen,
                              iconData: Icons.photo_size_select_large,
                              iconSize: 20,
                              iconColor: Colors.white,
                              buttonColor: Colors.green,
                            ))),
                    Tooltip(
                        message: AppLocalizations.of(context).translate("tooltip_btnClose"),
                        child: Container(
                            width: 40,
                            height: 30,
                            child: ZButton(
                              key: new GlobalKey(),
                              clickHandler: _onClose,
                              iconData: Icons.close,
                              iconSize: 20,
                              iconColor: Colors.white,
                              buttonColor: Colors.red,
                            )))
                  ],
                ),
                Container(
                    width: widget.availableSize.width,
                    height: 20,
                    child: Text(
                      widget.gameInfo.gameDesc,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    )),
                Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(color: Color(0xaa000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2),
                      ],
                    ),
                    width: iframeSize.width,
                    height: iframeSize.height,
                    child: _gameFrameWidget)
              ],
            )));
  }
}
