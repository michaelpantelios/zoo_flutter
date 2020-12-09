// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class MultigameThumb extends StatefulWidget {
  MultigameThumb({Key key, @required this.onClickHandler, @required this.data})
      : assert(onClickHandler != null, data != null),
        super(key: key);

  static double myWidth = 200;
  static double myHeight = 210;

  final Function onClickHandler;
  final GameInfo data;

  MultigameThumbState createState() => MultigameThumbState();
}

class MultigameThumbState extends State<MultigameThumb> {
  MultigameThumbState({Key key});

  bool mouseOver = false;
  GlobalKey<ZButtonState> playButtonKey;

  onPlayGame() {
    widget.onClickHandler(widget.data.gameid);
  }

  @override
  void initState() {
    playButtonKey = GlobalKey<ZButtonState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gamesListContent() {
      return MouseRegion(
          onEnter: (_) {
            setState(() {
              mouseOver = true;
            });
          },
          onExit: (_) {
            setState(() {
              mouseOver = false;
            });
          },
          child: Card(
              borderOnForeground: false,
              shadowColor: Colors.black,
              elevation: mouseOver ? 12 : 4,
              child: Container(
                  width: MultigameThumb.myWidth,
                  height: MultigameThumb.myHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.data.name,
                                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Image.network(Env.ASSET_URL(widget.data.icon), width: MultigameThumb.myWidth, fit: BoxFit.fitWidth),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 40,
                            // padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                              color: Colors.green,
                            ),
                            child: ZButton(
                              key: playButtonKey,
                              buttonColor: Colors.green,
                              clickHandler: onPlayGame,
                              label: AppLocalizations.of(context).translate("app_multigames_btnPlay"),
                              labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              hasBorder: false,
                            ),
                          ))
                        ],
                      )
                    ],
                  ))));
    }

    return gamesListContent();
  }
}
