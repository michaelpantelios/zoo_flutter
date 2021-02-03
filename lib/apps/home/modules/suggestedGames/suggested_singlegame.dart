import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';

class SuggestedSinglegame extends StatefulWidget {
  SuggestedSinglegame({Key key, this.data, this.onClickHandler});

  final SinglePlayerGameInfo data;
  final Function onClickHandler;

  static double myWidth = 80;
  static double myHeight = 120;

  SuggestedSinglegameState createState() => SuggestedSinglegameState();
}

class SuggestedSinglegameState extends State<SuggestedSinglegame> {
  SuggestedSinglegameState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClickHandler(widget.data);
      },
      child: MouseRegion( cursor: SystemMouseCursors.click, child: Container(
          width: SuggestedSinglegame.myWidth,
          height: SuggestedSinglegame.myHeight,
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/singleplayergames/" + widget.data.gameIcon,
                    fit: BoxFit.fitWidth,
                  )),
              SizedBox(height: 5),
              Text(
                widget.data.gameName,
                style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          )
      )),
    );
  }
}
