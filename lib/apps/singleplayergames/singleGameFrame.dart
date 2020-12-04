import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleGameFrame.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';

class SingleGameFrame extends StatefulWidget {
  SingleGameFrame({Key key, this.gameInfo, this.availableSize}) : super(key : key);

  final SinglePlayerGameInfo gameInfo;
  final Size availableSize;

  @override
  _SingleGameFrameState createState() => _SingleGameFrameState();
}

class _SingleGameFrameState extends State<SingleGameFrame> {
  final html.IFrameElement _gameFrameElement = html.IFrameElement();
  Widget _gameFrameWidget;
  String defaultUrl= "https://html5.gamedistribution.com/gamecode/";

  @override
  void initState() {
    super.initState();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory( 'gameIframeElement', (int viewId) => _gameFrameElement);
    _gameFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'gameIframeElement');
    defaultUrl = defaultUrl.replaceAll("gamecode", widget.gameInfo.gameCode);

    _gameFrameElement.src = defaultUrl;
    print("src = "+_gameFrameElement.src);
    _gameFrameElement.style.border = "none";
    _gameFrameElement.style.padding = "0";
  }


  @override
  Widget build(BuildContext context) {

    Size calculateIframeSize() {
      final double screenWidth = widget.availableSize.width;
      final double screenHeight = widget.availableSize.height;

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
        if (iframeWidth > screenWidth){
          iframeWidth = screenWidth - 20;
          iframeHeight = iframeWidth / gameRatio;
        }
      }

      return new Size(iframeWidth, iframeHeight);
    }

    return Center(
      child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            boxShadow: [
              new BoxShadow(color: Color(0xaa000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2),
            ],
          ),
          height: calculateIframeSize().height,
          width: calculateIframeSize().width,
          child: _gameFrameWidget
      ),
    );
  }
}