import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/multigames/models/multigames_info.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SuggestedMultigame extends StatefulWidget {
  SuggestedMultigame({Key key, @required this.onClickHandler, @required this.data})
      : assert(onClickHandler != null, data != null),
        super(key: key);

  static double myWidth = 80;
  static double myHeight = 120;

  final Function onClickHandler;
  final GameInfo data;

  SuggestedMultigameState createState() => SuggestedMultigameState();
}

class SuggestedMultigameState extends State<SuggestedMultigame> {
  SuggestedMultigameState({Key key});

  GlobalKey<ZButtonState> playButtonKey;

  onPlayGame() {
    widget.onClickHandler(widget.data);
  }

  @override
  void initState() {
    playButtonKey = GlobalKey<ZButtonState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPlayGame(),
      child: MouseRegion( cursor: SystemMouseCursors.click, child: Container(
          width: SuggestedMultigame.myWidth,
          height: SuggestedMultigame.myHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset("assets/images/multigames/${widget.data.gameid}.png", fit: BoxFit.fitWidth),
              ),
              Flexible(
                child: Container(
                    width: SuggestedMultigame.myWidth,
                    child:
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                        Text(
                            widget.data.name,
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            softWrap: true
                        )
                   //   ],
                   // )
                ),
              )
            ],
          ))),
    );
  }
}
