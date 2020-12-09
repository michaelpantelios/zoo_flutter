// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class MultiGamesFrame extends StatefulWidget {
  final GameInfo gameInfo;

  MultiGamesFrame({Key key, this.gameInfo}) : super(key: key);

  @override
  _MultiGamesFrameState createState() => _MultiGamesFrameState();
}

class _MultiGamesFrameState extends State<MultiGamesFrame> {
  final html.IFrameElement _gameFrameElement = html.IFrameElement();
  Widget _gameFrameWidget;

  @override
  void initState() {
    super.initState();

    if (widget.gameInfo == null) return;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('gameIframeElement' + widget.gameInfo.gameid, (int viewId) => _gameFrameElement);
    print("HtmlElementView key: ${widget.key}");
    _gameFrameWidget = HtmlElementView(key: widget.key, viewType: 'gameIframeElement' + widget.gameInfo.gameid);

    var zooWebUrl = "${widget.gameInfo.gameUrl.replaceAll('/fb/', '/web/')}&zooSessionKey=${UserProvider.instance.sessionKey}";
    _gameFrameElement.src = zooWebUrl;
    _gameFrameElement.style.border = "none";
    _gameFrameElement.style.padding = "0";

    print("_gameFrameElement.src: " + _gameFrameElement.src);
  }

  Size calculateIframeSize() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //considering game is 1920x1080
    double portraitGameRatio = 1080 / 1920;
    double landscapeGameRatio = 1.777;

    double iframeHeight;
    double iframeWidth;

    if (widget.gameInfo.orientation == "portrait") {
      iframeHeight = screenHeight - 100;
      iframeWidth = iframeHeight * portraitGameRatio;
    } else {
      iframeHeight = screenHeight - 100;
      iframeWidth = iframeHeight * landscapeGameRatio;
      if (iframeWidth > screenWidth) {
        iframeWidth = screenWidth - 20;
        iframeHeight = iframeWidth / landscapeGameRatio;
      }
    }

    return new Size(iframeWidth, iframeHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameInfo == null) return Container();
    var nestedMultiGames = context.watch<AppBarProvider>().getNestedApps(AppType.Multigames);
    var currentNestedGameApp = nestedMultiGames.firstWhere((element) => element.id == widget.gameInfo.gameid, orElse: () => null);
    var frameIsActive = false;
    if (currentNestedGameApp != null) frameIsActive = currentNestedGameApp.active;
    return Center(
      child: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Color(0xaa000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2),
          ],
        ),
        height: frameIsActive ? calculateIframeSize().height : 0,
        width: frameIsActive ? calculateIframeSize().width : 0,
        child: _gameFrameWidget,
      ),
    );
  }
}
