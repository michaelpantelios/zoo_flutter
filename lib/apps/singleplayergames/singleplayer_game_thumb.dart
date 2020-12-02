import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';

class SinglePlayerGameThumb extends StatefulWidget{
  SinglePlayerGameThumb({Key key, this.data, this.onClickHandler});
  
  final SinglePlayerGameInfo data;
  final Function onClickHandler;

  static double myWidth = 100;
  static double myHeight = 150;

  SinglePlayerGameThumbState createState() => SinglePlayerGameThumbState();
}

class SinglePlayerGameThumbState extends State<SinglePlayerGameThumb>{
  SinglePlayerGameThumbState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.data.gameDesc,
      height: 50,
      preferBelow: true,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        border: Border.all(color: Colors.deepOrange, width: 1),
        borderRadius: BorderRadius.circular(5)
      ),
      textStyle: TextStyle(
        color: Colors.indigo,
        fontSize: 17,
        fontWeight: FontWeight.normal
      ),
      child: FlatButton(
        onPressed: (){
          widget.onClickHandler(widget.data);
        },
        child: Container(
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )

        ),
      )
    )
      ;
  }
}