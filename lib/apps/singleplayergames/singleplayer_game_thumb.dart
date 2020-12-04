import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';

class SinglePlayerGameThumb extends StatefulWidget{
  SinglePlayerGameThumb({Key key, this.data, this.onClickHandler});
  
  final SinglePlayerGameInfo data;
  final Function onClickHandler;

  static double myWidth = 180;
  static double myHeight = 240;

  SinglePlayerGameThumbState createState() => SinglePlayerGameThumbState();
}

class SinglePlayerGameThumbState extends State<SinglePlayerGameThumb>{
  SinglePlayerGameThumbState();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (){
          widget.onClickHandler(widget.data);
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: SinglePlayerGameThumb.myWidth,
            height: SinglePlayerGameThumb.myHeight,
            child : Column(
              children: [
                Image.asset("/images/singleplayergames/"+widget.data.gameIcon,
                    width: SinglePlayerGameThumb.myWidth,
                    height: SinglePlayerGameThumb.myWidth
                ),
                SizedBox(height: 5),
                Text(
                  widget.data.gameName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )
        ),
      );
  }
}