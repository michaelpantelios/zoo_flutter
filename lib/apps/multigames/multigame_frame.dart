// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import '../../main.dart';

class MultiGamesFrame extends StatefulWidget {
  final GameInfo gameInfo;

  MultiGamesFrame({Key key, this.gameInfo}) : super(key: key) {}

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
    _gameFrameWidget = HtmlElementView(viewType: 'gameIframeElement' + widget.gameInfo.gameid);

    var zooWebUrl = "";
    if (widget.gameInfo.gameUrl.isEmpty) {
      zooWebUrl = "https://www.zoo.gr/app/partner/publisher/zoo?app=${widget.gameInfo.gameid}&zooSessionKey=${UserProvider.instance.sessionKey}";
    } else {
      zooWebUrl = "${widget.gameInfo.gameUrl.replaceAll('/fb/', '/web/')}&zooSessionKey=${UserProvider.instance.sessionKey}";
    }

    _gameFrameElement.src = zooWebUrl;
    _gameFrameElement.style.border = "none";
    _gameFrameElement.style.padding = "0";

    print("_gameFrameElement.src: " + _gameFrameElement.src);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameInfo == null) return Container();
    var appInfo = context.watch<AppProvider>().currentAppInfo;
    var nestedMultiGames = context.watch<AppBarProvider>().getNestedApps(AppType.Multigames);
    var currentNestedGameApp = nestedMultiGames.firstWhere((element) => element.id == widget.gameInfo.gameid, orElse: () => null);
    var frameIsActive = false;
    if (currentNestedGameApp != null) frameIsActive = currentNestedGameApp.active && appInfo.id == AppType.Multigames;
    double screenWidth = Root.AppSize.width;
    double screenHeight = Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding;
    bool isPortrait = (widget.gameInfo.orientation == "portrait");

    print("MULTIGAMES FRAME -- BUILD!!!");
    return SizedBox(
      width: frameIsActive ? screenWidth : 0,
      height: frameIsActive ? screenHeight : 0,
      child: Align(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: isPortrait ? 9 / 16 : 16 / 9,
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              boxShadow: frameIsActive ? [new BoxShadow(color: Color(0xaa000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2)] : [],
            ),
            child: _gameFrameWidget,
          ),
        ),
      ),
    );
  }
}
