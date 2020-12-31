// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class MultigameThumb extends StatefulWidget {
  MultigameThumb({Key key, @required this.onClickHandler, @required this.data})
      : assert(onClickHandler != null, data != null),
        super(key: key);

  static double myWidth = 200;
  static double myHeight = 200;

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
      return GestureDetector(
        onTap: () {
          onPlayGame();
        },
        child: Container(
          width: MultigameThumb.myWidth,
          height: MultigameThumb.myHeight,
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(color: Colors.grey, offset: new Offset(2.0, 2.0), blurRadius: 4, spreadRadius: 3),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.asset(
                  "assets/images/multigames/${widget.data.gameid}.png",
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xFF222c37),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(9.0),
                      bottomRight: Radius.circular(9.0),
                    ),
                  ),
                  width: MultigameThumb.myWidth,
                  height: 35,
                  child: Center(
                    child: Text(
                      widget.data.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return gamesListContent();
  }
}
