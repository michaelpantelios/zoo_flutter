// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SuggestedMultigame extends StatefulWidget {
  SuggestedMultigame({Key key, @required this.onClickHandler, @required this.data})
      : assert(onClickHandler != null, data != null),
        super(key: key);

  static double myWidth = 80;
  static double myHeight = 80;

  final Function onClickHandler;
  final GameInfo data;

  SuggestedMultigameState createState() => SuggestedMultigameState();
}

class SuggestedMultigameState extends State<SuggestedMultigame> {
  SuggestedMultigameState({Key key});

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

      return  FlatButton(
            onPressed: () => onPlayGame(),
            child: Container(
                    width: SuggestedMultigame.myWidth,
                    height: SuggestedMultigame.myHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(Env.ASSET_URL(widget.data.icon), fit: BoxFit.fitWidth),
                        Container(
                            // padding: EdgeInsets.all(5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.data.name,
                                  style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )
                        ),
                      ],
                    )),
          );

  }
}
