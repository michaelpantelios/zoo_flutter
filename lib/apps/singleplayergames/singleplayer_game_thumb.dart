import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';

class SinglePlayerGameThumb extends StatefulWidget {
  SinglePlayerGameThumb({Key key, this.data, this.onClickHandler});

  final SinglePlayerGameInfo data;
  final Function onClickHandler;

  static double myWidth = 135;
  static double myHeight = 170;

  SinglePlayerGameThumbState createState() => SinglePlayerGameThumbState();
}

class SinglePlayerGameThumbState extends State<SinglePlayerGameThumb> {
  SinglePlayerGameThumbState();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        widget.onClickHandler(widget.data);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: SinglePlayerGameThumb.myWidth,
          height: SinglePlayerGameThumb.myHeight,
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/singleplayergames/" + widget.data.gameIcon,
                    fit: BoxFit.fill,
                  )),
              SizedBox(height: 5),
              Text(
                widget.data.gameName,
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          )
      ),
    );
  }
}
