import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';

class SuggestedBrowsergame extends StatefulWidget {
  SuggestedBrowsergame({Key key, this.data, this.onClickHandler});

  final BrowserGameInfo data;
  final Function onClickHandler;

  static double myWidth = 80;
  static double myHeight = 120;

  SuggestedBrowsergameState createState() => SuggestedBrowsergameState();
}

class SuggestedBrowsergameState extends State<SuggestedBrowsergame> {
  SuggestedBrowsergameState();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        waitDuration: Duration(milliseconds: 400),
        message: widget.data.gameDesc,
        height: 20,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.lightGreen[50],
          border: Border.all(color: Colors.lightGreen[900], width: 1),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
          ],
        ),
        textStyle: TextStyle(color: Colors.lightGreen[900], fontSize: 13, fontWeight: FontWeight.normal),
        child: FlatButton(
          onPressed: () async {
           widget.onClickHandler(widget.data.gameId);
          },
          child: Container(
              width: SuggestedBrowsergame.myWidth,
              height: SuggestedBrowsergame.myHeight,
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/browsergames/" + widget.data.gameIcon,
                        fit: BoxFit.fitWidth,
                      )),
                  SizedBox(height: 5),
                  Text(
                    widget.data.gameName,
                    style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
        ));
  }
}
