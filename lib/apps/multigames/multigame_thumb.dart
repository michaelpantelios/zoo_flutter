// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class MultigameThumb extends StatefulWidget {
  MultigameThumb({Key key, @required this.onClickHandler, @required this.data})
      : assert(onClickHandler != null, data != null),
        super(key: key);

  static double myWidth = 160;
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
          cursor: SystemMouseCursors.click,
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
          child: GestureDetector(
            onTap: () => onPlayGame(),
            child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  borderOnForeground: false,
                  shadowColor: Colors.black,
                  elevation: mouseOver ? 13 : 2,
                  child: Container(
                      width: MultigameThumb.myWidth,
                      height: MultigameThumb.myHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                            child: Image.asset(
                              "assets/images/multigames/${widget.data.gameid}.png",
                              fit: BoxFit.fitWidth,
                            ),
                         ),
                         Container(
                            width: MultigameThumb.myWidth,
                            height: 50,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color(0xFF222c37),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(9.0),
                                bottomRight: Radius.circular(9.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.data.name,
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )),
            ),
          ));
    }

    return gamesListContent();
  }
}
